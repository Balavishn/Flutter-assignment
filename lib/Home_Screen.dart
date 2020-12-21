

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'login.dart';


class Home extends StatefulWidget {
  @override
  _Home_Screen createState() => _Home_Screen();
}

class _Home_Screen extends State<Home> {
  String name="name";

  String getuser(){
    return FirebaseAuth.instance.currentUser.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0:0.0,
      ),
    );
  }
}
