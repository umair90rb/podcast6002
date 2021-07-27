import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comrade/services/db_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class ReportBug extends StatelessWidget {
  TextEditingController bugDescription = TextEditingController();
  DbServices db = DbServices();
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'Report a Bug',
          style: TextStyle(fontFamily: "Raleway"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Let us know which kind of bug you are facing we will fix it as soon as possible',
                    style: TextStyle(fontFamily: "Raleway", fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              makeInput(TextEditingController(text: user.email),
                  label: 'Email', enabled: false),
              makeInput(bugDescription,
                  label: 'Add Bug Description', maxLines: 5),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: 370.0,
                  height: 50.0,
                  child: RaisedButton(
                    splashColor: Colors.white,
                    elevation: 2,
                    color: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: () async {
                      if (bugDescription.text.isEmpty) {
                        return Fluttertoast.showToast(
                            msg: 'Please add bug description!');
                      } else {
                        ProgressDialog pr = ProgressDialog(context);
                        pr.style(
                            message: 'Please wait...',
                            progressTextStyle: TextStyle(
                              fontFamily: "Raleway",
                            ));
                        await pr.show();
                        db.addData('/bugs', {
                          'email': user.email,
                          'uid': user.uid,
                          'bugDescription': bugDescription.text,
                          'at': Timestamp.now(),
                          'app': 'mentor'
                        }).then((value) async {
                          await pr.hide();
                          bugDescription.text = '';
                          return Fluttertoast.showToast(
                              msg: 'Bug report submitted to admin!');
                        });
                      }
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Raleway",
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
              // text: 'Submit Bug Report',
              // background: Colors.orange)
            ],
          ),
        ),
      ),
    );
  }

  Widget makeInput(controller,
      {label, obscureText = false, bool enabled = true, int maxLines = 1}) {
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
          maxLines: maxLines,
          obscureText: obscureText,
          cursorColor: Colors.orange,
          enabled: enabled,
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
