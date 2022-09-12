import 'package:booriya/confirm_and_notice/notification.dart';
import 'package:booriya/pages/fire_detect_page/fire_detect_page_detail.dart';
import 'package:booriya/pages/fire_detect_page/fire_detect_page.dart';
import 'package:booriya/pages/fire_info_page/fire_info_page.dart';
import 'package:booriya/pages/fire_off_page/fire_off.dart';
import 'package:booriya/pages/fire_on_page/fire_on.dart';
import 'package:booriya/pages/fire_stream_page/fire_stream_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // eh96ECXKRGS40Ol_y220do:APA91bEYvfAtqIa2RK-m2PwugCUXoW_3JVzqPIDjGmrPhMw9x2bM64mfSuHRtvcj5FRcC7e9T4FQwVqjiPQ8sf95V4s7ul7c4PRAmvhpt9b8LVKIU79Nc0tdGusbvEyIk5Nqdu712E8S
  String? token = await FirebaseMessaging.instance.getToken();
  // print("token : ${token ?? 'token NULL!'}");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  var initialzationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  var initialzationSettingsIOS = IOSInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  var initializationSettings = InitializationSettings(
      android: initialzationSettingsAndroid, iOS: initialzationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFFE26A2C),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/off",
      routes: {
        "/on": (context) => FireOn(),
        "/off": (context) => FireOff(),
        "/info": (context) => FireInfoPage(),
        "/detect": (context) => FireDetectPage(),
        "/detail": (context) => Detail(),
        "/stream": (context) => FireStreamPage(),
      },
    );
  }
}
