import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/login.dart';
import 'package:to_do_app/mainscreen.dart';
import 'package:to_do_app/text_button.dart';
import 'package:to_do_app/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Notification_services.dart';
import 'sessioncontroller.dart';
class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  bool loading=false;
  notificationservices notificationser=notificationservices();
  late String user;
  String? deviceid;
  final formkey=GlobalKey<FormState>();
  final auth=FirebaseAuth.instance;
  var email=TextEditingController();
  var password=TextEditingController();
  var username=TextEditingController();
  DatabaseReference ref=FirebaseDatabase.instance.ref('users');
  void initState()
  {
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
    return Scaffold(resizeToAvoidBottomInset: false,
      backgroundColor: Colors.tealAccent.shade100,
      body: Stack(
        children: [


          Align(alignment: Alignment.topLeft,
          child: Container(height: 110,
            width: double.infinity,
            decoration: BoxDecoration(

                color: Colors.tealAccent.shade400
            ),
          ),
        ),
          Align(alignment: Alignment.topLeft,
            child: Container(height: 90,
              width: double.infinity,
              decoration: BoxDecoration(

                  color: Colors.tealAccent.shade200
              ),
            ),
          ),

          Align(alignment: Alignment.topLeft,
            child: Container(height: 70,
              width: double.infinity,
              decoration: BoxDecoration(

                  color: Colors.tealAccent.shade100
              ),
            ),
          ),



          Align(alignment: AlignmentDirectional.bottomEnd,
            child: Container(
              height: 300
              ,
              width: 800,
              child: Image.asset('images/background.png',fit: BoxFit.cover,),
            ),
          ),
          Align(alignment: Alignment.topCenter,
            child: Padding(padding: EdgeInsets.symmetric(vertical:120),
              child: Container(

                  height: 150,
                  width: 150,
                  child: Image.asset('images/signup.png',fit: BoxFit.cover,)),

            ),
          ),


          Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 5,),


                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: username,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: 'Username',
                          border: OutlineInputBorder()

                      ),
                      validator: (value)
                      {
                        if(value!.isEmpty)
                        {
                          return 'Enter Username';
                        }
                        return null;
                      }
                      ,

                    ),
                  ),
                SizedBox(
                  height: 15,
                ),
                Form(key: formkey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          hintText: 'email',
                          border: OutlineInputBorder()

                      ),
                      validator: (value)
                      {
                        if(value!.isEmpty)
                        {
                          return 'Enter Email';
                        }
                        return null;
                      }
                      ,

                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Form(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: 'password',

                            border: OutlineInputBorder(

                            )

                        ),
                        validator: (value)
                        {
                          if(value!.isEmpty)
                          {
                            return 'Enter Password';
                          }
                          return null;
                        }

                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: roundbutton(
                      loading: loading,
                      title: 'sign up',
                      color: Colors.tealAccent.shade400,
                      ontap: () {
                        if (formkey.currentState!.validate()) {
                          signup();
                        }
                      }
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Already have account?',style: TextStyle(fontFamily: 'Merienda')),
              TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> login()));

                      }, child: Text("login",style: TextStyle(fontFamily: 'Merienda'))),

                  ],
                ),




              ],
            ),
          ),],
      ),
    );
  }
  void signup()
  {
    setState(() {
      loading=true;
    });
    auth.createUserWithEmailAndPassword(email: email.text.toString(), password: password.text.toString()).then((value)
    {String time=DateTime.now().millisecondsSinceEpoch.toString();
      ref.child(time).set(
        {
          'username':username.text.toString(),
          'email':email.text.toString(),
          'userdeviceid':deviceid.toString(),


        }
      ).then((value){
       // sessioncontrol.user=username.text.toString();

        utils().toastmessage('User created');
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => mainscreen()));
      setState(() {
        loading=false;
      });
    }).onError((error, stackTrace){
      utils().toastmessage(error.toString());
      setState(() {
        loading=false;
      });
    });

  }}
