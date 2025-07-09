import 'dart:convert';

import 'package:ardour_ai/app/data/models.dart';
import 'package:ardour_ai/app/data/storage_service.dart';
import 'package:ardour_ai/app/data/websocket_models.dart';
import 'package:ardour_ai/app/utils/widgets/snackbar.dart';
import 'package:ardour_ai/main.dart';
import 'package:get/get.dart';

class NotificationsPageController extends GetxController {
  RxList<AccountReqNotification> accountRequestNotifications =
      <AccountReqNotification>[].obs;

  RxBool isReady = false.obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void initialize() {
    try {
      MainController.service.addListener(listenData);
      MainController.service.send(
        WSBaseRequest(
          type: WSModuleType.Notification,
          reqType: NotificationReqType.GET_ACCOUNT_REQUESTS_NOTIFICATIONS,
          data: {},
        ),
      );
    } on Exception catch (e) {
      print("notification page la listener add panrathula error: $e");
    }
  }

  void listenData(data) {
    var parsedData;

    try {
      parsedData = jsonDecode(data);
    } catch (e) {
      print("notifications parse panrathula error: $e");
    }

    if (parsedData['data'] != null) {
      // reassing parsed data
      parsedData = parsedData['data'];

      // check if related to notification
      if (parsedData['type'] == WSModuleType.Notification &&
          parsedData['resType'] != null) {
        switch (parsedData['resType']) {
          case NotificationResType.ACCOUNT_REQUESTS_NOTIFICATIONS:
            parseAccountReqNotifications(parsedData);
            break;
          default:
            print("some invalid response data ${parsedData}");
        }
      }

      // check if related to notification
      if (parsedData['type'] == WSModuleType.Account &&
          parsedData['resType'] != null) {
        switch (parsedData['resType']) {
          case AccountResType.ACCOUNT_REQUEST_ACCEPTED:
            successMessage(
              title: "Request Accepted",
              message: "Accepted ${parsedData['data']['userName']}'s request",
            );
            MainController.service.send(
              WSBaseRequest(
                type: WSModuleType.Account,
                reqType: AccountReqType.GET_CONTACTS,
                data: {},
              ),
            );
            break;
          default:
            print("some invalid response data ${parsedData}");
        }
      }
    }
  }

  void parseAccountReqNotifications(parsedData) {
    try {
      accountRequestNotifications.value = [
        ...parsedData['data']['accountRequestNotifications'].map(
          (notification) => AccountReqNotification.fromJson(notification),
        ),
      ];
      isReady.value = true;
    } on Exception catch (e) {
      print("notification page la notifications pass panna pothu error: $e");
    }
  }

  void acceptAccountRequest(String userId) {
    MainController.service.send(
      WSBaseRequest(
        type: WSModuleType.Account,
        reqType: AccountReqType.ACCEPT_REQUEST,
        data: {"userId": userId},
      ),
    );
  }
}
