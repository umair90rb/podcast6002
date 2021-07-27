import 'package:comrade/login.dart';
import 'package:comrade/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:comrade/Dashboard.dart';
import 'package:comrade/main.dart';

AuthServices auth = AuthServices();

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text(
      "Cancel",
      style: TextStyle(
        color: Colors.black,
        fontFamily: "Raleway",
      ),
    ),
    onPressed: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Dashboard(auth.getUser)));
    },
  );
  Widget continueButton = FlatButton(
    child: Text(
      "Logout",
      style: TextStyle(
        color: Colors.orange,
        fontFamily: "Raleway",
      ),
    ),
    onPressed: () async {
      auth.signOut().then(
            (value) => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
                (route) => false),
          );
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      "Warning",
      style: TextStyle(
        fontFamily: "Raleway",
      ),
    ),
    content: Text(
      "This will log you out of the app. Are you sure?",
      style: TextStyle(
        fontFamily: "Raleway",
      ),
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    // barrierColor: Colors.black,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
