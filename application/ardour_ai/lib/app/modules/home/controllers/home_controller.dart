// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'package:ardour_ai/app/data/websocket_models.dart';
import 'package:ardour_ai/app/data/websocket_service.dart';
import 'package:ardour_ai/app/routes/app_pages.dart';
import 'package:ardour_ai/app/utils/widgets/snackbar.dart';
import 'package:ardour_ai/main.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  WebSocketService service = WebSocketService();

  RxList<String> contacts = <String>[].obs;
  RxList<String> groups = <String>[].obs;

  RxBool isReady = false.obs;

  @override
  void onInit() {
    super.onInit();
    connectServer().then((didConnect) {
      if (didConnect) {
        isReady.value = true;
        getContacts();
      }
    });
  }

  Future<bool> connectServer() async {
    String? token = await MainController.accessToken;
    if (token == null) {
      Get.offAllNamed(Routes.AUTHENTICATION);
      return false;
    } else
      try {
        if (service.isConnected) await service.close();
        service.connect(token: token);
        service.addEventListeners(
          listenData,
          errorListener: listenError,
          serverCloseListener: listenClose,
        );
        return true;
      } on Exception catch (e) {
        print("namma home la oru error pa connect panna pothu $e");
        noServerError();
        return false;
      }
  }

  void listenClose(int? code, String? reason) {
    if (code == null) return;
    if (code == 4003) Get.offAllNamed(Routes.AUTHENTICATION);
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

  void listenError(dynamic error) {}

  void getContacts() async {
    final request = WSBaseRequest(
      type: WSModuleType.Account,
      reqType: AccountReqType.GET_CONTACTS,
      data: {},
    );

    service.send(request);
  }

  void moduleRouter(WSBaseResponse response) {
    switch (response.type) {
      case WSModuleType.Account:
        accountRouter(response);
        break;
      case WSModuleType.Chat:
        chatRouter(response);
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
        contacts.value = List<String>.from(response.data['contacts']);
        break;
      case AccountResType.GROUPS_LIST:
        groups.value = response.data['groups'];
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
}
