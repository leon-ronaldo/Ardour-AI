import 'package:get/get.dart';

import '../controllers/personal_chat_controller.dart';

class PersonalChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonalChatController>(
      () => PersonalChatController(),
    );
  }
}
