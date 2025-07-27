// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:ardour_ai/app/data/models.dart';
import 'package:ardour_ai/app/data/storage_service.dart';
import 'package:ardour_ai/app/data/websocket_models.dart';
import 'package:ardour_ai/app/routes/app_pages.dart';
import 'package:ardour_ai/app/utils/tools/debouncer.dart';
import 'package:ardour_ai/app/utils/widgets/snackbar.dart';
import 'package:ardour_ai/main.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalChatController extends GetxController {
  late PassUser contact;
  final StorageServices storageService = StorageServices();
  final AudioPlayer audioPlayer = AudioPlayer();

  RxList<ChatMessage> chats = <ChatMessage>[].obs;
  Rx<ChatMessage?> repliedToMessage = Rx<ChatMessage?>(null);

  RxBool isReady = false.obs;
  RxBool isOnline = false.obs;
  RxBool isTyping = false.obs;

  RxDouble chatFieldHeight = 80.0.obs;
  final GlobalKey chatFieldKey = GlobalKey();

  String? userId;

  final ScrollController chatScrollController = ScrollController();
  final TextEditingController chatTextController = TextEditingController();
  final GlobalKey chatSectionKey = GlobalKey();
  final Debouncer debouncer = Debouncer(duration: Duration(milliseconds: 500));

  @override
  void onInit() {
    super.onInit();
    contact = Get.arguments['contact'];

    initialize();
    sendIsOnline(true);
    setIsTypingInformer();
    Future.delayed(Duration(milliseconds: 500), askContactIsOnline);
    Future.delayed(Duration(seconds: 2), askContactIsOnline);

    ever(repliedToMessage, (value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final box =
            chatFieldKey.currentContext?.findRenderObject() as RenderBox?;
        if (box != null) {
          final height = box.size.height;
          chatFieldHeight.value = height;
          print("nan mathiten laa ${chatFieldHeight.value}");
        }
      });
    });
  }

  @override
  void onClose() {
    sortChats();
    storageService.writePersonalChat(
      PersonalChat(contactId: contact.userId, messages: chats),
    );
    sendIsOnline(false);
    super.onClose();
  }

  void playMessageSentSound() {
    audioPlayer.play(AssetSource("audio/message-send.mp3"));
  }

  void playMessageRecievedSound() {
    audioPlayer.play(AssetSource("audio/message-recieve.wav"));
  }

  void initialize() async {
    final user = await MainController.user;

    if (user == null) {
      Get.offAllNamed(Routes.AUTHENTICATION);
      return;
    }

    userId = user.userId;

    listenData();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    final offlineMessages = await MainController.storageService
        .readPersonalChat(contact.userId);

    if (offlineMessages != null) {
      chats.value = offlineMessages.messages;
    }

    MainController.service.send(
      WSBaseRequest(
        type: WSModuleType.Account,
        reqType: AccountReqType.PRIVATE_CHAT_HISTORY,
        data: {"userId": contact.userId},
      ),
    );
  }

  void sortChats() => chats.sort(
    (a, b) => DateTime.fromMillisecondsSinceEpoch(
      a.timestamp,
    ).compareTo(DateTime.fromMillisecondsSinceEpoch(b.timestamp)),
  );

  void scrollToBottomSafely() {
    if (chatScrollController.hasClients)
      chatScrollController.animateTo(
        chatScrollController.position.maxScrollExtent + 50,
        duration: Durations.medium1,
        curve: Curves.easeIn,
      );
  }

  void sendIsOnline(bool isOnline) {
    MainController.service.send(
      WSBaseRequest(
        type: WSModuleType.Chat,
        reqType: ChatReqType.SET_IS_ONLINE,
        data: {"recieverId": contact.userId, "isOnline": isOnline},
      ),
    );
  }

  void askContactIsOnline() {
    MainController.service.send(
      WSBaseRequest(
        type: WSModuleType.Chat,
        reqType: ChatReqType.IS_USER_ONLINE,
        data: {"userId": contact.userId},
      ),
    );
  }

  void setIsTypingInformer() {
    chatTextController.addListener(() {
      if (chatTextController.text.trim().isNotEmpty) {
        MainController.service.send(
          WSBaseRequest(
            type: WSModuleType.Chat,
            reqType: ChatReqType.SET_IS_TYPING,
            data: {"recieverId": contact.userId, "isTyping": true},
          ),
        );
      } else {
        MainController.service.send(
          WSBaseRequest(
            type: WSModuleType.Chat,
            reqType: ChatReqType.SET_IS_TYPING,
            data: {"recieverId": contact.userId, "isTyping": false},
          ),
        );
      }
    });
  }

  void listenData() {
    MainController.service.addListener((data) {
      var parsedData = jsonDecode(data);

      if (parsedData['data'] != null) {
        final coreData = parsedData['data'];
        print("nan thaan coolie");
        print(coreData);

        if (coreData['type'] == WSModuleType.Account) {
          switch (coreData['resType']) {
            case AccountResType.PRIVATE_CHAT_HISTORY:
              parseMessages(coreData);
              break;
            default:
          }
        }

        if (coreData['type'] == WSModuleType.Chat) {
          print("dei bro thambi pathuko $coreData");
          switch (coreData['resType']) {
            case ChatResType.PRIVATE_CHAT_MESSAGE:
              addMessageToChat(
                ChatMessage.fromJson(coreData['data'])..isLiveMessage = true,
              );
              debouncer.run(playMessageRecievedSound);
              break;
            case ChatResType.USER_TYPING_STATUS:
              if (coreData['data']['userId'] == contact.userId)
                isTyping.value = coreData['data']['isTyping'];
              break;
            case ChatResType.USER_ONLINE_STATUS:
              if (coreData['data']['userId'] == contact.userId)
                isOnline.value = coreData['data']['isOnline'];
              break;
            default:
          }
        }
      }
    });
  }

  void parseMessages(parsedData) {
    try {
      chats.value = [
        ...(parsedData['data']['messages'] as List).map(
          (item) => ChatMessage.fromJson(item),
        ),
      ];

      sortChats();
      scrollToBottomSafely();
    } on Exception catch (e) {
      errorMessage(
        title: "Issue while fetching messages",
        message: e.toString(),
      );
    }
  }

  void addMessageToChat(ChatMessage message) {
    repliedToMessage.value = null;
    chats.add(message);

    if (chatScrollController.position.maxScrollExtent > 0.0) {
      scrollToBottomSafely();
    }

    debouncer.run(playMessageSentSound);
  }

  void sendText() {
    final message = chatTextController.text.trim();
    if (message.isNotEmpty) {
      ChatMessage chatMessage = ChatMessage(
        from: userId ?? "unknown",
        to: contact.userId,
        message: message,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      if (repliedToMessage.value != null) {
        chatMessage.repliedTo = repliedToMessage.value?.id;
      }

      print("anupa pothu chat epdi na ${chatMessage.toJson()}");

      MainController.service.send(
        WSBaseRequest(
          type: WSModuleType.Chat,
          reqType: ChatReqType.SEND_MSG,
          data: chatMessage.toJson(),
        ),
      );

      addMessageToChat(chatMessage..isLiveMessage = true);
      chatTextController.clear();
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
