import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_app/text_button.dart';
import 'package:to_do_app/utils.dart';
class forgot extends StatefulWidget {
  const forgot({super.key});

  @override
  State<forgot> createState() => _forgotState();
}

class _forgotState extends State<forgot> {
  final email=TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.tealAccent.shade100,
        appBar: AppBar(
          title: Row(
            children: [
              Text('Forgot Password',style: TextStyle(fontFamily: 'BungeeSpice'),),
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



            Column(
            children: [SizedBox(height: 100,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    hintText: 'email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)
                    )

                  ),
                ),
              ),SizedBox(height: 10,)
              ,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: roundbutton(
                  title:'Reset',color:Colors.tealAccent.shade400,ontap: ()
                {
                  auth.sendPasswordResetEmail(email: email.text.toString()).then((value) {
                    utils().toastmessage('We have sent you a email ');
                  }).onError((error, stackTrace)
                  {
                    utils().toastmessage(error.toString());
                  });
                },
                ),
              )

            ],
          ),]
        )
    );
  }
}
