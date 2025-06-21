import 'package:ardour_ai/app/data/models.dart';
import 'package:ardour_ai/app/data/storage_service.dart';
import 'package:get/get.dart';

class ChatsController extends GetxController {
  StorageServices storageServices = StorageServices();
  RxList<PassUser> contacts = <PassUser>[].obs;

  RxBool isReady = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchContacts();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  fetchContacts() async {
    contacts.value = await storageServices.readContacts();
    isReady.value = true;
  }
}
