import 'package:comrade/Dashboard.dart';
import 'package:comrade/services/auth.dart';
import 'package:comrade/services/db_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'animation/FadeAnimation.dart';
import 'forgotpass.dart';
import 'confirm_email.dart';

class LoginPage extends StatelessWidget {
  AuthServices auth = AuthServices();
  DbServices db = DbServices();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FadeAnimation(
                          1,
                          Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Raleway",
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                          1.2,
                          Text(
                            "Login to your account",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[700],
                              fontFamily: "Raleway",
                            ),
                          )),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                        FadeAnimation(
                            1.2,
                            makeInput(
                              email,
                              label: "Email",
                            )),
                        FadeAnimation(
                            1.3,
                            makeInput(password,
                                label: "Password", obscureText: true)),
                      ],
                    ),
                  ),
                  FadeAnimation(
                      1.4,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Container(
                          padding: EdgeInsets.only(),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border(
                                bottom: BorderSide(color: Colors.black),
                                top: BorderSide(color: Colors.black),
                                left: BorderSide(color: Colors.black),
                                right: BorderSide(color: Colors.black),
                              )),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            onPressed: () async {
                              if (email.text.isEmpty || password.text.isEmpty) {
                                return Fluttertoast.showToast(
                                  msg: "Usename/Password required!",
                                  toastLength: Toast.LENGTH_SHORT,
                                );
                              }
                              ProgressDialog dialog = ProgressDialog(context);
                              dialog.style(
                                  message: 'Please wait...',
                                  messageTextStyle: TextStyle(
                                    fontFamily: "Raleway",
                                  ));
                              await dialog.show();
                              auth
                                  .emailSignIn(email.text, password.text)
                                  .then((value) async {
                                if (value != null) {
                                  await dialog.hide();
                                  if (value.emailVerified) {
                                    db
                                        .getDoc('/profile', value.uid)
                                        .then((profile) {
                                      if (profile
                                              .data()
                                              .containsKey('approved') &&
                                          profile['approved'] == true) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Dashboard(value),
                                            ));
                                      } else {
                                        return showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                clipBehavior: Clip.hardEdge,
                                                // titlePadding: EdgeInsets.all(10),
                                                // contentPadding: EdgeInsets.all(10),
                                                title: Text(
                                                  'Wait for Admin Approval!',
                                                  style: TextStyle(
                                                    fontFamily: "Raleway",
                                                  ),
                                                ),
                                                content: Text(
                                                  'Please wait until admin approves your account!',
                                                  style: TextStyle(
                                                    fontFamily: "Raleway",
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Text(
                                                        'Got it',
                                                        style: TextStyle(
                                                          color: Colors.orange,
                                                          fontFamily: "Raleway",
                                                        ),
                                                      )),
                                                ],
                                              );
                                            });
                                      }
                                    });
                                  } else {
                                    return showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            clipBehavior: Clip.hardEdge,
                                            // titlePadding: EdgeInsets.all(10),
                                            // contentPadding: EdgeInsets.all(10),
                                            title: Text(
                                              'Confirm your Email!',
                                              style: TextStyle(
                                                fontFamily: "Raleway",
                                              ),
                                            ),
                                            content: Text(
                                              'Please confirm your email address. Check your email and click on the link and login again.',
                                              style: TextStyle(
                                                fontFamily: "Raleway",
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      fontFamily: "Raleway",
                                                    ),
                                                  )),
                                            ],
                                          );
                                        });
                                  }
                                } else {
                                  await dialog.hide();
                                  Fluttertoast.showToast(
                                    msg: "Invalid Usename/Password!",
                                    toastLength: Toast.LENGTH_SHORT,
                                  );
                                }
                              });

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => Dashboard()));
                            },
                            color: Colors.orange,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: "Raleway",
                              ),
                            ),
                          ),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 150),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword()),
                        );
                      },
                      child: Text(
                        "Forgotten Password?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: "Raleway",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FadeAnimation(
                1.2,
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/mentors.jpg'),
                          fit: BoxFit.cover)),
                ))
          ],
        ),
      ),
    );
  }

  Widget makeInput(controller, {label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
            fontFamily: "Raleway",
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          style: TextStyle(
            fontFamily: "Raleway",
          ),
          controller: controller,
          obscureText: obscureText,
          cursorColor: Colors.orange,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange)),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
