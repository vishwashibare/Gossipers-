import 'package:chat_app/Authenticate/Methods.dart';
import 'package:chat_app/Screens/ChatRoom.dart';
import 'package:chat_app/Themes/themes.dart';
import 'package:chat_app/group_chats/group_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

int toggle = 0;

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver  {
  late AnimationController _con;
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");

  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Image(
          image: AssetImage('assets/appbarImage.jpeg'),
          fit: BoxFit.cover,
        ),
        shadowColor: Color(0xcc171717),
        // toolbarHeight: 90,
        //backgroundColor: Colors.black,

        title: Center(child: Text("Home Screen",style: GoogleFonts.chauPhilomeneOne(
            textStyle:
            TextStyle(color: Colors.white, fontSize: 22)))),
        actions: [
          Column(
           
            children: [
            Expanded(
              child: IconButton(icon: Icon(Icons.logout), onPressed: () => logOut(context),
                      ),
            ),
           Text("LogOut", style: GoogleFonts.chauPhilomeneOne(
             textStyle: TextStyle(
               color: Colors.white, fontSize: 15
             )
           ),),
          ],
          )

        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30))),
      ),
      body: Container(
        // color: Colors.white,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
              top: Radius.elliptical(MediaQuery.of(context).size.width,100)
          ),
          // image: DecorationImage(

          //  image: AssetImage('assets/images/Login2.jpeg'),
          // fit: BoxFit.cover)
        ),
        child: isLoading
            ? Center(
          child: Container(

            height: size.height / 20,
            width: size.height / 20,
            child: CircularProgressIndicator(),
          ),
        )
            : Column(
          children: <Widget> [
                  /*  Container(
              decoration: BoxDecoration(
               // image: DecorationImage(image:AssetImage("assets/appbarImage.jpeg") ),
                 gradient: LinearGradient(
                    colors: [Colors.black,Colors.blueGrey,Colors.black]),
               borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(150),
                  bottomRight: Radius.circular(150),
                )
              ),
              height: size.height / 26,
              
            ),*/
            Container(
              height: size.height / 13,
              width: size.width,
              alignment: Alignment.center,
              color: Colors.white,
              
              child: Row(
                children: [

                  Container(
                    // decoration: BoxDecoration(
                    //   color: Color(0xff3B3B3B)
                    // ),
                    height: size.height / 5,
                    width: size.width / 1.20,
                    color: Colors.white,
                    child: Card(

                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      // shadowColor: Colors.black,
                      // color: Colors.transparent,

                      child: TextField(
                        cursorColor: Colors.black,
                        controller: _search,
                        decoration: InputDecoration(
                          /*  enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,),
                                  ),*/
                          //  prefixIcon: Icon(Icons.search,color: Colors.black,),
                          hoverColor: Colors.white,
                          hintText: "  Search for username here!",
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Card(
                      margin: EdgeInsets.all(1),
                      elevation: 15,
                      shadowColor: Colors.black,
                      color: Colors.redAccent.shade100,

                      shape:CircleBorder(),

                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: IconButton(
                          onPressed: onSearch,
                          icon: Icon(
                            Icons.search,
                          ),
                          iconSize: 35,

                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /* SizedBox(
                    height: size.height / 50,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black
                    ),
                    onPressed: onSearch,
                    child: Text("Search",),
                  ),*/
            SizedBox(
              height: size.height / 50,
            ),

            userMap != null
                ? Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(MediaQuery.of(context).size.width,100)
                    ),
                    /*  image: DecorationImage(

                                    image: AssetImage('assets/images/Login2.jpeg'),
                                    fit: BoxFit.cover)*/
                  ),
                  child: Card(
                    elevation: 40,
                    margin: new EdgeInsets.symmetric(horizontal: 20),
                    color: drawerBackgroundColor1,
                    //drawerBackgroundColor1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: ListTile(
                      onTap: () {
                        String roomId = chatRoomId(
                            _auth.currentUser!.displayName!,
                            userMap!['name']);

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChatRoom(
                              chatRoomId: roomId,
                              userMap: userMap!,
                            ),
                          ),
                        );
                      },
                      leading:
                      Icon(Icons.account_box, color: Colors.black),
                      title: Text(
                        userMap!['name'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(userMap!['email'], 
                      ),
                      trailing: Icon(Icons.chat, color: Colors.black),
                    ),
                  ),
                ),
              ],

            )

                : Container(),
            Expanded(
              child: Container(
                //  color: Colors.black,
                decoration: BoxDecoration(
                  //color: Colors.black,
                  // image: DecorationImage(
                  //   image: AssetImage('assets/homescreen.jpeg'),fit: BoxFit.cover
                  //
                  // )
                  gradient: LinearGradient(
                    colors: [Colors.black,Colors.blueGrey,Colors.black]
                  )
                  /*borderRadius: BorderRadius.vertical(
                                 top: Radius.elliptical(MediaQuery.of(context).size.width,1)
                               ),*/
                  /*  image: DecorationImage(

                                    image: AssetImage('assets/images/Login2.jpeg'),
                                    fit: BoxFit.cover)*/
                ),
              ),
            )
          ],

        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: Icon(Icons.group, color: Colors.black,),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => GroupChatHomeScreen(),
          ),
        ),
      ),
    );
  }
}

