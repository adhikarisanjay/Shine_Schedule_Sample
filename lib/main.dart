import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shine_schedule/config/router/messaging.dart';
import 'package:shine_schedule/config/router/notification_service.dart';
import 'package:shine_schedule/config/router/router_provider.dart';
import 'package:shine_schedule/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationService.initNotification();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  Stripe.publishableKey =
      '';
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    final messagingService = MessagingService();
    messagingService.initialize();
    final router = ref.watch(routeProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: ShineColors.background),
          useMaterial3: true,
          listTileTheme: ListTileThemeData(
            shape: Border.all(color: Colors.transparent),
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            horizontalTitleGap: 0.0,
            minLeadingWidth: 0,
            dense: true,
          ),
          expansionTileTheme: ExpansionTileThemeData(
            shape: Border.all(color: Colors.transparent),
          ) //removes additional space vertically
          ),
      routerConfig: router,
    );
  }
}
