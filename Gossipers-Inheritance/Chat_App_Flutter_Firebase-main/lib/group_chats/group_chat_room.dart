
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupChatRoom extends StatelessWidget {
  final String groupChatId, groupName;

  GroupChatRoom({required this.groupName, required this.groupChatId, Key? key})
      : super(key: key);

  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  
  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> chatData = {
        "sendBy": _auth.currentUser!.displayName,
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();

      await _firestore
          .collection('groups')
          .doc(groupChatId)
          .collection('chats')
          .add(chatData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(flexibleSpace: Image(
        image: AssetImage('assets/appbarImage.jpeg'),
        fit: BoxFit.cover,
      ),
        shadowColor: Color(0xcc171717),

        title: Text(groupName,style: GoogleFonts.pacifico(
            textStyle:
            TextStyle(color: Colors.white, fontSize: 24)),),
        actions: [
         
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container( decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black87, Colors.pinkAccent, Colors.black87],
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  //stops: [0.4,0.2,0.4]
                )),
              height: size.height / 1.27,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('groups')
                    .doc(groupChatId)
                    .collection('chats')
                    .orderBy('time')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> chatMap =
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;

                        return messageTile(size, chatMap);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            SingleChildScrollView(
              child: Container(

                color: Color(0xff3B3B3B),
                height: size.height / 10,
                width: size.width,
                // alignment: Alignment.center,
                child: Container(
                   
                      
                  height: size.height / 12,
                  width: size.width / 1.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Container(
                         padding: EdgeInsets.only(left: 10),
                          height: size.height / 17,
                          width: size.width / 1.3,
                          child: TextField( style: TextStyle(color: Colors.white),
                            controller: _message,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                                
                                hintText: "Send Message",
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: IconButton(
                            icon: Icon(Icons.send,color: Colors.white,), onPressed: onSendMessage),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageTile(Size size, Map<String, dynamic> chatMap) {
    return Builder(builder: (_) {
      if (chatMap['type'] == "text") {
        return Container(
          width: size.width,
          alignment: chatMap['sendBy'] == _auth.currentUser!.displayName
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(

              // clipper: ChatBubbleClipper6(
              // type: chatMap['sendby'] == _auth.currentUser!.displayName
              //     ? BubbleType.sendBubble
              //     : BubbleType.receiverBubble),
              // alignment: chatMap['sendby'] == _auth.currentUser!.displayName
              //     ? Alignment.centerRight
                  //: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(
                  color: Colors.black54,
                  blurRadius: 4.0,
                  offset: Offset(4.0,4.0)
                )],
                borderRadius: BorderRadius.only(topRight:Radius.circular(20),
                  topLeft:Radius.circular(20),
               bottomRight: chatMap['sendBy'] == _auth.currentUser!.displayName
                ?Radius.circular(0)
                :Radius.circular(20),
                bottomLeft:chatMap['sendBy'] == _auth.currentUser!.displayName
                    ?Radius.circular(20)
                    :Radius.circular(0), ),
                color: chatMap['sendBy'] == _auth.currentUser!.displayName
                    ? Color(0xff222222)
                    : Colors.pinkAccent,
              ),
              // backGroundColor: chatMap['sendby'] == _auth.currentUser!.displayName
              //     ? Color(0xff222222)
              //     : Colors.pinkAccent,

              child: Column(
                children: [
                  Text(
                    chatMap['sendBy'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.pink.shade900,
                    ),
                  ),
                  SizedBox(
                    height: size.height / 200,
                  ),
                  Text(
                    chatMap['message'],
                      style: GoogleFonts.aclonica(
                          textStyle: TextStyle(color: Colors.white, fontSize: 16)
                    ),

                  ),
              SizedBox(
                height: size.height / 200,)
                ],
              )),
        );
      } else if (chatMap['type'] == "img") {
        return Container(
          width: size.width,
          alignment: chatMap['sendBy'] == _auth.currentUser!.displayName
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            height: size.height / 2,
            child: Image.network(
              chatMap['message'],
            ),
          ),
        );
      } else if (chatMap['type'] == "notify") {
        return Container(
          width: size.width,
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black38,
            ),
            child: Text(
              chatMap['message'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        return SizedBox();
      }
    });
  }
}
