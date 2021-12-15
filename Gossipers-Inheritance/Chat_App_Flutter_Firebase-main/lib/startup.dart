import 'package:chat_app/Authenticate/Autheticate.dart';

import 'package:flutter/material.dart';

class StartupRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/splash.gif"),
            SizedBox(
              height: 40,
            ),
            Center(
              child: Text("Welcome to Gossipers!", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),),
            ),
            SizedBox(height: 40,),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.amber),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                )
              ),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> Authenticate())
              ), 
            child: Text("Click Here to Continue!", style: TextStyle(
             color: Colors.black
            ),)
            )
          ],
        ),
      ),
    );
  }


  
}