import 'dart:convert';

import 'package:ardour_ai/app/data/models.dart';
import 'package:ardour_ai/app/data/storage_service.dart';
import 'package:ardour_ai/app/data/websocket_models.dart';
import 'package:ardour_ai/main.dart';
import 'package:get/get.dart';

class ChatsController extends GetxController {
  RxList<PassUser> contacts = <PassUser>[].obs;
  RxList<ContactWithPreview> recentChatsList = <ContactWithPreview>[].obs;

  RxBool isReady = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchContacts();
    fetchRecentChatsList();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  fetchRecentChatsList() {
    MainController.service.addListener((data) {
      final parsedData = jsonDecode(data);
      if (parsedData['data'] != null) {
        final recievedData = parsedData['data'];
        if (recievedData['type'] == WSModuleType.Account &&
            recievedData['resType'] == AccountResType.RECENT_CHATS_LIST) {
          recentChatsList.value =
              (recievedData['data']['recentChats'] as List)
                  .map(
                    (contactWithPreview) => ContactWithPreview(
                      contact: PassUser.fromJSON(contactWithPreview['contact']),
                      recentMessages:
                          (contactWithPreview['recentMessages'] as List?)
                              ?.map((raw) => ChatMessage.fromJson(raw))
                              .toList(),
                    ),
                  )
                  .toList();
        }
      }
    });

    MainController.service.send(
      WSBaseRequest(
        type: WSModuleType.Account,
        reqType: AccountReqType.GET_RECENT_CHATS_LIST,
        data: {},
      ),
    );
  }

  fetchContacts() async {
    contacts.value = await MainController.storageService.readContacts();
    Map<String, PersonalChat> personalChats = {};
    final allChats = await MainController.storageService.readAllPersonalChats();
    for (var contact in contacts) {
      final chat = allChats.firstWhereOrNull(
        (chat) => chat.contactId == contact.userId,
      );
      if (chat != null) {
        personalChats.addAll({contact.userId: chat});
        recentChatsList.add(
          ContactWithPreview(contact: contact, recentMessages: chat.messages),
        );
      } else {
        recentChatsList.add(ContactWithPreview(contact: contact));
      }
    }

    recentChatsList.sort((user1, user2) {
      final user1Chat = personalChats[user1.contact.userId];
      final user2Chat = personalChats[user2.contact.userId];

      if (user1Chat == null && user2Chat == null) return 0;
      if (user1Chat == null) return 1;
      if (user2Chat == null) return -1;

      final user1Messages = user1Chat.messages;
      final user2Messages = user2Chat.messages;

      final user1HasMessages = user1Messages.isNotEmpty;
      final user2HasMessages = user2Messages.isNotEmpty;

      if (!user1HasMessages && !user2HasMessages) return 0;
      if (!user1HasMessages) return 1;
      if (!user2HasMessages) return -1;

      // Now both have messages
      final user1Time = user1Messages.last.timestamp;
      final user2Time = user2Messages.last.timestamp;

      return user2Time.compareTo(user1Time);
    });

    isReady.value = true;
  }
}
