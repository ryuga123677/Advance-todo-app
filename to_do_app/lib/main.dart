import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/home_screen.dart';
import 'package:to_do_app/mainscreen.dart';
import 'login.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AwesomeNotifications().initialize(null,[NotificationChannel(channelKey: 'basic_channel', channelName: 'TheCalmOcean', channelDescription: 'Notification channel for basic tests')],debug: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(


      title: 'Flutter Demo',
      debugShowCheckedModeBanner:false,
      home:AnimatedSplashScreen(backgroundColor: Colors.tealAccent.shade100,
         nextScreen:islogin()? login():mainscreen(),

        splash:Container(

            child: Image.asset('images/calm.png',fit: BoxFit.cover,)),
        splashTransition: SplashTransition.slideTransition,
      ),
    );
  }
  bool islogin()
  {final auth=FirebaseAuth.instance;
  final user=auth.currentUser;
    if(user==null)
      {
        return true;

      }
    else
      {
        return false;
      }
  }
}

