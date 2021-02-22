import 'package:comrade/Drawerpages/profile.dart';
import 'package:flutter/material.dart';
import 'package:nice_button/NiceButton.dart';

class Changepass extends StatefulWidget {
  @override
  _ChangepassState createState() => _ChangepassState();
}

class _ChangepassState extends State<Changepass> {
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.orange,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Myaccount()));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Change Password",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50, right: 160),
                  child: Container(
                    child: Text(
                      "CREATE NEW PASSWORD",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 30, right: 30),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your current password';
                      }
                      return null;
                    },
                    cursorWidth: 1.5,
                    decoration: InputDecoration(
                      labelText: "Current Password",
                      labelStyle: TextStyle(color: Colors.black),
                      fillColor: Colors.transparent,
                      focusColor: Colors.black,
                      hoverColor: Colors.black,
                      contentPadding: EdgeInsets.all(10),
                      filled: true,
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    style: new TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 30, right: 30),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    validator: (value) {
                      if (value.length < 6) {
                        return 'Please Enter Password';
                      }
                      return null;
                    },
                    obscureText: true,
                    cursorWidth: 1.5,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      errorText: "Password must contain at leat 8 characters",
                      fillColor: Colors.transparent,
                      focusColor: Colors.black,
                      hoverColor: Colors.black,
                      labelStyle: TextStyle(color: Colors.black),
                      errorStyle: TextStyle(color: Colors.black),
//                      prefixIcon: Icon(Icons.security),
                      contentPadding: EdgeInsets.all(10),
                      filled: true,
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    style: new TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 30, right: 30),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your current password';
                      }
                      return null;
                    },
                    cursorWidth: 1.5,
                    decoration: InputDecoration(
                      labelText: "Confirm New Password",
                      labelStyle: TextStyle(color: Colors.black),
                      fillColor: Colors.transparent,
                      focusColor: Colors.black,
                      hoverColor: Colors.black,
                      contentPadding: EdgeInsets.all(10),
                      filled: true,
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    style: new TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                NiceButton(
                  width: size.width * 0.85,
                  radius: 10,
                  padding: const EdgeInsets.all(20),
                  text: "Submit",
                  fontSize: 20,
                  textColor: Colors.white,
                  gradientColors: [Colors.grey[600], Colors.grey[600]],
                  onPressed: () {},
                  background: Colors.white,
                ),
                // SizedBox(
                //   height: 20,
                // ),
                // Text("OR"),
                // SizedBox(
                //   height: 20,
                // ),
                // InkWell(
                //   onTap: () {},
                //   child: Container(
                //     height: 50,
                //     width: size.width * 0.85,
                //     decoration: BoxDecoration(
                //       color: Colors.blue[900],
                //       borderRadius: BorderRadius.circular(50),
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                //       children: [
                //         // Image.asset("assets/images/facebook.png", color: Color.fromRGBO(59, 89, 153, 1),),
                //         Text(
                //           "Continue with Facebook",
                //           style: TextStyle(
                //             letterSpacing: 2,
                //             color: Colors.white,
                //             fontSize: 17,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
