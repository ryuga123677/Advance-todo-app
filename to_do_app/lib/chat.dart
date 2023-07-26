import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/utils.dart';
import 'signup.dart';
import 'sessioncontroller.dart';

class chat extends StatefulWidget {
  String sender;
  String reciver;
   chat({super.key,required this.sender,required this.reciver});

  @override
  State<chat> createState() => _chatState();
}
class _chatState extends State<chat> {
  List<String> list=[];
  String useruid='';
  streamcontrol streamcontroler=streamcontrol();
  TextEditingController message=TextEditingController();
  final auth =FirebaseAuth.instance;
  void input() {
    User? currentuser = auth.currentUser;
    final uid=currentuser?.email;
    useruid=uid!=null? uid : 'no';
  }
late var firestore;
  late var chatfirestore;


  void initState() {
    input();
    firestore = FirebaseFirestore.instance.collection(useruid+'chat');
    chatfirestore =
        FirebaseFirestore.instance.collection(useruid+'chat')
            .snapshots();

    sessioncontrol().user=useruid+'chat';
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(backgroundColor: Colors.tealAccent.shade100,
      appBar: AppBar(
        title: Text('chat',style: TextStyle(fontFamily: 'BungeeSpice'),),
        backgroundColor: Colors.tealAccent.shade700,
      ),
      body: Column(
        children: [

          Expanded(child: StreamBuilder<QuerySnapshot>(
              stream: chatfirestore,
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
                return Expanded(child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context,index)
                    {return ListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),

                        title:Text(snapshot.data!.docs[index]['message'].toString(),style: TextStyle(fontFamily: 'Merienda'),),
                      subtitle: Text(snapshot.data!.docs[index]['username'].toString()),

                    );

                    }));
              }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(alignment: Alignment.bottomCenter,
              child: TextFormField(
                controller: message,
                decoration: InputDecoration(
                  hintText: 'message',

                  suffixIcon: InkWell(child: Icon(Icons.send),
                  onTap: (){

                    String timespan=DateTime.now().millisecondsSinceEpoch.toString();
                    list.add(message.text.toString());
                    streamcontroler.addResponse(list);
                    firestore.doc(timespan).set(
                        {'username':useruid,
                          'message':message.text.toString(),
                          'id':timespan
                        });



                  },),

                ),



              ),
            ),
          )
        ],
      ),
    );
  }
}
class streamcontrol
{
  final _stream=StreamController<List<String>>.broadcast();
  void Function(List<String>) get addResponse => _stream.sink.add;
  Stream<List<String>> get getResponse => _stream.stream.asBroadcastStream();
}

