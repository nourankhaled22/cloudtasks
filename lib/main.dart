/*import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notify/splash_screen.dart';
import 'firebase_options.dart';
import 'notification_handler.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Handle foreground and background notifications
  FirebaseMessaging.onMessage.listen(foregroundNotificationHandler);
  FirebaseMessaging.onBackgroundMessage(backgroundNotificationHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //home: MyHomePage(),
      home: SplashToHome(),
    );
  }
}

*/
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:notify/pages/login.dart';
import 'package:notify/pages/splash.dart';
import 'package:notify/services/channels.dart';
import 'package:notify/services/chat.dart';
import 'package:notify/services/notifications.dart';

import 'firebase_options.dart';

// Create an instance of the FlutterLocalNotificationsPlugin

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;
  // Get.put(MessageService());
  Get.lazyPut(() => MessageService());
  // Get.lazyPut(() => ChannelService());
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // String? token = await FirebaseMessaging.instance.getToken();
  // print('Firebase Token: $token');

  // Initialize local notifications
 await initializeLocalNotifications();

  // Set up Firebase Messaging handlers
  FirebaseMessaging.onMessage.listen(foregroundNotificationHandler);
  FirebaseMessaging.onBackgroundMessage(backgroundNotificationHandler);

  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Center(child: const Text('Welcome to my home page'))));
  }
}

