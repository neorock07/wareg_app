import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wareg_app/Activity/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wareg_app/Routes/Route.dart';
import 'Controller/message_controller.dart';
import 'Services/transaction_service.dart';
import 'firebase_options.dart';

const AndroidNotificationChannel transactionChannel =
    AndroidNotificationChannel(
  'transaction_channel', // id
  'Transaction Notifications', // title
  description:
      'This channel is used for transaction notifications.', // description
  importance: Importance.high,
);

const AndroidNotificationChannel messageChannel = AndroidNotificationChannel(
  'message_channel', // id
  'Message Notifications', // title
  description: 'This channel is used for message notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Handling a background message: ${message.messageId}');
  _showLocalNotification(message);
}

void _showLocalNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  String channelId = message.data['type'] == 'message'
      ? messageChannel.id
      : transactionChannel.id;

  String channelName = message.data['type'] == 'message'
      ? messageChannel.name
      : transactionChannel.name;

  String? channelDescription = message.data['type'] == 'message'
      ? messageChannel.description
      : transactionChannel.description;

  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          icon: 'ic_launcher',
          importance: Importance.max, // Set importance to max
          priority: Priority.high, // Set priority to high
          ticker: 'ticker',
        ),
      ),
    );
  }
}

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  Get.put(TransactionService());
  await initializeDateFormatting('id', null);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MessageController _messageController = Get.put(MessageController());

  @override
  void initState() {
    super.initState();
    _checkAndSaveFcmToken();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });
  }

  Future<void> _checkAndSaveFcmToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedToken = prefs.getString('fcm_token');

    if (savedToken == null) {
      FirebaseMessaging.instance.getToken().then((token) {
        if (token != null) {
          if (token != savedToken) {
            _messageController.saveFcmToken(token);
          }
          prefs.setString('fcm_token', token);
        }
      });
    }
  }

  void _showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    String channelId = message.data['type'] == 'message'
        ? messageChannel.id
        : transactionChannel.id;

    String channelName = message.data['type'] == 'message'
        ? messageChannel.name
        : transactionChannel.name;

    String? channelDescription = message.data['type'] == 'message'
        ? messageChannel.description
        : transactionChannel.description;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: channelDescription,
            icon: 'ic_launcher',
            importance: Importance.max, // Set importance to max
            priority: Priority.high, // Set priority to high
            ticker: 'ticker',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          title: 'WaregApp',
          onGenerateRoute: Routes.generateRoute,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromRGBO(48, 122, 89, 1)),
            useMaterial3: true,
          ),
          home: child,
        );
      },
      child: const SplashScreen(),
    );
  }
}
