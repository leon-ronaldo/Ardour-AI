// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:convert';
import 'package:ardour_ai/app/data/storage_service.dart';
import 'package:ardour_ai/app/data/websocket_models.dart';
import 'package:ardour_ai/app/data/websocket_service.dart';
import 'package:ardour_ai/app/routes/app_pages.dart';
import 'package:ardour_ai/app/utils/widgets/snackbar.dart';
import 'package:ardour_ai/main.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool isReady = false.obs;
  RxBool haveNotifications = false.obs;

  @override
  void onInit() {
    super.onInit();
    connectServer();
  }

  Future<bool> connectServer() async {
    String? token = await MainController.accessToken;

    if (token == null) {
      Get.offAllNamed(Routes.AUTHENTICATION);
      return false;
    } else {
      try {
        await MainController.service
            .connect(token: token, serverCloseListener: listenClose)
            .timeout(Duration(seconds: 8));

        MainController.service.addListener(listenData);

        getInitialData();
        return true;
      } on TimeoutException catch (_) {
        noServerError();
        return false;
      } finally {
        isReady.value = true;
      }
    }
  }

  void listenClose(int? code, String? reason) {
    if (code == 4003) {
      Future.delayed(Duration.zero, () {
        Get.offAllNamed(Routes.AUTHENTICATION);
      });
    }
  }

  void listenData(dynamic data) {
    print("data da: $data");
    final parsedData = jsonDecode(data);

    if (parsedData['data'] != null) {
      final responseData = parsedData['data'];
      moduleRouter(
        WSBaseResponse(
          type: responseData['type'],
          resType: responseData['resType'],
          data: responseData['data'],
        ),
      );
    } else if (parsedData['error'] != null) {
      print("error: $parsedData");
    }
  }

  void getInitialData() async {
    // check notifications
    MainController.service.send(
      WSBaseRequest(
        type: WSModuleType.Notification,
        reqType: NotificationReqType.CHECK_NOTIFICATIONS,
        data: {},
      ),
    );

    // get contacts
    if (DateTime.now()
            .difference(
              (await MainController.storageService.lastDateOfFetchedContacts ??
                  DateTime(2004, 8, 29)),
            ) // just a fallback time
            .inDays >
        4)
      MainController.service.send(
        WSBaseRequest(
          type: WSModuleType.Account,
          reqType: AccountReqType.GET_CONTACTS,
          data: {},
        ),
      );
  }

  void moduleRouter(WSBaseResponse response) {
    switch (response.type) {
      case WSModuleType.Account:
        accountRouter(response);
        break;
      case WSModuleType.Chat:
        chatRouter(response);
        break;
      case WSModuleType.Notification:
        notificationRouter(response);
        break;
      default:
        print("what bro?!");
        return;
    }
  }

  void chatRouter(WSBaseResponse response) {
    switch (response.resType) {
      case ChatResType.PRIVATE_CHAT_MESSAGE:
        break;
      case ChatResType.GROUP_CHAT_MESSAGE:
        break;
      default:
        print("ada broo!!");
        return;
    }
  }

  void accountRouter(WSBaseResponse response) {
    switch (response.resType) {
      case AccountResType.CONTACT_LIST:
        print("Received contacts: ${response.data}");
        MainController.storageService.writeContacts(response.data['contacts']);
        break;
      case AccountResType.GROUPS_LIST:
        break;
      case AccountResType.PRIVATE_CHAT_HISTORY:
        break;
      case AccountResType.GROUP_CHAT_HISTORY:
        break;
      default:
        print("Enaa paa!!");
        return;
    }
  }

  void notificationRouter(WSBaseResponse response) {
    switch (response.resType) {
      case NotificationResType.DID_HAVE_NOTIFICATIONS:
        haveNotifications.value = response.data['didHaveNotification'];
        break;
      default:
    }
  }
}
