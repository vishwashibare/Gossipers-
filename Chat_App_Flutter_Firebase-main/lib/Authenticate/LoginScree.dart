import 'package:chat_app/Authenticate/CreateAccount.dart';
import 'package:chat_app/Screens/HomeScreen.dart';
import 'package:chat_app/Authenticate/Methods.dart';
import 'package:chat_app/Themes/themes.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // backgroundColor: Colors.pink.shade200,

        body: Container(
          // padding: EdgeInsets.all(20),
          height: size.height / 1,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/backgroundImage.jpeg'),
                  fit: BoxFit.cover
              )
          ),
          child: isLoading
              ? Center(
            child: Container(
              height: size.height / 20,
              width: size.height / 20,
              child: CircularProgressIndicator(),
            ),
          )
              : SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                Container(

                  alignment: Alignment.centerLeft,
                  width: size.width / 0.5,
                  child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),color: Colors.white, onPressed: () {},iconSize: 30),
                ),
                Container(
                  width: 200.0,
                  height: 190.0,
                  decoration: new BoxDecoration(

                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/appbarImage.jpeg'),
                          fit: BoxFit.cover)
                  ),
                  child: Center(
                    child: Column(

                      children: [
                        Text(
                          "Welcome!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            height: 3,),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Text("G",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            Text("O",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.orange,
                              ),
                            ),
                            Text("S",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.yellow,
                              ),
                            ),
                            Text("S",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.green,
                              ),
                            ),
                            Text("I",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                              ),
                            ),
                            Text("P",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blueAccent.shade700,
                              ),
                            ),
                            Text("E",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.amber,
                              ),
                            ),
                            Text("R",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            Text("S",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 10,
                ),
                Container(
                  width: size.width / 1.1,
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Sign In to Continue!",
                    style: TextStyle(
                      color: drawerBackgroundColor1,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  width: size.width,


                  alignment: Alignment.center,
                  child: Container(

                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 1),
                      decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(12)
                      ),
                      child:field(size, "Email", Icons.account_box, _email)

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: Container(
                    width: 380,
                    decoration: BoxDecoration(
                      /* border: Border.all(
                             color: Colors.white,

                           ),*/
                        borderRadius: BorderRadius.circular(12)
                    ),
                    alignment: Alignment.center,
                    child: field(size, "Password", Icons.lock_outline, _password,),
                  ),
                ),
                SizedBox(
                  height: size.height / 10,
                ),
                customButton(size),
                SizedBox(
                  height: size.height / 40,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => CreateAccount())),
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });

          logIn(_email.text, _password.text).then((user) {
            if (user != null) {
              print("Login Sucessfull");
              setState(() {
                isLoading = false;
              });
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HomeScreen()));
            } else {
              print("Login Failed");
              setState(() {
                isLoading = false;
              });
            }
          });
        } else {
          print("Please fill form correctly");
        }
      },
      child: Container(
          height: size.height / 14,
          width: size.width / 1.2,
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(100),
            //  color: Colors.pink.shade300,
            image: DecorationImage(
              image: AssetImage('assets/appbarImage.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }

  Widget field(
      Size size, String hintText, IconData icon, TextEditingController cont) {
    return Container(
      height: size.height / 14,
      width: size.width / 1.1,
      child: TextField(

        controller: cont,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(29),
              borderSide: BorderSide(
                color: Colors.white,
              )
          ),
          prefixIcon: Icon(icon),

          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(29),
          ),
        ),
      ),
    );
  }
}
