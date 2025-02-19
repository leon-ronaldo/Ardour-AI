import 'dart:convert';

import 'package:ardour_ai/app/routes/app_pages.dart';
import 'package:ardour_ai/app/utils/functional_utils/api_endpoints.dart';
import 'package:ardour_ai/app/utils/functional_utils/network_functions.dart';
import 'package:ardour_ai/main.dart';

Future<String> isLoggedIn() async {
  if (await MainController.secureStorage.containsKey(key: "accessToken")) {
    final response = await authorizedGET(ApiEndpoints.currentUser);

    if (checkNetworkIssue(response) || response.statusCode != 200) {
      // await OneSignal.logout();

      await MainController.secureStorage.deleteAll();
      return Routes.GET_STARTED;
    } else {
      await MainController.secureStorage
          .write(key: "userId", value: jsonDecode(response.body)['userId']);
      return Routes.CHAT_PAGE;
    }
  } else {
    await MainController.secureStorage.deleteAll();
    // await OneSignal.logout();
    return Routes.GET_STARTED;
  }
}
