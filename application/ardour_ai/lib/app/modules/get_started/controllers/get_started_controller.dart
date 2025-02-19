import 'dart:convert';

import 'package:ardour_ai/app/routes/app_pages.dart';
import 'package:ardour_ai/app/utils/functional_utils/api_endpoints.dart';
import 'package:ardour_ai/app/utils/functional_utils/network_functions.dart';
import 'package:ardour_ai/main.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GetStartedController extends GetxController {
  RxBool isReady = false.obs;

  List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> login() async {
    isReady.value = false;
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
      'email',
      'profile',
      'https://www.googleapis.com/auth/userinfo.profile',
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/user.phonenumbers.read' // Request phone access
    ]);

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        print("User canceled sign-in");
        return; // User canceled sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Extract more user details
      String? displayName = googleUser.displayName;
      String? firstName = displayName?.split(' ').first;
      String? lastName = displayName!.split(' ').length > 1
          ? displayName?.split(' ').last
          : "";
      String? email = googleUser.email;
      String? photoUrl = googleUser.photoUrl;

      // Send to server
      final response =
          await customPost(ApiEndpoints.googleLogin.endPoint, body: {
        "email": email,
        "userName": displayName,
        "firstName": firstName,
        "lastName": lastName,
        "profilePic": photoUrl,
      });

      if (checkNetworkIssue(response)) {
        isReady.value = true;
        return;
      }

      final data = jsonDecode(response.body);

      await MainController.secureStorage
          .write(key: "accessToken", value: data['accessToken']);

      isReady.value = true;
      Get.toNamed(Routes.CHAT_PAGE);
    } catch (error) {
      isReady.value = true;
      Get.snackbar(
          "Issue", "There was an issue signing in, please try again later");
      print("Sign-in error: $error");
    }
  }
}
