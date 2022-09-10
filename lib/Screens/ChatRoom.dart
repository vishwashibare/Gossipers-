import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatRoom extends StatelessWidget {
  final Map<String, dynamic> userMap;
  final String chatRoomId;

  ChatRoom({required this.chatRoomId, required this.userMap});

  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  File? imageFile;

  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;

    await _firestore
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('chats')
        .doc(fileName)
        .set({
      "sendby": _auth.currentUser!.displayName,
      "message": "",
      "type": "img",
      "time": FieldValue.serverTimestamp(),
    });

    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .doc(fileName)
          .update({"message": imageUrl});

      print(imageUrl);
    }
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.displayName,
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();
      await _firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .add(messages);
    } else {
      print("Enter Some Text");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Image(
          image: AssetImage('assets/appbarImage.jpeg'),
          fit: BoxFit.cover,
        ),
        shadowColor: Color(0xcc171717),

        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        title: StreamBuilder<DocumentSnapshot>(
          stream:
              _firestore.collection("users").doc(userMap['uid']).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                child: Column(
                  children: [
                    Text(
                      userMap['name'],
                      style: GoogleFonts.pacifico(
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 24)),
                    ),
                    Text(
                      snapshot.data!['status'],
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      height:15,
                    )
                  ],

                ),
              );
            } else {
              return Container();
            }
          },
        ),
        actions: [
          // Icon(
          //   Icons.person,
          //   size: 35,
          // )
        ],
      ),
      body: GestureDetector(
        onTap: ()=> FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.black45,
                child: Container(
                
                  decoration: BoxDecoration(               
                   
                      gradient: LinearGradient(
                    colors: [Colors.black87, Colors.pinkAccent, Colors.black87],
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    //stops: [0.4,0.2,0.4]
                  )),
                  height: size.height / 1.25,
                  width: size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('chatroom')
                        .doc(chatRoomId)
                        .collection('chats')
                        .orderBy("time", descending: false)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data != null) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> map = snapshot.data!.docs[index]
                                .data() as Map<String, dynamic>;
                            return messages(size, map, context);
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Expanded(
                  child: Container(
                    //  decoration: BoxDecoration(
                    //      borderRadius: BorderRadius.only(
                    //        topLeft: Radius.circular(30),
                    //        topRight: Radius.circular(50),
                    //      )                                                                        // Yahahaaaaa
                    // ),
                    color: Color(0xff3B3B3B),
                    height: size.height / 12,
                    width: size.width,
                    // alignment: Alignment.center,
                    child: Container(
                      height: size.height / 14,
                      width: size.width / 1.1,
                      child: Row(
                        
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              height: size.height / 17,
                              width: size.width / 1.3,
                              child: TextField(
                                textCapitalization: TextCapitalization.sentences,                          // yaha
                                style: TextStyle(color: Colors.white),
                                controller: _message,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                    suffixIcon: IconButton(
                                      onPressed: () => getImage(),
                                      icon: Icon(Icons.photo),
                                      color: Colors.white,
                                    ),
                                    hintText: "Send Message",
                                    hintStyle: TextStyle(color: Colors.white60),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    )),
                              ),
                            ),
                          ),
                          // IconButton(onPressed:() =>  getImage, icon: Icon(Icons.photo), color: Colors.white,),
                         
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: IconButton(
                                icon: Icon(Icons.send),
                                color: Colors.white,
                                onPressed: onSendMessage),
                          ),
                        ],
                      ),
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

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    return map['type'] == "text"
        ? Container(
            // width: size.width,
            // alignment: map['sendby'] == _auth.currentUser!.displayName
            //     ? Alignment.centerRight
            //     : Alignment.centerLeft,
            child: ChatBubble(
            clipper: ChatBubbleClipper6(
                type: map['sendby'] == _auth.currentUser!.displayName
                    ? BubbleType.sendBubble
                    : BubbleType.receiverBubble),
            alignment: map['sendby'] == _auth.currentUser!.displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            margin: EdgeInsets.only(top: 20),
            backGroundColor: map['sendby'] == _auth.currentUser!.displayName
                ? Color(0xff222222)
                : Colors.pinkAccent,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              child: Text(map['message'],
                  style: GoogleFonts.aclonica(
                      textStyle: TextStyle(color: Colors.white, fontSize: 14))),
            ),
          )
            // Container(
            //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            //   margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(15),
            //     color: Colors.blue,
            //   ),
            //   child: Text(
            //     map['message'],
            //     style: TextStyle(
            //       fontSize: 16,
            //       fontWeight: FontWeight.w500,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
            )
        : Container(
            height: size.height / 2.5,
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment: map['sendby'] == _auth.currentUser!.displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ShowImage(
                    imageUrl: map['message'],
                  ),
                ),
              ),
              child: Container(
                height: size.height / 2.5,
                width: size.width / 2,
                decoration: BoxDecoration(border: Border.all()),
                alignment: map['message'] != "" ? null : Alignment.center,
                child: map['message'] != ""
                    ? Image.network(
                        map['message'],
                        fit: BoxFit.cover,
                      )
                    : CircularProgressIndicator(),
              ),
            ),
          );
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}

