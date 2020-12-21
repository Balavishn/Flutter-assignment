import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/Home_Screen.dart';
import 'package:flutterapp/search.dart';

import 'login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  String email,password,name;
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
                      Text("Register",style: TextStyle(color: Colors.white,fontSize: 40),textAlign: TextAlign.center,),
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
                                        return "Please Enter Name";
                                      }
                                      return null;
                                    },
                                    onSaved: (input){
                                      name=input;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.person,color: Colors.blue[700],),
                                        hintText: "Enter Name",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none
                                    ),
                                  ),
                                ),
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
                                      email=input;
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
                                      password=input;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.lock,color: Colors.blue[700],),
                                        hintText: "Enter Password",
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
                                        return "Please Enter Confirm Password";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.lock,color: Colors.blue[700],),
                                        hintText: "Enter Confirm Password",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                              child: Text("Register",style: TextStyle(color: Colors.white,fontSize: 15),)),

                        ),
                        SizedBox(height: 40,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap:(){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Login()));
                                  },
                                child: Text("Already Have Account",style: TextStyle(color: Colors.black,fontSize: 18,)
                                  ,)
                            ),
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
        Map<String,String> user={
          "email":email,
          "name":name,
        };
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email:email , password: password);
        await Firestore.instance.collection('users').add(user);
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Search()));
        print("success");
      } catch (e) {
        print("Error:" + e.message);
      }
    }
  }
}
