import 'package:chat_app/Authenticate/Autheticate.dart';
import 'package:chat_app/startup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Authenticate/LoginScree.dart';
import 'Screens/HomeScreen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Theme.of(context).primaryColor,
      theme: ThemeData(
        primaryColor: Colors.amber
      ),
      debugShowCheckedModeBanner: false,
       initialRoute: "/startupRoute",
       routes: {
       "/startupRoute": (context)=> StartupRoute(),
       "/homeRoute": (context)=> HomeScreen(),
       "/login": (context)=> LoginScreen(),
     }, 
      home: Authenticate(),
    );
  }
}
