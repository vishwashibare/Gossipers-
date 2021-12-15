import 'package:chat_app/group_chats/create_group/create_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddMembersInGroup extends StatefulWidget {
  const AddMembersInGroup({Key? key}) : super(key: key);

  @override
  State<AddMembersInGroup> createState() => _AddMembersInGroupState();
}

class _AddMembersInGroupState extends State<AddMembersInGroup> {
  final TextEditingController _search = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> membersList = [];
  bool isLoading = false;
  Map<String, dynamic>? userMap;

  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
  }

  void getCurrentUserDetails() async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((map) {
      setState(() {
        membersList.add({
          "name": map['name'],
          "email": map['email'],
          "uid": map['uid'],
          "isAdmin": true,
        });
      });
    });
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("name", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  void onResultTap() {
    bool isAlreadyExist = false;

    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i]['uid'] == userMap!['uid']) {
        isAlreadyExist = true;
      }
    }

    if (!isAlreadyExist) {
      setState(() {
        membersList.add({
          "name": userMap!['name'],
          "email": userMap!['email'],
          "uid": userMap!['uid'],
          "isAdmin": false,
        });

        userMap = null;
      });
    }
  }

  void onRemoveMembers(int index) {
    if (membersList[index]['uid'] != _auth.currentUser!.uid) {
      setState(() {
        membersList.removeAt(index);
      });
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
        title: Text("Add Members",style: GoogleFonts.chauPhilomeneOne(
            textStyle:
            TextStyle(color: Colors.white, fontSize: 22))),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [SizedBox(
            height: 20,
          ),
            Flexible(
              child: Card(elevation: 40,                                   // Yahah aaao
                margin: new EdgeInsets.symmetric(horizontal: 20),
                color: Colors.pink,
                //drawerBackgroundColor1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: ListView.builder(
                  itemCount: membersList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => onRemoveMembers(index),
                      leading: Icon(Icons.account_circle, color: Colors.white),
                      title: Text(membersList[index]['name'], style: TextStyle(
                        color: Colors.white,
                         fontWeight: FontWeight.bold
                      )),
                      subtitle: Text(membersList[index]['email'], 
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                      trailing: Icon(Icons.close, color: Colors.white),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: size.height / 20,
            ),
            Container(
              height: size.height / 14,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 14,
                width: size.width / 1.15,
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height / 50,
            ),
            isLoading
                ? Container(
                    height: size.height / 12,
                    width: size.height / 12,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.amber)),
                    onPressed: onSearch,
                    child: Text("Search", style:TextStyle(
                      color: Colors.black
                    )),
                  ),
                  SizedBox(
                    height: 35,
                  ),
            userMap != null
                ? Card(
                  elevation: 40,
                  margin: new EdgeInsets.symmetric(horizontal: 20),
                   color: Colors.pink,
                //drawerBackgroundColor1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                  child: ListTile(
                      onTap: onResultTap,
                      leading: Icon(Icons.account_box, color: Colors.white,),                 // yaha pe Changes karne hai, Card me wrap karo
                      title: Text(userMap!['name'], style: TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.bold
                      ),),
                      subtitle: Text(userMap!['email'], style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),),
                      trailing: Icon(Icons.add, color: Colors.white),
                    ),
                )
                : SizedBox(),
          ],
        ),
      ),
      floatingActionButton: membersList.length >= 2
          ? FloatingActionButton(
            backgroundColor: Colors.pink,
              child: Icon(Icons.forward),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CreateGroup(
                    membersList: membersList,
                  ),
                ),
              ),
            )
          : SizedBox(),
    );
  }
}
