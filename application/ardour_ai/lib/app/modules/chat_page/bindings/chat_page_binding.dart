import 'package:get/get.dart';

import '../controllers/chat_page_controller.dart';

class ChatPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatPageController>(
      () => ChatPageController(),
    );
  }
}
