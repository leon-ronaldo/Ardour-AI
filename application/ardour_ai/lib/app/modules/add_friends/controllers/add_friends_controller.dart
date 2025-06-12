import 'dart:convert';

import 'package:ardour_ai/app/data/websocket_models.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddFriendsController extends GetxController {
  RxList<Map<String, String>> searchListRecommendations =
      <Map<String, String>>[].obs;

  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    // Future.delayed(const Duration(seconds: 8), () {
    //   searchListRecommendations.value = [
    //     "_json_statham_**",
    //     "_arnd_swsnigger_12_45_",
    //   ];
    //   print("naa nan update panniten");
    // });

    // Future.delayed(const Duration(seconds: 12), () {
    //   searchListRecommendations.value = [
    //     "_json_wick_404_",
    //     "_binary_potter_7x_",
    //     "_neo_matrix_09__",
    //     "_arnd_termintr_808_",
    //     "_c0der_strange_1_",
    //     "_sudo_batman_1999_",
    //     "_algo_shelby_v1__",
    //     "_floyd_ping_007_",
    //     "_optic_thor_313_",
    //     "_gh0st_holmes_xx_",
    //   ];
    //   print("marupidiyum update panniten");
    // });
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
    MainController.service.addListener(dataListener);
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        searchListRecommendations.value = [];
      } else {
        MainController.service.send(
          WSBaseRequest(
            type: WSModuleType.Account,
            reqType: AccountReqType.QUERY_ACCOUNTS,
            data: {'query': searchController.text.trim()},
          ),
        );
      }
    });
  }

  void dataListener(dynamic data) {
    var parsedData;
    print("intha add friends la data: $data");
    try {
      parsedData = jsonDecode(data);
    } on Exception catch (e) {
      print("intha add friends la oru problem paa");
      return;
    }

    if (parsedData['data'] != null) {
      parsedData = parsedData['data'];
      if (parsedData['type'] == WSModuleType.Account &&
          parsedData['resType'] == AccountResType.QUERY_ACCOUNTS_LIST &&
          parsedData['data']['matchedQueries'] != null) {
        searchListRecommendations.value = List<Map<String, String>>.from(
          parsedData['data']['matchedQueries'].map<Map<String, String>>(
            (item) => Map<String, String>.from(item),
          ),
        );
      }
    } else {
      print("intha add friends la data null paa");
      return;
    }
  }
}
