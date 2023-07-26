// import 'package:firebase_messaging/firebase_messaging.dart';
// class notificationservices{
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   void requestnotificationpermission()
//   async{
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );
//     if(settings.authorizationStatus==AuthorizationStatus.authorized)
//       {
//
//       }
//     else if(settings.authorizationStatus==AuthorizationStatus.provisional)
//       {
//
//       }
//     else
//       {
//
//       }
//   }
//   Future<String> getdevicetoken()async{
//     String? token = await messaging.getToken();
//     return token!;
//
//   }
// }