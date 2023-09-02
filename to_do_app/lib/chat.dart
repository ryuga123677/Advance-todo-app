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

   chat({super.key,required this.sender});

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
        title: Row(
          children: [
            Text('chat',style: TextStyle(fontFamily: 'BungeeSpice'),),
            Spacer(),
            InkWell(child: Icon(Icons.delete_forever_outlined),onTap: ()async{
              var snapshot=await firestore.get();
              for(var doc in snapshot.docs)
                {
                  doc.reference.delete();
                }

              setState(() {

              });},)
          ],
        ),
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
                return Container(width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index)
                      {

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(width:MediaQuery.of(context).size.width,

                            alignment: (snapshot.data!.docs[index]['username'].toString()==useruid)?Alignment.topRight:Alignment.topLeft,
                            child: Container(
                              decoration: BoxDecoration(color: Colors.tealAccent.shade400,borderRadius: BorderRadius.only(topRight: Radius.zero,topLeft: Radius.circular(15),bottomLeft:Radius.zero,bottomRight:  Radius.circular(30) )),

                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [Text(snapshot.data!.docs[index]['message'].toString(),style: TextStyle(fontFamily: 'Merienda'),),
                                Text(snapshot.data!.docs[index]['username'].toString(),style: TextStyle(color: Colors.tealAccent.shade700),),
                                ],


                      ),
                              ),
                            ),
                          ),
                        );

                      }),
                );
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

