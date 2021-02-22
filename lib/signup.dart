import 'package:comrade/login.dart';
import 'package:comrade/services/auth.dart';
import 'package:comrade/services/db_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'Dashboard.dart';
import 'animation/FadeAnimation.dart';

import 'package:dropdown_formfield/dropdown_formfield.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _myActivity;
  String _myActivityResult;

  final formKey = new GlobalKey<FormState>();

  AuthServices auth = AuthServices();
  DbServices db = DbServices();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    _myActivity = '';
    _myActivityResult = '';
  }

  _saveForm() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _myActivityResult = _myActivity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var dropDownFormField = DropDownFormField(
      titleText: 'Choose Expertise Category',
      hintText: 'Select one option',
      value: _myActivity,
      onSaved: (value) {
        setState(() {
          _myActivity = value;
        });
        print(_myActivity);
      },
      onChanged: (value) {
        setState(() {
          _myActivity = value;
          print(_myActivity);
        });
      },
      dataSource: [
        {
          "display": "Relationship",
          "value": "Relationship",
        },
        {
          "display": "Nutrition",
          "value": "Nutrition",
        },
        {
          "display": "Beauty",
          "value": "Beauty",
        },
        {
          "display": "Career & Education",
          "value": "Career & Education",
        },
        {
          "display": "Work & Profession",
          "value": "Work & Profession",
        },
        {
          "display": "Entrepreneurship",
          "value": "Entrepreneurship",
        },
        {
          "display": "Travel",
          "value": "Travel",
        },
        {
          "display": "Investment",
          "value": "Investment",
        },
        {
          "display": "Legal",
          "value": "Legal",
        },
        {
          "display": "Emotional",
          "value": "Emotional",
        },
      ],
      textField: 'display',
      valueField: 'value',
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeAnimation(
                      1,
                      Text(
                        "Sign up",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  FadeAnimation(
                      1.2,
                      Text(
                        "Create your mentoring account, It's free",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      )),
                ],
              ),
              Column(
                children: <Widget>[
                  FadeAnimation(1.2, makeInput(email, label: "Email")),
                  FadeAnimation(
                      1.3, makeInput(password, label: "Password", obscureText: true)),
                  FadeAnimation(1.4,
                      makeInput(confirmPassword, label: "Confirm Password", obscureText: true)),
                  FadeAnimation(
                    1.3,
                    Padding(
                      padding: EdgeInsets.only(),
                      child: dropDownFormField,
                    ),
                  ),
                ],
              ),
              FadeAnimation(
                  1.5,
                  Container(
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

                        if(email.text.isEmpty || password.text.isEmpty || _myActivity.isEmpty || confirmPassword.text.isEmpty){

                          return Fluttertoast.showToast(
                              msg: "All fields require!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );

                        }

                        ProgressDialog dialog = ProgressDialog(context);
                        dialog.style(message: 'Please wait...');
                        await dialog.show();

                        auth.signUp(email.text, password.text).then((value) async {
                          if(value != null){
                            db.addDataWithId('/profile', value.uid, {
                              'experties': _myActivity,
                              'type':'podcaster',
                              'email': email.text
                            }).then((value) async {
                              print(value);
                              await dialog.hide();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Dashboard()),
                              );
                            });

                          } else {
                            await dialog.hide();
                            Fluttertoast.showToast(
                                msg: "Something goes wrong!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }
                        });
                      },
                      color: Colors.orange,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  )),
              FadeAnimation(
                1.6,
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      "Login if already have an account",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: controller,
          cursorColor: Colors.orange,
          obscureText: obscureText,
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
          height: 20,
        ),
      ],
    );
  }
}
