import 'dart:convert';
import 'dart:io';

import 'package:ardour_ai/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPageController extends GetxController {
  RxList<Map<String, dynamic>> chats = <Map<String, dynamic>>[].obs;
  RxInt bgColorCounter = 0.obs;

  String userId = "";
  String recieverId = "67b3a47f0ea091e8da7275b4";

  WebSocket? socket;

  final chatScrollController = ScrollController();

  @override
  Future<void> onInit() async {
    super.onInit();
    userId = await MainController.secureStorage.read(key: "userId") ?? "";

    await connectWebSocket();
  }

  /// Function to connect to the WebSocket server with reconnection logic
  Future<void> connectWebSocket() async {
    try {
      socket = await WebSocket.connect('ws://10.0.2.2:8055?userId=$userId');
      print('Connected to WebSocket');

      socket!.listen(
        (data) {
          try {
            // Decode JSON received from WebSocket
            var decodedData = json.decode(data);
            if (decodedData is Map<String, dynamic>) {
              chats.add(decodedData);
            }
          } catch (e) {
            print("Error decoding WebSocket message: $e");
          }
        },
        onDone: () {
          print("WebSocket connection closed. Reconnecting...");
          reconnectWebSocket();
        },
        onError: (error) {
          print("WebSocket Error: $error");
          reconnectWebSocket();
        },
      );
    } catch (e) {
      print("WebSocket connection failed: $e");
      Future.delayed(
          Duration(seconds: 3), connectWebSocket); // Retry after delay
    }
  }

  /// Function to attempt reconnection if WebSocket disconnects
  void reconnectWebSocket() async {
    await Future.delayed(Duration(seconds: 3));
    await connectWebSocket();
  }

  /// Function to send a chat message
  void addChat(String text) {
    var message = json.encode({
      'senderId': userId,
      'receiverId': recieverId,
      'content': text,
    });

    socket?.add(message); // Send message if socket is open
    chats.add({'senderId': userId, 'content': text, 'receiverId': recieverId});
  }

  @override
  void onClose() {
    socket?.close();
    super.onClose();
  }
}
