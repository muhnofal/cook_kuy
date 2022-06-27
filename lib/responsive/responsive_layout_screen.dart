import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/main.dart';
import 'package:cook_kuy/providers/user_provider.dart';
import 'package:cook_kuy/resources/firestore_methods.dart';
import 'package:cook_kuy/screens/accountlain/accountlain_screen.dart';
import 'package:cook_kuy/utils/dimension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:cook_kuy/main.dart' as main;

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout(
      {Key? key,
      required this.webScreenLayout,
      required this.mobileScreenLayout})
      : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // final InitializationSettings initializationSettings =
  //     const InitializationSettings();

  // void flutterLocalInit() async {
  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //       onSelectNotification: onSelectNotification);
  // }

  // Future<dynamic> onSelectNotification(route) async {
  //   if (route == "/another_account") {
  //     MyApp().navigatorKey.currentState!.pushAndRemoveUntil(
  //           MaterialPageRoute(
  //               builder: (context) => AccountLain(
  //                     anotherUserId: "",
  //                   )),
  //           (Route<dynamic> route) => false,
  //         );
  //   }
  // }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      Map<String, dynamic> data = message.data;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
          payload: data['route']
          // payload: data['route'],
        );

        Navigator.of(context).pushNamed('/notification');
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          importance: Importance.high,
          enableVibration: true);

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Future<void> setupToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    await saveTokenToDatabase(token!);
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  Future saveTokenToDatabase(String token) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'tokens': FieldValue.arrayUnion([token])
    });
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  void initState() {
    super.initState();
    addData();

    loadFCM();
    listenFCM();
    setupToken();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        if (constraints.maxWidth > webScreeSize) {
          return widget.webScreenLayout;
        }
        return widget.mobileScreenLayout;
      }),
    );
  }
}
