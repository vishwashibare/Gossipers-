import 'package:chat_app/Authenticate/Autheticate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_app/Screens/HomeScreen.dart';
import 'package:chat_app/startup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Authenticate/login_screen.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     theme: ThemeData(
       primarySwatch: Colors.red,
       fontFamily: "PTSerif"
     ),
    initialRoute: "/startupRoute",
     routes: {
       "/startupRoute": (context)=> StartupRoute(),
       "/homeRoute": (context)=> HomeScreen(),
       "/login": (context)=> LoginScreen(),
     },
      debugShowCheckedModeBanner: false,
      home: Authenticate(),
    );
  }
}
