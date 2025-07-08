import 'package:ardour_ai/app/data/storage_service.dart';
import 'package:ardour_ai/app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
        );

    _notificationsPlugin.initialize(initializationSettings);
  }

  static void showNotification(RemoteMessage message) {
    final data = message.data;

    // Prefer values from data payload if available
    final String title =
        data['notificationName'] ?? message.notification?.title ?? 'No Title';

    final String body =
        data['notificationContent'] ?? message.notification?.body ?? 'No Body';

    // Optionally parse timestamp if needed
    final String? rawTimestamp = data['timestamp'];
    final int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'high_importance_channel', // must match FCM channelId
          'High Importance Notifications',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    _notificationsPlugin.show(
      id, // unique ID
      title, // title aligned with FCM payload
      body, // body aligned with FCM payload
      platformDetails,
    );
  }
}

class NotificationService {
  Future<void> initNotifications() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        LocalNotificationService.showNotification(message);
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      final data = message.data;

      if (data['notificationType'] == 'PERSONAL_CHAT' &&
          data['senderId'] != null) {
        final senderId = data['senderId'];

        final sender = (await StorageServices().readContacts())
            .firstWhereOrNull((contact) => contact.userId == senderId);
        if (sender != null) {
          Get.toNamed(Routes.PERSONAL_CHAT, arguments: {"contact": sender});
        }
      }
    });
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  LocalNotificationService.showNotification(message);
}
