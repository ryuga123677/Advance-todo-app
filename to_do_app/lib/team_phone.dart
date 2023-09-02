import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/leader_mainscreen.dart';
import 'package:to_do_app/text_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_auth/email_auth.dart';
import 'package:to_do_app/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'sessioncontroller.dart';
import 'sessioncontroller.dart';
import 'text_button.dart';
class teamlogin extends StatefulWidget {
  List<String> arrayuser;
  List<String> arrayemail;
   teamlogin({super.key,required this.arrayuser,required this.arrayemail});

  @override
  State<teamlogin> createState() => _teamloginState();
}

class _teamloginState extends State<teamlogin> {
  late var ref1;
  late var ref2;
  final formkey =GlobalKey<FormState>();
  var phnumber =TextEditingController();
String useruid='';
  bool loading =false;
  final auth =FirebaseAuth.instance;

  DatabaseReference ref=FirebaseDatabase.instance.ref('users');

  void initState() {
    User? currentuser = auth.currentUser;
    final uid = currentuser?.email;
    useruid = uid != null ? uid : 'no';
    ref1=FirebaseFirestore.instance.collection(useruid + 'group');

    ref2 = FirebaseFirestore.instance.collection(useruid + 'group')
        .snapshots();

  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.tealAccent.shade100,
      appBar: AppBar(
        title: Text('All Users',style: TextStyle(fontFamily:'BungeeSpice'),),
        backgroundColor: Colors.tealAccent.shade700,
        centerTitle: true,

      ),
      body:

          Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Container(
                  height: 40,
                  width: double.infinity,

                  child: Image.asset('images/users.png')),
              SizedBox(height: 10,),
              TextFormField(
                controller: phnumber,

                decoration: InputDecoration(


                  hintText: 'Search',hintStyle: TextStyle(color: Colors.blue),
                  suffixIcon: Icon(Icons.search,color: Colors.blue,),
                  border: OutlineInputBorder(


                    borderRadius: BorderRadius.circular(15),

                  )



                ),
                onChanged: (String value)
                {
                  setState(() {

                  });
                },
              ),
            SizedBox(height: 10),
            Expanded(
              child: FirebaseAnimatedList(query: ref, itemBuilder: (context,snapshot,animation,index)
              {
                final user=snapshot.child('username').value.toString();
                final useremail=snapshot.child('email').value.toString();
                if(phnumber.text.isEmpty)
                  {
                    return ListTile(

                      shape: RoundedRectangleBorder(

                        borderRadius: BorderRadius.circular(50), ),
                      title: Text(snapshot.child('username').value.toString(),style: TextStyle(fontFamily: 'Merienda'),),
                      subtitle: Text(snapshot.child('email').value.toString(),style: TextStyle(color: Colors.tealAccent.shade700),),
                      trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(child: ListTile(


                            leading: Icon(Icons.add),
                            title: Text('Add'),
                            onTap: (){//final ref3=ref2.data.docs['username'].toString();
                              if(widget.arrayuser.contains(snapshot.child('username').value.toString()))
                                {utils().toastmessage('user already in your team');
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>leader(arrayuser: widget.arrayuser,arrayemail: widget.arrayemail,)));

                            }
                              else
                                {
                                  String id=DateTime.now().millisecondsSinceEpoch.toString();
                                  ref1.doc(id).set(
                                    {
                                      'username':snapshot.child('username').value.toString(),
                                      'email':snapshot.child('email').value.toString(),
                                      'userdeviceid':snapshot.child('userdeviceid').value.toString(),
                                      'id':id,
                                      'leader':useruid

                                    }

                                  );
                                   widget.arrayuser.add(snapshot.child('username').value.toString());
                                   widget.arrayemail.add(snapshot.child('email').value.toString());

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>leader(arrayuser: widget.arrayuser,arrayemail: widget.arrayemail,)));
                                }


                              },
                          ),
                         )
                        ],
                      ),
                    );

                  }
                else if(user.toLowerCase().contains(phnumber.text.toString()))
                  {
                    return ListTile(
                      title: Text(snapshot.child('username').value.toString())
                      ,
                      subtitle: Text(snapshot.child('email').value.toString()),
                      trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(child: ListTile(
                            leading: Icon(Icons.add),
                            title: Text('Add'),
                            onTap: (){

                              String id=DateTime.now().millisecondsSinceEpoch.toString();
                              ref1.doc(id).set(
                                  {
                                    'username':snapshot.child('username').value.toString(),
                                    'email':snapshot.child('email').value.toString(),
                                    'userdeviceid':snapshot.child('userdeviceid').value.toString(),
                                    'id':id,
                                    'leader':useruid


                                  });
                              widget.arrayuser.add(snapshot.child('username').value.toString());
                              widget.arrayemail.add(snapshot.child('email').value.toString());
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>leader(arrayuser: widget.arrayuser,arrayemail: widget.arrayemail,)));

                            },
                          ),
                            )
                        ],
                      ),
                    );

                  }
                else
                  {
                    return Container();
                  }
              }),
            )

            ]
    )),

    );
  }

}
