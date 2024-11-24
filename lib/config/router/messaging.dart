import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shine_schedule/config/router/route_names.dart';
import 'notification_service.dart';

// Define a global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void initialize() {
    _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        NotificationService.showLocalNotification(
          message.notification!.title ?? '',
          message.notification!.body ?? '',
          message.data['payload'] ?? 'Test Payload',
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        _handleMessageNavigation(message.data);
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    if (message.notification != null) {
      NotificationService.showLocalNotification(
        message.notification!.title ?? '',
        message.notification!.body ?? '',
        message.data['payload'] ?? 'Test Payload',
      );
    }
  }

  void _handleMessageNavigation(Map<String, dynamic> data) {
    navigatorKey.currentState?.pushNamed(RouteNames.bookingInfo);
  }
}
