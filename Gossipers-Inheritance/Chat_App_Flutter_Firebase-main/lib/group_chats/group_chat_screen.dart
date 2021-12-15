import 'package:chat_app/Themes/themes.dart';
import 'package:chat_app/group_chats/create_group/add_members.dart';
import 'package:chat_app/group_chats/group_chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupChatHomeScreen extends StatefulWidget {
  const GroupChatHomeScreen({Key? key}) : super(key: key);

  @override
  _GroupChatHomeScreenState createState() => _GroupChatHomeScreenState();
}

class _GroupChatHomeScreenState extends State<GroupChatHomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;

  List groupList = [];

  @override
  void initState() {
    super.initState();
    getAvailableGroups();
  }

  void getAvailableGroups() async {
    String uid = _auth.currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .get()
        .then((value) {
      setState(() {
        groupList = value.docs;
        isLoading = false;
      });
    });
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
        title: Text("Groups",style: GoogleFonts.chauPhilomeneOne(
            textStyle:
            TextStyle(color: Colors.white, fontSize: 22)),),
      ),
      body: isLoading
          ? Container(

              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
        colors: [Colors.black,Colors.blueGrey,Colors.black],
          //begin: Alignment.topRight,end:Alignment.bottomLeft
        ),),
            child: ListView.builder(
                itemCount: groupList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(height: 3,),
                      Card(
                        elevation: 40,
                        margin: new EdgeInsets.symmetric(horizontal: 10),
                        color: drawerBackgroundColor1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),

                          child: ListTile(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => GroupChatRoom(
                                  groupName: groupList[index]['name'],
                                  groupChatId: groupList[index]['id'],
                                ),
                              ),
                            ),
                            leading: Icon(Icons.group),
                            title: Text(groupList[index]['name'],style: GoogleFonts.pacifico(
                                textStyle:
                                TextStyle(color: Colors.black, fontSize: 20)),),
                          ),
                        ),

                    ],
                  );
                },
              ),
          ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: Icon(Icons.create),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddMembersInGroup(),
          ),
        ),
        tooltip: "Create Group",
      ),
    );
  }
}
