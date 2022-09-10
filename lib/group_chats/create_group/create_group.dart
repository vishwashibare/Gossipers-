import 'package:chat_app/Screens/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class CreateGroup extends StatefulWidget {
  final List<Map<String, dynamic>> membersList;

  const CreateGroup({required this.membersList, Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController _groupName = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  void createGroup() async {
    setState(() {
      isLoading = true;
    });

    String groupId = Uuid().v1();

    await _firestore.collection('groups').doc(groupId).set({
      "members": widget.membersList,
      "id": groupId,
    });

    for (int i = 0; i < widget.membersList.length; i++) {
      String uid = widget.membersList[i]['uid'];

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(groupId)
          .set({
        "name": _groupName.text,
        "id": groupId,
      });
    }

    await _firestore.collection('groups').doc(groupId).collection('chats').add({
      "message": "${_auth.currentUser!.displayName} Created This Group.",
      "type": "notify",
    });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Group Name",
          style: GoogleFonts.pacifico(
              textStyle: TextStyle(color: Colors.white, fontSize: 30)),
        ),
        flexibleSpace: Image(
          image: AssetImage('assets/appbarImage.jpeg'),
          fit: BoxFit.cover,
        ),
        shadowColor: Color(0xcc171717),
        toolbarHeight: 80,
      ),
      body: isLoading
          ? Container(
              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [Colors.black,Colors.blueGrey,Colors.black]
      )),
            child: Column(
                children: [
                  SizedBox(
                    height: size.height / 10,
                  ),
                   Container(
                      height: size.height / 14,
                      width: size.width,
                      alignment: Alignment.center,
                      child: Container(
                        height: size.height / 14,
                        width: size.width / 1.15,
                        child: TextField(
                          controller: _groupName,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Enter Group Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ),

                  SizedBox(
                    height: size.height / 50,
                  ),
                  Container(
                    child: ElevatedButton(

                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xffffEfEE)),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                            shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                             RoundedRectangleBorder( borderRadius:BorderRadius.circular(30),)
                            )
                      ),
                      onPressed: createGroup,
                      child: Text("Create Group"),
                    ),

                  )
                ],
              ),
          ),
    );
  }
}