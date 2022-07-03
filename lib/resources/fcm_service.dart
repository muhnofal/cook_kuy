import 'dart:convert';

import 'package:cook_kuy/screens/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cook_kuy/main.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'cook_kuy', 'High Importance Notifications',
    description: 'notifications from Your App Name.',
    importance: Importance.high,
    enableVibration: true);

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
// }

void setupFcm() {
  var initializationSettingsAndroid =
      const AndroidInitializationSettings("@mipmap/ic_launcher");
  var initializationSettingsIOs = const IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOs,
  );

  //when the app is in foreground state and you click on notification.
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) {
    if (payload != null) {
      Map<String, dynamic> data = json.decode(payload);
      goToNextScreen(data);
    }
  });

  //When the app is terminated, i.e., app is neither in foreground or background.
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    //Its compulsory to check if RemoteMessage instance is null or not.
    if (message != null) {
      goToNextScreen(message.data);
    }
  });

  //When the app is in the background, but not terminated.
  FirebaseMessaging.onMessageOpenedApp.listen(
    (event) {
      goToNextScreen(event.data);
    },
    cancelOnError: false,
    onDone: () {},
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            // channelDescription: channel.description,
            // icon: 'custom_notification_icon',
            // color: primaryColor,
            // importance: Importance.max,
            // priority: Priority.high,
          ),
        ),
        payload: json.encode(message.data),
      );
    }
  });
}

void goToNextScreen(Map<String, dynamic> data) {
  if (data['route'] != null) {
    switch (data['route']) {
      case "/another_account":
        // navigatorKey.currentState!.pushNamed(AppRouter.anotherAccount, arguments: data['anotherUserId']);
        // navigatorKey.currentState?.pushNamed(AppRouter.login);
      print("ASIAPPPPPP");
        break;
      // case "second_screen":
      //   navigatorKey.currentState.pushNamed(SecondScreen.routeName,);
      //   break;
      // case "sample_screen":
      //   navigatorKey.currentState.pushNamed(SampleScreen.routeName,);
    }
    return;
  }
  //If the payload is empty or no click_action key found then go to Notification Screen if your app has one.
  navigatorKey.currentState!.pushNamed(AppRouter.notification);
}

// if (android.imageUrl != null && android.imageUrl!.trim().isNotEmpty) {
// final String largeIcon = await _base64encodedImage(
// android.imageUrl,
// );
//
// final BigPictureStyleInformation bigPictureStyleInformation =
// BigPictureStyleInformation(
// ByteArrayAndroidBitmap.fromBase64String(largeIcon),
// largeIcon: ByteArrayAndroidBitmap.fromBase64String(largeIcon),
// contentTitle: notification.title,
// htmlFormatContentTitle: true,
// summaryText: notification.body,
// htmlFormatSummaryText: true,
// hideExpandedLargeIcon: true,
// );
//
// flutterLocalNotificationsPlugin.show(
// notification.hashCode,
// notification.title,
// notification.body,
// NotificationDetails(
// android: AndroidNotificationDetails(
// channel.id,
// channel.name,
// channelDescription: channel.description,
// icon: 'custom_notification_icon',
// color: primaryColor,
// importance: Importance.max,
// priority: Priority.high,
// largeIcon: ByteArrayAndroidBitmap.fromBase64String(largeIcon),
// styleInformation: bigPictureStyleInformation,
// ),
// ),
// payload: json.encode(message.data),
// );
// }
// else {
// flutterLocalNotificationsPlugin.show(
// notification.hashCode,
// notification.title,
// notification.body,
// NotificationDetails(
// android: AndroidNotificationDetails(
// channel.id,
// channel.name,
// channelDescription: channel.description,
// icon: 'custom_notification_icon',
// color: primaryColor,
// importance: Importance.max,
// priority: Priority.high,
// ),
// ),
// payload: json.encode(message.data),
// );
// }
