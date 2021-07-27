import 'dart:io';

import 'package:comrade/login.dart';
import 'package:comrade/services/auth.dart';
import 'package:comrade/services/db_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'Dashboard.dart';
import 'animation/FadeAnimation.dart';
import 'confirm_email.dart';

import 'package:dropdown_formfield/dropdown_formfield.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _myActivity;
  String _myActivityResult;

  List docs = [];
  List id = [];

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
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Raleway",
                        ),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  FadeAnimation(
                      1.2,
                      Text(
                        "Create your mentoring account, It's free",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                          fontFamily: "Raleway",
                        ),
                      )),
                ],
              ),
              Column(
                children: <Widget>[
                  FadeAnimation(1.2, makeInput(email, label: "Email")),
                  FadeAnimation(
                      1.3,
                      makeInput(password,
                          label: "Password", obscureText: true)),
                  FadeAnimation(
                      1.4,
                      makeInput(confirmPassword,
                          label: "Confirm Password", obscureText: true)),
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
                  _selectImage(id, "Add National ID/Driver Licence",
                      single: true)),
              FadeAnimation(1.5, _selectImage(docs, "Add Important Documents")),
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
                        if (email.text.isEmpty ||
                            password.text.isEmpty ||
                            _myActivity.isEmpty ||
                            confirmPassword.text.isEmpty) {
                          return Fluttertoast.showToast(
                              msg: "All fields require!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                        if (id.isEmpty) {
                          return Fluttertoast.showToast(
                              msg: "Please add National ID or Driver Licence",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }

                        ProgressDialog dialog = ProgressDialog(context);
                        dialog.style(
                            message: 'Please wait...',
                            progressTextStyle: TextStyle(
                              fontFamily: "Raleway",
                            ));
                        await dialog.show();

                        try {
                          auth
                              .signUp(email.text, password.text)
                              .then((user) async {
                            if (user != null) {
                              String idUrl = await db.uploadFile(
                                  "images/${user.uid}/", File(id.first));
                              List docsUrl = docs.isNotEmpty
                                  ? await uploadImage(docs, user)
                                  : [];
                              db.addDataWithId('/profile', user.uid, {
                                'experties': _myActivity,
                                'type': 'podcaster',
                                'email': email.text,
                                'approved': false,
                                'id': idUrl,
                                'docs': docsUrl
                              }).then((value) async {
                                print(value);
                                await auth.sendEmailVerificationLink();
                                await dialog.hide();

                                return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        clipBehavior: Clip.hardEdge,
                                        title: Text(
                                          'Next step!',
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
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LoginPage())),
                                              child: Text('Login')),
                                        ],
                                      );
                                    });
                              });
                            } else {
                              await dialog.hide();
                              Fluttertoast.showToast(
                                  msg:
                                      "Something goes wrong or email already exist.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          });
                        } catch (ex) {
                          Fluttertoast.showToast(
                              msg: ex.toString(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      color: Colors.orange,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            fontFamily: "Raleway",
                            color: Colors.white),
                      ),
                    ),
                  )),
              SizedBox(
                height: 15,
              ),
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
                          fontFamily: "Raleway",
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

  Future uploadImage(List images, user) async {
    List urls = [];
    await Future.wait(
      images.map((e) async {
        String url = e.runtimeType == String
            ? e
            : await db.uploadFile('images/${user.uid}/', e);
        urls.add(url);
      }),
    );
    return urls;
  }

  _selectImage(List images, String label, {bool single = false}) {
    print(images);
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: () async {
                FilePickerResult result = await FilePicker.platform
                    .pickFiles(type: FileType.image, allowMultiple: !single);
                if (result != null) {
                  images.clear();
                  setState(() {
                    images.addAll(!single
                        ? result.paths.map((path) => File(path)).toList()
                        : [result.paths.first]);
                  });
                } else {
                  return Fluttertoast.showToast(msg: 'No file chosen!');
                }
              },
              child: Text(label),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
              ),
            ),
          ),
          SizedBox(
            height: images == null || images.length == 0 ? 0 : 125,
            child: !single
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: images.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.all(5),
                        child: Image.file(
                          images[index],
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                        clipBehavior: Clip.hardEdge,
                      );
                    },
                  )
                : images.isNotEmpty
                    ? Card(
                        margin: EdgeInsets.all(5),
                        child: Image.file(
                          File(images[0]),
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(),
          )
        ],
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
