import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  String other,user;
  ChatRoom(String other, String username){
    this.other=username;
    this.user=other;
  }

  @override
  _ChatRoomState createState() => _ChatRoomState(user,other);
}

class _ChatRoomState extends State<ChatRoom> {
  String user,other,chatRoomid;
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  _ChatRoomState(this.user,this.other);


  @override
  void initState() {
    if(user.compareTo(other)>0){
    chatRoomid=user+"-"+other;
    }
    else{
      chatRoomid=other+"-"+user;
    }
    GetConnectChat();
    getChats(chatRoomid);
  }

  GetConnectChat() async{
    List<String> users=[user,other];
    Map<String,dynamic> chatroom={
    "Room":chatRoomid,
    "users":users
    };
    await FirebaseFirestore.instance.collection("chatRoom").doc(chatRoomid).set(chatroom).catchError((e){print(e.toString());});
  }

  getChats(String chatRoomId) async{
    chats =FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }



  Widget chatMessages(){
    return Container(
      height: MediaQuery.of(context).size.height*.74,
      child: StreamBuilder(
        stream: chats,
        builder: (context, snapshot){
          return snapshot.hasData ?  ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index){
                return MessageTile(
                  snapshot.data.documents[index].get("message"),
                  user == snapshot.data.documents[index].get("sendBy"),
                );
              }) : Container();
        },
      ),
    );
  }

  addedMessage(String chatRoomId, chatMessageData) async{

    print("enter add message");

    await FirebaseFirestore.instance.collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
      print(e.toString());
    });
  }

  sendMessage() async{
    if (messageEditingController.text.isNotEmpty) {
      print(messageEditingController.text);
      Map<String, dynamic> chatMessageMap = {
        "sendBy": user,
        "message": messageEditingController.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };

      await addedMessage(chatRoomid, chatMessageMap);

      print("After enter setstate");

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(other),
      ),
      body: Stack(
        children: <Widget>[
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              color: Colors.blue,
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: messageEditingController,
                        decoration: InputDecoration(
                            hintText: "Message ...",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            border: InputBorder.none
                        ),
                      )),
                  SizedBox(width: 16,),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        padding: EdgeInsets.all(12),
                        child: Center(child: Icon(Icons.send))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  String message;
  bool sendByMe;

  MessageTile(String message,bool sendByme){
    this.message=message;
    this.sendByMe=sendByme;
    print(sendByMe);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ]
                  : [
                Colors.orange,
                Colors.orange
              ],
            )
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}

