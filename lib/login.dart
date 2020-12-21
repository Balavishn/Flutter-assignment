import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/register.dart';
import 'package:flutterapp/search.dart';

import 'Home_Screen.dart';
import 'main.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;


  @override
  void initState() {
    FirebaseAuth.instance.onAuthStateChanged.listen((event) {
      if(event != null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>Search() ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.blue[800],
                  Colors.blue[600],
                  Colors.blue[400],
                ]
            )
        ),
        child:SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              SizedBox(height: 30,),
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Login",style: TextStyle(color: Colors.white,fontSize: 40),textAlign: TextAlign.center,),
                      Text("Welcome Back",style: TextStyle(color: Colors.white,fontSize: 20),),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(
                                  color: Colors.blue[400],
                                  blurRadius: 20,
                                  offset: Offset(5,10)
                              )]
                          ),
                          child:Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                  ),
                                  child: TextFormField(
                                    validator: (value){
                                      if(value.isEmpty){
                                        return "Please Enter Email";
                                      }
                                      return null;
                                    },
                                    onSaved: (input){
                                      _email=input;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.email,color: Colors.blue[700],),
                                        hintText: "Enter Email",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                  ),
                                  child: TextFormField(
                                    obscureText: true,
                                    validator: (value){
                                      if(value.isEmpty){
                                        return "Please Enter Password";
                                      }
                                      return null;
                                    },
                                    onSaved: (input){
                                      _password=input;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.lock,color: Colors.blue[700],),
                                        hintText: "Enter Password",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Forget Password ?",style: TextStyle(color: Colors.red[600],fontSize: 18,),),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Container(
                          height: (MediaQuery.of(context).size.height/10)*.8,
                          width: MediaQuery.of(context).size.width*.7,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                            color: Colors.blue[700],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)
                                ),
                                color: Colors.blue[700],
                                onPressed: signIn,
                                child: Text("Login",style: TextStyle(color: Colors.white,fontSize: 15),)),

                        ),
                        SizedBox(height: 40,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap:(){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Register()));
                                },
                                child: Text("New User Click Here",style: TextStyle(color: Colors.black,fontSize: 18,),)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  Future<void> signIn() async {
    print("page enter");
    if (_formKey.currentState.validate()) {
      print("page running");
      _formKey.currentState.save();
      try {
         await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Search()));
         
         print("success");
      } catch (e) {
        print("Error:" + e.message);
      }
    }
  }
}
