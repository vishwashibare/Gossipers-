import 'package:chat_app/Authenticate/Methods.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Screens/HomeScreen.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;
  String name = "";
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height / 1,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/backgroundImage.jpeg'),
                fit: BoxFit.cover)),
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
                          icon: Icon(Icons.arrow_back_ios), onPressed: () {}),
                    ),
                    SizedBox(
                      height: size.height / 50,
                    ),
                    Container(
                      width: size.width / 1.1,
                      child: Text(
                        "Welcome $name", 
                        style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      width: size.width / 1.1,
                      child: Text(
                        "Create Account to Continue!",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      
                      child: Container(
                       height: 55,
                       width: size.width,
                       // alignment: Alignment.center,
                        // child:
                        // field(size, "Username", Icons.account_box, _name),
                        child: Row(                              // Yaha change kiya humbne
                          children: [ 
                           
                            Expanded(
                              child: Container(
                              padding: EdgeInsets.all(5),
                               decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white
                              ),
                              borderRadius: BorderRadius.circular(30)
                              
                                                      ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Icon(Icons.account_circle, color: Colors.white,),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                    controller: _name,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                     contentPadding: EdgeInsets.all(15),
                                    //  fillColor: Colors.white,
                                      focusColor: Colors.white,
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Colors.white60,
                                        
                                      ),
                                      //filled: true,
                                      // focusedBorder: OutlineInputBorder(
                                      
                                      //   borderRadius: BorderRadius.circular(25),
                                      //   borderSide: BorderSide(
                                      //     color: Colors.white
                                      //   )
                                     // ),
                                        hintText: "Enter Username",
                                        
                                       // labelText: "Username"
                                        ),
                                        
                                    onChanged: (value) {
                                      name = value;
                                      setState(() {
                                        
                                      });
                                    },
                                                                  ),
                                  ),
                                ]),
                                                      ),
                            ),
                          ] ),
                      ),
                    ),
                    Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: field(size, "Email", Icons.account_box, _email),

                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: field(size, "Password", Icons.lock, _password),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    customButton(size),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_name.text.isNotEmpty &&
            _email.text.isNotEmpty &&
            _password.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });

          createAccount(_name.text, _email.text, _password.text).then((user) {
            if (user != null) {
              setState(() {
                isLoading = false;
              });
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HomeScreen()));
              //print("Account Created Sucessfull");
               Fluttertoast.showToast(msg: "Account created Successfully");
            } else {
            //  print("Login Failed");
             Fluttertoast.showToast(msg: "Login Failed");
              setState(() {
                isLoading = false;
              });
            }
          });
        } else {
          //print("Please enter Fields");
           Fluttertoast.showToast(msg: "Please enter valid credentials!");
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
            "Create Account",
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
              )),
          fillColor: Colors.white,
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
