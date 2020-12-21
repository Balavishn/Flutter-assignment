import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'ChatRoom.dart';
import 'login.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}



class _SearchState extends State<Search> {
  TextEditingController nameedit=new TextEditingController();
  QuerySnapshot searchsnapshot;
  String UserName;

  getName() async{
    await FirebaseFirestore.instance.collection("users").
    where("email",isEqualTo: FirebaseAuth.instance.currentUser.email).
    getDocuments().
    then((value) {
      UserName=value.documents[0].get("name").toString();
      print(UserName);});
    getuser(UserName);
  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    getName();
    // nameedit.addListener(() {if(nameedit.text==""){getuser("start");}});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Chat"),
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0:0.0,
        actions: [
          GestureDetector(
            onTap: signout,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24,vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: nameedit,
                          onChanged: (text){
                            getuser(text);
                          },
                          decoration: InputDecoration(
                            hintText: "Search Friends",
                            hintStyle: TextStyle(
                              color: Colors.blue
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GestureDetector(
                          onTap: initiatesearch,
                            child: Icon(Icons.search,color: Colors.white,)),
                      ),
                    ],
                  )
                ],
              ),
            ),
            searchlist(),
          ],
        ),
      ),
    );
  }

  initiatesearch(){
    getuser(nameedit.text);
  }

  void signout() async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>Login()));
  }

  Widget searchlist(){
    return searchsnapshot != null ? ListView.builder(
        itemCount: searchsnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
          return SearchUser(
              searchsnapshot.documents[index].get("name")
          );
        }
    ): Container();
  }


  getuser(String name) async {
    if(name==UserName || name=="" || name==null){
      await FirebaseFirestore.instance.collection("users").where("name",isNotEqualTo: UserName).getDocuments().then((value) {
        setState(() {
          searchsnapshot=value;
        });
      });
   }
    else{
      return await FirebaseFirestore.instance.collection("users").where("name",isEqualTo: name.toLowerCase()).getDocuments().then((value) {
        setState(() {
          searchsnapshot=value;
        });
      });
    }
  }

  Widget SearchUser(String username){
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(15.00),
      child: Row(
        children: [
          Expanded(
              child: Text(username,style: TextStyle(color: Colors.blue,fontSize: 24),)
          ),
          GestureDetector(
            onTap: ()=>Navigator.push(context,MaterialPageRoute(builder:(context)=>ChatRoom(UserName,username))),
            child: Container(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                  child: Text("Message")),
            ),
          ),
        ],
      ),
    );
  }
}


