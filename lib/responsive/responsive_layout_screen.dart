import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook_kuy/main.dart';
import 'package:cook_kuy/providers/user_provider.dart';
import 'package:cook_kuy/resources/fcm_service.dart';
import 'package:cook_kuy/resources/firestore_methods.dart';
import 'package:cook_kuy/screens/accountlain/accountlain_screen.dart';
import 'package:cook_kuy/screens/router.dart';
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
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      //Its compulsory to check if RemoteMessage instance is null or not.
      RemoteNotification? notification = message!.notification;
      AndroidNotification? android = message.notification?.android;
      Map<String, dynamic> data = message.data;
      var initializationSettingsAndroid =
          AndroidInitializationSettings('flutter_devs');
      var initSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      flutterLocalNotificationsPlugin.initialize(initSettings,
          onSelectNotification: (String? payload) async {
        print("ini adalah id: ${data['anotherUserId']}");
        print("ini adalah id: ${data['route']}");
        print("ini adalah payload: $payload");
        if (payload == "/another_account") {
          navigatorKey.currentState!.pushNamed(AppRouter.anotherAccount,
              arguments: data['anotherUserId']);
          // Navigator.of(context, rootNavigator: true).pushNamed(AppRouter.anotherAccount, arguments: data['anotherUserId']);
        }
      });

      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ),
            payload: data['route']
            // payload: data['route'],
            );
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      Map<String, dynamic> data = message.data;
      var initializationSettingsAndroid =
          AndroidInitializationSettings('flutter_devs');
      var initSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      flutterLocalNotificationsPlugin.initialize(initSettings,
          onSelectNotification: (String? payload) async {
        print("ini adalah id: ${data['anotherUserId']}");
        print("ini adalah id: ${data['route']}");
        print("ini adalah payload: $payload");
        if (payload == "/another_account") {
          navigatorKey.currentState!.pushNamed(AppRouter.anotherAccount,
              arguments: data['anotherUserId']);
          // Navigator.of(context, rootNavigator: true).pushNamed(AppRouter.anotherAccount, arguments: data['anotherUserId']);
        }
      });

      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ),
            payload: data['route']
            // payload: data['route'],
            );
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

  Future onSelectNotification(String payload) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return AccountLain(anotherUserId: payload);
    }));
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  void initState() {
    super.initState();
    addData();
    // loadFCM();
    // listenFCM();
    // setupFcm();
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
