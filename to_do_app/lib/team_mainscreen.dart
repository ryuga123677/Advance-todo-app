

import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/leader_mainscreen.dart';

import 'package:to_do_app/sessioncontroller.dart';
import 'package:to_do_app/team_chat.dart';
import 'package:to_do_app/utils.dart';

import 'Notification_services.dart';
class teammain extends StatefulWidget {
  const teammain({super.key});

  @override
  State<teammain> createState() => _teammainState();
}

class _teammainState extends State<teammain> {
  String useruid='';
  final auth =FirebaseAuth.instance;

  late var email1;
  late var useremail2;

  late var chatfirestore;
  notificationservices notificationser=notificationservices();
  void initState() {

    super.initState();
    notificationser.requestnotificationpermission();
    notificationser.firebaseInit(context);
    notificationser.istokenrefresh();
    notificationser.setupinteractmessage(context);

    notificationser.getdevicetoken().then((value) {
      print("device token");
      print(value);
    });
    User? currentuser = auth.currentUser;
    final uid=currentuser?.email;

    useruid=uid!=null? uid : 'no';
    useremail2 = FirebaseFirestore.instance.collection(useruid+'task').snapshots();
     email1 = FirebaseFirestore.instance.collection(useruid+'task');



  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.tealAccent.shade100,
      appBar: AppBar(backgroundColor: Colors.tealAccent.shade700,
        title: Text('Team main',style: TextStyle(fontFamily: 'BungeeSpice'),),
        centerTitle: true,
      ),
      body:Column(
        children: [
          SizedBox(height: 5,),
          Container(
            height: 50,
            width: double.infinity,

            child: Image.asset('images/task.png')),
          SizedBox(height: 20,),
          Expanded(child: StreamBuilder<QuerySnapshot>(
              stream:useremail2,
              builder: (context,AsyncSnapshot<QuerySnapshot> snapshot)
              {
                if(snapshot.connectionState == ConnectionState.waiting)
                {
                  return Center(child: CircularProgressIndicator());
                }
                if(snapshot.hasError)
                {
                  return Text('some error');
                }
                if(snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {bool? check=false;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            tileColor: Colors.yellowAccent.shade100,

                            shape: RoundedRectangleBorder(side: BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(20),),

                            title: Row(
                              children: [
                                Text(snapshot.data!.docs[index]['task']
                                    .toString()),
                                Checkbox(value: check,
                                    activeColor: Colors.red
                                    , onChanged: (newBool) {check = newBool;
                                      setState(() {

                                        // AwesomeNotifications().createNotification(content: NotificationContent(id: 10, channelKey: 'basic_channel',title: 'Task',body:'Task Completed'));
                                        notificationser.getdevicetoken().then((value)async {
                                          var data={
                                            'to':snapshot.data!.docs[index]['senderdeviceid']
                                                .toString(),
                                            'priority':'high',
                                            'notification':{
                                              'title':'Task Completed',
                                              'body':snapshot.data!.docs[index]['task']
                                                  .toString()
                                            },
                                            // 'data':{
                                            //   'type':'msg',
                                            //   'id':'12345678'
                                            // }

                                          };
                                          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                                              body: jsonEncode(data),
                                              headers: {
                                                'Content-Type':'application/json; charset=UTF-8',
                                                'Authorization':'key=AAAAh4gaaUw:APA91bFSbeI2oejSCC2yiUqHrURCV5FgYTCNGuYnzQd07jM2ll5OTNbIN3BAWaB_Rald75MMSi9BeXxp94qL6pWcsawjXAlW4JklL-a0GnxeDDF7mnqZO0L7iRRYIw0FxJtv6QUvckug'
                                              }

                                          );


                                        });

                                      });
                                    }

                                ),
                                TextButton(onPressed: (){
                                  String ref=snapshot.data!.docs[index]['sender'].toString()+'chat';
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                      teamchat(reciver: ref)));

                                }, child:Text('Chat'))
                              ],
                            ),
                            subtitle: Text(snapshot.data!.docs[index]['sender']
                                .toString()),
                            trailing: InkWell(
                              child: Icon(Icons.delete),
                              onTap: () {String id=snapshot.data!.docs[index]['id']
                                  .toString();
                                print(id);
                                email1.doc(id).delete();

                                setState(() {

                                });
                              },),

                          ),
                        );
                      });
                }
                return Container();
              }),



          ),
        ],
      ),
    );
  }
}
