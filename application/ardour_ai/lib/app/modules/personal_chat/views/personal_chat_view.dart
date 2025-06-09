import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/personal_chat_controller.dart';

class PersonalChatView extends GetView<PersonalChatController> {
  const PersonalChatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PersonalChatView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PersonalChatView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
