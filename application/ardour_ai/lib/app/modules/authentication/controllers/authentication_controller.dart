import 'dart:convert';

import 'package:ardour_ai/app/data/websocket_models.dart';
import 'package:ardour_ai/app/data/websocket_service.dart';
import 'package:ardour_ai/app/routes/app_pages.dart';
import 'package:ardour_ai/app/utils/widgets/snackbar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationController extends GetxController {
  WebSocketService service = WebSocketService();

  List<String> scopes = <String>[
    'email',
    // 'https://www.googleapis.com/auth/contacts.readonly',
    'https://www.googleapis.com/auth/userinfo.profile',
    'https://www.googleapis.com/auth/userinfo.email',
  ];

  @override
  void onInit() {
    super.onInit();
    initializeService();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initializeService() async {
    if (service.isConnected) await service.close();
    service.connect(url: authenticationURL);

    service.addEventListeners((data) async {
      print("annachi from chennai: $data");

      var parsedData = jsonDecode(data);

      if (parsedData['data'] != null) {
        print(
          "nigga for confirmation:\naccess: ${parsedData['data']['data']['accessToken']}\nrefresh: ${parsedData['data']['data']['refreshToken']}",
        );
        final storage = FlutterSecureStorage();
        await storage.write(
          key: "accessToken",
          value: parsedData['data']['data']['accessToken'],
        );
        await storage.write(
          key: "refreshToken",
          value: parsedData['data']['data']['refreshToken'],
        );

        service.close();

        Get.toNamed(Routes.HOME);
      } else {
        serverError();
      }
    });
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: scopes);

    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        errorMessage(
          title: "SignIn Error",
          message: "Some issue occurred while signing in. Try again.",
        );
        return;
      }

      final String email = account.email;
      final String? name = account.displayName;
      final String? photo = account.photoUrl;

      print("✅ Google Sign-In Successful:");
      print("👤 Name: $name");
      print("📧 Email: $email");
      print("🖼️ Photo URL: $photo");

      final request = WSBaseRequest(
        type: WSModuleType.Authentication,
        reqType: "",
        data: {"email": email, "userName": name, "profileImage": photo},
      );

      service.send(request);
    } catch (error) {
      print("Google Sign-In Error: $error");
      errorMessage(
        title: "Signin error",
        message: "Some error occured while signing in",
      );
    }
  }
}
