import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:to_do_app/team_chat.dart';
import 'package:to_do_app/team_mainscreen.dart';
import 'package:to_do_app/team_phone.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Notification_services.dart';
import 'sessioncontroller.dart';
import 'package:http/http.dart' as http;

import 'chat.dart';
class leader extends StatefulWidget {
  List<String> arrayuser;
  List<String> arrayemail;
  leader({super.key,required this.arrayuser,required this.arrayemail});

  @override
  State<leader> createState() => _leaderState();
}
String username='';

String useruid='';
final auth =FirebaseAuth.instance;
final pop=TextEditingController();
late var useremail;


class _leaderState extends State<leader> {
  late var ref1;
  late var ref2;
  String? userdeviceid;
  late var firestore;
  late var chatfirestore;
  String? deviceid;
  notificationservices notificationser=notificationservices();
  void initState() {
    User? currentuser = auth.currentUser;
    final uid = currentuser?.email;
    useruid = uid != null ? uid : 'no';
    ref2=FirebaseFirestore.instance.collection(useruid+'group');
    ref1=FirebaseFirestore.instance.collection(useruid+'group').snapshots();
    firestore = FirebaseFirestore.instance.collection(useruid+'chat');
    chatfirestore =
        FirebaseFirestore.instance.collection(useruid+'chat')
            .snapshots();
    notificationser.requestnotificationpermission();
    notificationser.firebaseInit(context);
    notificationser.istokenrefresh();
    notificationser.setupinteractmessage(context);

    notificationser.getdevicetoken().then((value) {
      print("device token");
      deviceid=value;
      print(value);
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.tealAccent.shade100,
      appBar: AppBar(
        title: Row(
          children: [
            Text('Leader',style: TextStyle(fontFamily: 'BungeeSpice'),),
           Spacer(),
            InkWell(child: Icon(Icons.chat_outlined),
            onTap: (){
              sessioncontrol().user = useruid;
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>
                      chat(sender: useruid,
                      )));}

            ),
            SizedBox(width: 10,),
            InkWell(child: Icon(Icons.exit_to_app),
            onTap: (){
              SystemNavigator.pop();
            },)
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.tealAccent.shade700,
      ),
      body: Stack(
        children: [



          Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [SizedBox(height: 1,),
              Container(
                  height: 50,
                  width: double.infinity,

                  child: Image.asset('images/team.png')),


                     InkWell(
                       child: Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Card( shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(20),
                           side: BorderSide(
                              color: Colors.black,),
                           ),elevation: 16,
                           shadowColor: Colors.red,
                           child: ListTile(
                             tileColor: Colors.tealAccent.shade200, shape: RoundedRectangleBorder(side: BorderSide(width: 1),borderRadius: BorderRadius.circular(20)),

                            leading: Icon(Icons.add,color: Colors.blue,),
                            title: Text('Add members',style: TextStyle(color: Colors.black,fontFamily: 'Merienda'),
                            ),
                    ),
                         ),
                       ),
                       onTap: ()
                       {
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>teamlogin(arrayemail: widget.arrayemail,arrayuser: widget.arrayuser,)));

                       },


                     ),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(

                  stream: ref1,



                  builder: (BuildContext context,AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    else if (snapshot.hasError) {
                      return Text('some error');
                    }
                    else if(snapshot.hasData)
                      {
                      return ListView.separated(
                          shrinkWrap: true,

                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(tileColor: Colors.tealAccent.shade400,
                                title: Row(
                                  children: [
                                    Text(snapshot.data!.docs[index]['username']
                                        .toString(),style: TextStyle(fontFamily: 'Merienda'),),
                                    Text(' '),
                                    InkWell(child: Icon(Icons.delete,color: Colors.red,),onTap: (){
                                      String id=snapshot.data!.docs[index]['id'].toString();
                                      ref2.doc(id).delete();
                                      setState(() {

                                      });

                                    },)
                                  ],
                                ),

                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                trailing: PopupMenuButton(
                                  icon: Icon(Icons.add,color: Colors.blue,),
                                  itemBuilder: (context) =>
                                  [
                                    PopupMenuItem(
                                      value: 1,


                                        child: ListTile(

                                          title: Text('Assign Task',style: TextStyle(fontFamily: 'Merienda'),),



                                          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                          onTap: () { Navigator.pop(context);
                                            username =
                                                snapshot.data!.docs[index]['email']
                                                    .toString();
                                       // userdeviceid=snapshot.data[index]['userdeviceid'].toString();

                                            showmydialog();


                                          },
                                        ),

                                    )
                                  ],


                                ),


                                onTap: () {


                                },



                              ),
                            );
                          },
                        separatorBuilder: (context,index){
                            return Divider(height: 5,thickness: 2,);
                        },

                      );}


                      {return Container();}
                    }


                ),
              ),




            ],
          ),
        ),]
      ),
    );
  }
  Future<void> showmydialog()
  async{
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('Asign Task'),
        content: Container(

          child: TextField(
            controller: pop,
            decoration: InputDecoration(
              suffixIcon: InkWell(child: Icon(Icons.send),
                onTap: (){

                  useremail = FirebaseFirestore.instance.collection(username+'task');
                  String id=DateTime.now().millisecondsSinceEpoch.toString();
                  useremail.doc(id).set(
                      {'sender':useruid,
                        'senderdeviceid':deviceid.toString(),
                        'task':pop.text.toString(),
                        'id':id
                      }
                  );
                  // notificationser.getdevicetoken().then((value)async {
                  //   var data={
                  //     'to':userdeviceid.toString(),
                  //     'priority':'high',
                  //     'notification':{
                  //       'title':'New Task',
                  //       'body':'you have been assign a new task'
                  //     },
                  //     // 'data':{
                  //     //   'type':'msg',
                  //     //   'id':'12345678'
                  //     // }
                  //
                  //   };
                  //   await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                  //       body: jsonEncode(data),
                  //       headers: {
                  //         'Content-Type':'application/json; charset=UTF-8',
                  //         'Authorization':'key=AAAAh4gaaUw:APA91bFSbeI2oejSCC2yiUqHrURCV5FgYTCNGuYnzQd07jM2ll5OTNbIN3BAWaB_Rald75MMSi9BeXxp94qL6pWcsawjXAlW4JklL-a0GnxeDDF7mnqZO0L7iRRYIw0FxJtv6QUvckug'
                  //       }
                  //
                  //   );
                  //
                  //
                  // });

                },
              )
            ),

          ),
        )

      );
    });

  }

}
