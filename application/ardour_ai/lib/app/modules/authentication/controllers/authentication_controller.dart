import 'dart:convert';

import 'package:ardour_ai/app/data/websocket_models.dart';
import 'package:ardour_ai/app/data/websocket_service.dart';
import 'package:ardour_ai/app/routes/app_pages.dart';
import 'package:ardour_ai/app/utils/widgets/snackbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
    service.connect(url: authenticationURL);

    service.addListener((data) async {
      print("annachi from chennai: $data");

      var parsedData = jsonDecode(data);

      if (parsedData['data'] != null) {
        print(
          "nigga for confirmation:\naccess: ${parsedData['data']['data']['accessToken']}\nrefresh: ${parsedData['data']['data']['refreshToken']}",
        );
        final storage = FlutterSecureStorage();
        await storage.write(
          key: "userId",
          value: parsedData['data']['data']['userId'],
        );
        await storage.write(
          key: "accessToken",
          value: parsedData['data']['data']['accessToken'],
        );
        await storage.write(
          key: "refreshToken",
          value: parsedData['data']['data']['refreshToken'],
        );

        await storage.write(
          key: "profileImage",
          value: parsedData['data']['data']['profileImage'],
        );

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
        data: {
          "email": email,
          "userName": name,
          "profileImage": photo,
          "FCMtoken": await FirebaseMessaging.instance.getToken(),
        },
        // data: {"email": "jane.smith@example.com", "userName": "jane_smith", "profileImage": photo},
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

  Future<void> signInWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || !email.isEmail) {
      errorMessage(message: "Enter a valid email", title: "Invalid inputs");
      return;
    }

    if (password.isEmpty || password.length < 8) {
      errorMessage(message: "Enter a valid password", title: "Invalid inputs");
      return;
    }

    service.send(
      WSBaseRequest(
        type: WSModuleType.Authentication,
        reqType: "AUTHENTICATE_WITH_PASSWORD",
        data: {"email": email, "password": password, "FCMtoken": await FirebaseMessaging.instance.getToken()},
      ),
    );
  }
}
