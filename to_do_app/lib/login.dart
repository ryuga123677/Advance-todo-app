import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/mainscreen.dart';
import 'package:to_do_app/number_login.dart';
import 'package:to_do_app/signup.dart';
import 'package:to_do_app/text_button.dart';
import 'forgot_password.dart';
import 'package:to_do_app/utils.dart';
class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final auth= FirebaseAuth.instance;
  bool loading=false;
  final formkey=GlobalKey<FormState>();
  var email=TextEditingController();
  var password=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
      backgroundColor: Colors.tealAccent.shade100,
      body: Stack(
        children: [Align(alignment: Alignment.topLeft,
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
          ),  Align(alignment: Alignment.topCenter,
            child: Padding(padding: EdgeInsets.symmetric(vertical:120),
              child: Container(

                  height: 110,
                  width: 175,
                  child: Image.asset('images/login.png',fit: BoxFit.cover,)),

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


          Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                  title: 'login',
                  color: Colors.tealAccent.shade400,
                  ontap: () {
                    if (formkey.currentState!.validate()) {
                      login();
                    }
                  }
    ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(alignment: Alignment.bottomRight,
                    child: TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> forgot()));

                    }, child: Text("Forgot Password?",style: TextStyle(fontFamily: 'Merienda'),)),
                  )
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(" Don't have an account?",style: TextStyle(fontFamily: 'Merienda')),
                  TextButton(onPressed:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>signup()));
                  }, child:Text('sign up',style: TextStyle(fontFamily: 'Merienda')) )
                ],
              ),
              // InkWell(onTap: (){
              //   Navigator.push(context, MaterialPageRoute(builder: (context)=>phonelogin()));
              // },
              //   child: Container(
              //     height: 50,
              //     width: 200,
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(50),
              //         border: Border.all(
              //             color: Colors.black
              //         )
              //     ),
              //     child:Center(child: Text('Login with Google',style: TextStyle(fontFamily: 'Merienda'))),
              //   ),
              // ),



            ],
          ),
        ),],
      ),
    );
  }
  void login()
  {
    setState(() {
      loading=true;
    });
    auth.signInWithEmailAndPassword(email: email.text.toString(), password: password.text.toString()).then((value)
    {
      utils().toastmessage(value.user!.email.toString());
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

  }
}

