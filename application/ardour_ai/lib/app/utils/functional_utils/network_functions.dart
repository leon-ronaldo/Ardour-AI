import 'dart:convert';
import 'dart:io';

import 'package:ardour_ai/app/utils/functional_utils/api_endpoints.dart';
import 'package:ardour_ai/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

bool checkNetworkIssue(http.Response response) => response.statusCode == 503;

Future<http.Response> customPost(String uri,
    {required Map body,
    Map<String, String> headers = const {
      'Content-Type': 'application/json'
    }}) async {
  if ((await Connectivity().checkConnectivity()).first ==
      ConnectivityResult.none) {
    Get.snackbar("Issue" ,"Please check your network connection!");
    return http.Response('{"error": "No network"}', 503);
  }

  try {
    return await http.post(Uri.parse(uri),
        body: jsonEncode(body), headers: headers);
  } on SocketException catch (e) {
    Get.snackbar("Issue" ,"Please check your network connection!");
    return http.Response('{"error": "No network"}', 503);
  }
}

Future<http.Response> authorizedGET(ApiEndpoints url) async {
  if ((await Connectivity().checkConnectivity()).first ==
      ConnectivityResult.none) {
    Get.snackbar("Issue", "Please check your network connection!");
    return http.Response('{"error": "No network"}', 503);
  }

  try {
    return await http.get(Uri.parse(url.endPoint), headers: {
      'Authorization':
          'Bearer ${(await MainController.secureStorage.read(key: 'accessToken'))}'
    });
  } on SocketException catch (e) {
    Get.snackbar("Issue", "Please check your network connection!");
    return http.Response('{"error": "No network"}', 503);
  } on http.ClientException catch (e) {
    Get.snackbar("Issue", "There is an issue connecting to the server. Try again later!");
    return http.Response('{"error": "No network"}', 503);
  }
}

Future<http.Response> authorizedPOST(ApiEndpoints url, data) async {
  return await customPost(url.endPoint, body: data, headers: {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer ${(await MainController.secureStorage.read(key: 'accessToken'))}'
  });
}
