import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_app/leader_mainscreen.dart';
import 'package:to_do_app/login.dart';
import 'package:to_do_app/sessioncontroller.dart';
import 'package:to_do_app/team_chat.dart';
import 'package:to_do_app/team_mainscreen.dart';
import 'package:to_do_app/text_button.dart';
class mainscreen extends StatefulWidget {
  const mainscreen({super.key});

  @override
  State<mainscreen> createState() => _mainscreenState();
}

class _mainscreenState extends State<mainscreen> {
  List<String> arrayuser=[];
  List<String> arrayemail=[];

  final auth =FirebaseAuth.instance;
  void input() {
    User? currentuser = auth.currentUser;
    final uid=currentuser?.email;
    useruid=uid!=null? uid : 'no';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.tealAccent.shade100,
      appBar: AppBar(
        title: Row(
          children: [
            Text('Mainscreen',style: TextStyle(fontFamily: 'BungeeSpice'),),
            Spacer(),
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
        children: [  Align(alignment: AlignmentDirectional.bottomEnd,
          child: Container(
            height: 300
            ,
            width: 800,
            child: Image.asset('images/background.png',fit: BoxFit.cover,),
          ),
        ),

          Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [TextButton(onPressed: (){
              auth.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context)=>login()));

            }, child: Text('Log Out?',style: TextStyle(fontSize: 20,fontFamily: 'BungeeSpice'),)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: roundbutton(
                  title: 'Join as Head',
                  color: Colors.tealAccent.shade400,
                  ontap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>leader(arrayuser: arrayuser,arrayemail: arrayemail,)));
                  },
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: roundbutton(title: "Join as Team", color: Colors.tealAccent.shade400, ontap: ()
                  {input();
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>teammain()));


                  }
                ),
              ),

            ],
          ),
        ),]
      ),

    );
  }
}
