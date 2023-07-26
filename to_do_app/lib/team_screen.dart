import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
class teamscreen extends StatefulWidget {
  const teamscreen({super.key});

  @override
  State<teamscreen> createState() => _teamscreenState();
}

class _teamscreenState extends State<teamscreen> {
  DatabaseReference ref=FirebaseDatabase.instance.ref('Users');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: Column(
  children: [
    TextFormField(

    ),
    Card(
      // child: chatref.child('request').toString()? Row(
      //   children: [
      //     TextButton(onPressed:(){
      //
      //
      //
      //
      //     }, child: Text('Yes')),
      //     TextButton(onPressed: (){}, child:Text('No'))
      //   ],
      // ):null ,

    )
  ],
),
    );
  }
}
