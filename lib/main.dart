import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wareg_app/Activity/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wareg_app/Routes/Route.dart';
import 'Controller/message_controller.dart';
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

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();

  static void setChatActivityStatus(bool isActive, int? userId) {
    _MyAppState.setChatActivityStatus(isActive, userId);
  }
}

class _MyAppState extends State<MyApp> {
  final ScrollController _scrollController = ScrollController();
  static bool _isChatActivityActive = false;
  static int? _currentChatUserId;

  final MessageController _messageController = Get.put(MessageController());

  static void setChatActivityStatus(bool isActive, int? userId) {
    _isChatActivityActive = isActive;
    _currentChatUserId = userId;
  }

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getToken().then((token) {
      print("FCM Token: $token");
      // Simpan token FCM ke backend di sini
      // Misalnya, gunakan _messageController.saveFcmToken(token);
      _messageController.saveFcmToken(token);
    });
    if (!_isChatActivityActive) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _showLocalNotification(message);
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
