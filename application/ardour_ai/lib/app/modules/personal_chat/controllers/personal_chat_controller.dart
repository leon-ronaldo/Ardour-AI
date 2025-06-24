// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:ardour_ai/app/data/models.dart';
import 'package:ardour_ai/app/data/storage_service.dart';
import 'package:ardour_ai/app/data/websocket_models.dart';
import 'package:ardour_ai/app/routes/app_pages.dart';
import 'package:ardour_ai/app/utils/widgets/snackbar.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalChatController extends GetxController {
  late PassUser contact;
  final StorageServices storageService = StorageServices();

  RxList<ChatMessage> chats = <ChatMessage>[].obs;
  RxBool isReady = false.obs;
  RxBool isOnline = false.obs;
  RxBool isTyping = false.obs;
  String? userId;

  final ScrollController chatScrollController = ScrollController();
  final TextEditingController chatTextController = TextEditingController();
  final GlobalKey chatSectionKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    contact = Get.arguments['contact'];

    initialize();
    sendIsOnline(true);
    setIsTypingInformer();
    Future.delayed(Duration(milliseconds: 500), askContactIsOnline);
    Future.delayed(Duration(seconds: 2), askContactIsOnline);
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

  void initialize() async {
    userId = await MainController.userId;

    if (userId == null) {
      Get.offAllNamed(Routes.AUTHENTICATION);
      return;
    }

    listenData();
    fetchMessages();
  }

  void fetchMessages() {
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
    } on Exception catch (e) {
      errorMessage(
        title: "Issue while fetching messages",
        message: e.toString(),
      );
    }
  }

  void addMessageToChat(ChatMessage message) {
    // final renderBox =
    //     chatSectionKey.currentContext?.findRenderObject() as RenderBox?;
    chats.add(message);

    if (chatScrollController.position.maxScrollExtent > 0.0) {
      chatScrollController.animateTo(
        chatScrollController.position.maxScrollExtent + 80,
        duration: Durations.medium1,
        curve: Curves.easeIn,
      );
    }
  }

  void sendText() {
    final message = chatTextController.text.trim();
    if (message.isNotEmpty) {
      final chatMessage = ChatMessage(
        from: userId ?? "unknown",
        to: contact.userId,
        message: message,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );
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
