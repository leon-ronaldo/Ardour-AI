// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:ardour_ai/app/data/models.dart';
import 'package:ardour_ai/app/data/websocket_models.dart';
import 'package:ardour_ai/app/utils/tools/debouncer.dart';
import 'package:ardour_ai/app/utils/widgets/snackbar.dart';
import 'package:ardour_ai/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddFriendsController extends GetxController {
  RxList<PassUser> searchListRecommendations = <PassUser>[].obs;

  RxList<PassUser> recommendedAccounts = <PassUser>[].obs;

  TextEditingController searchController = TextEditingController();

  late Debouncer _debouncer;

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
    _debouncer = Debouncer(duration: Durations.extralong4);
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
    MainController.service.send(
      WSBaseRequest(
        type: WSModuleType.Account,
        reqType: AccountReqType.RECOMMENDED_ACCOUNTS,
        data: {},
      ),
    );
    searchController.addListener(() {
      _debouncer.run(searchAccounts);
    });
  }

  void searchAccounts() {
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
  }

  void updateSearchRecommendations(parsedData) {
    try {
      searchListRecommendations.value = List<PassUser>.from(
        parsedData['data']['matchedQueries'].map(
          (item) => PassUser.fromJSON(item),
        ),
      );
    } on InvalidPassUserParameters catch (e) {
      print("pass user parse panrathula error");
    } on Exception catch (e) {
      print("pass user parse panrathula vera error $e");
    }
  }

  void updateRecommendedAccounts(parsedData) {
    try {
      recommendedAccounts.value = List<PassUser>.from(
        parsedData['data']['recommendedUsers'].map(
          (item) => PassUser.fromJSON(item),
        ),
      );
    } on InvalidPassUserParameters catch (e) {
      print("pass user parse panrathula error");
    } on Exception catch (e) {
      print("pass user parse panrathula vera error $e");
    }
  }

  void dataListener(dynamic data) {
    var parsedData;
    print("intha add friends la data: $data");
    try {
      parsedData = jsonDecode(data);
    } on Exception catch (e) {
      print("intha add friends la oru problem paa $e");
      return;
    }

    if (parsedData['data'] != null) {
      parsedData = parsedData['data'];
      if (parsedData['type'] == WSModuleType.Account) {
        switch (parsedData['resType']) {
          case AccountResType.QUERY_ACCOUNTS_LIST:
            _debouncer.run(
              () => updateSearchRecommendations(parsedData),
              altDuration: const Duration(milliseconds: 500),
            );
            break;
          case AccountResType.RECOMMENDED_ACCOUNTS_LIST:
            updateRecommendedAccounts(parsedData);
            break;
          case AccountResType.ACCOUNT_REQUEST_MADE:
            successMessage(
              title: "Request Successful",
              message: "Request made",
            );
            break;
          default:
            print(parsedData['data']);
        }
      }
    } else {
      print("intha add friends la data null paa");
      return;
    }
  }
}
