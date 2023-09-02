import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class notificationservices{
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin notificationplugin= FlutterLocalNotificationsPlugin();

  void requestnotificationpermission() async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if(settings.authorizationStatus==AuthorizationStatus.authorized)
    {

    }
    else if(settings.authorizationStatus==AuthorizationStatus.provisional)
    {

    }
    else
    {

    }
  }
  Future<String> getdevicetoken()async{
    String? token = await messaging.getToken();
    return token!;

  }
  void initlocalnotification(BuildContext context,RemoteMessage message)async
  {
    var androidintializesettings=AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosinitializesettings=DarwinInitializationSettings();
    var initializationsetting=InitializationSettings(
        android: androidintializesettings,
        iOS: iosinitializesettings
    );
    await notificationplugin.initialize(initializationsetting,
        onDidReceiveNotificationResponse: (payload){
          handlemessage(context, message);

        }
    );
  }
  void istokenrefresh()
  {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print("refresh");
    });
  }
  Future<void> setupinteractmessage(BuildContext context)async{
    RemoteMessage? initialmessage=await FirebaseMessaging.instance.getInitialMessage();
    if(initialmessage !=null)
    {
      handlemessage(context, initialmessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handlemessage(context, event);

    });
  }
  void firebaseInit(BuildContext context)
  {
    FirebaseMessaging.onMessage.listen((message) {

      print(message.notification!.title.toString());
      print(message.notification!.body.toString());
      print(message.data['type']);
      print(message.data['id']);

      if (Platform.isAndroid) {
        initlocalnotification(context, message);
        shownotification(message);
      }
      else
      {
        shownotification(message);
      }


    });
  }
  void handlemessage(BuildContext context,RemoteMessage message)
  {
    if(message.data['type']=='msg')
    {
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>messagescreen(id:message.data['id'].toString())));
    }
  }
  Future<void> shownotification(RemoteMessage message)async{
    AndroidNotificationChannel channel=AndroidNotificationChannel(Random.secure().nextInt(100000).toString(), "high importance",importance: Importance.max);
    AndroidNotificationDetails androidnotidetails=AndroidNotificationDetails(channel.id.toString(), channel.name.toString(),channelDescription: 'your channel description',importance: Importance.high,priority: Priority.high,ticker: 'ticker');
    NotificationDetails notificationDetails = NotificationDetails(
      android:androidnotidetails,
    );
    Future.delayed(Duration.zero,(){notificationplugin.show(0, message.notification!.title.toString(), message.notification!.body.toString(), notificationDetails);});
  }
}