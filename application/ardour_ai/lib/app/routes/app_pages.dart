import 'package:ardour_ai/app/modules/notifications_page/bindings/notifications_page_binding.dart';
import 'package:ardour_ai/app/modules/notifications_page/views/notifications_page_view.dart';
import 'package:get/get.dart';

import '../modules/add_friends/bindings/add_friends_binding.dart';
import '../modules/add_friends/views/add_friends_view.dart';
import '../modules/authentication/bindings/authentication_binding.dart';
import '../modules/authentication/views/authentication_view.dart';
import '../modules/chats/bindings/chats_binding.dart';
import '../modules/chats/views/chats_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/personal_chat/bindings/personal_chat_binding.dart';
import '../modules/personal_chat/views/personal_chat_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CHATS,
      page: () => const ChatsView(),
      binding: ChatsBinding(),
    ),
    GetPage(
      name: _Paths.PERSONAL_CHAT,
      page: () => const PersonalChatView(),
      binding: PersonalChatBinding(),
    ),
    GetPage(
      name: _Paths.AUTHENTICATION,
      page: () => const AuthenticationView(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.ADD_FRIENDS,
      page: () => const AddFriendsView(),
      binding: AddFriendsBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsPageView(),
      binding: NotificationsPageBinding(),
    ),
  ];
}
