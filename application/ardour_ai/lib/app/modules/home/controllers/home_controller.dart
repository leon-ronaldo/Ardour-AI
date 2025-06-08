// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:ardour_ai/app/data/websocket_models.dart';
import 'package:ardour_ai/app/utils/constants.dart';
import 'package:ardour_ai/app/utils/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeController extends GetxController {
  late WebSocketChannel ws;

  RxList<String> contacts = <String>[].obs;
  RxList<String> groups = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (connectServer()) getContacts();
  }

  bool connectServer() {
    try {
      ws = WebSocketChannel.connect(Uri.parse(serverURL));
      ws.stream.listen(listenData, onError: listenError, onDone: onDone);
      return true;
    } on Exception catch (e) {
      noServerError();
      return false;
    }
  }

  void sendData(data) => ws.sink.add(jsonEncode(data));

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

  void onDone() {}

  void getContacts() async {
    final request = WSBaseRequest(
      type: WSModuleType.Account,
      reqType: AccountReqType.GET_CONTACTS,
      data: {},
    );

    sendData(request);
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
