import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comrade/services/db_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:comrade/Dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:provider/provider.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Requestpayment extends StatelessWidget {
  DbServices db = DbServices();

  TextEditingController name = TextEditingController();
  TextEditingController earning = TextEditingController();
  TextEditingController account = TextEditingController();
  TextEditingController detail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.orange,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Dashboard(user)));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Request Payment",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Raleway",
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Center(
                child: Text(
                  "Please if you have decent amount of earnings in your account let the support know to pay you.",
                  style: TextStyle(
                    fontFamily: "Raleway",
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
              ),
              padding: EdgeInsets.only(bottom: 10),
              child: TextField(
                style: TextStyle(
                  fontFamily: "Raleway",
                ),
                controller: name,
                cursorColor: Colors.orange,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "Name",
                  hintStyle: TextStyle(
                    fontFamily: "Raleway",
                  ),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              padding: EdgeInsets.only(bottom: 10),
              child: TextField(
                style: TextStyle(
                  fontFamily: "Raleway",
                ),
                enabled: false,
                controller: TextEditingController(text: user.email),
                maxLines: 1,
                cursorColor: Colors.orange,
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(
                    fontFamily: "Raleway",
                  ),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              padding: EdgeInsets.only(bottom: 10),
              child: TextField(
                style: TextStyle(
                  fontFamily: "Raleway",
                ),
                controller: earning,
                cursorColor: Colors.orange,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "How much earnings do you have",
                  hintStyle: TextStyle(
                    fontFamily: "Raleway",
                  ),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              padding: EdgeInsets.only(bottom: 10),
              child: TextField(
                style: TextStyle(
                  fontFamily: "Raleway",
                ),
                controller: account,
                cursorColor: Colors.orange,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "Account Number",
                  hintStyle: TextStyle(
                    fontFamily: "Raleway",
                  ),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              // hack textfield height
              padding: EdgeInsets.only(bottom: 10),
              child: TextField(
                style: TextStyle(
                  fontFamily: "Raleway",
                ),
                controller: detail,
                cursorColor: Colors.orange,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText:
                      "Please write a small message request to let the admin know you have correct details given and how much earnings do you have.",
                  hintStyle: TextStyle(
                    fontFamily: "Raleway",
                  ),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
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
                    if (name.text.isEmpty ||
                        earning.text.isEmpty ||
                        account.text.isEmpty) {
                      return Fluttertoast.showToast(
                          msg: 'Name/Earning/Account No is required!');
                    }
                    ProgressDialog dialog = ProgressDialog(context);
                    dialog.style(
                        message: 'Please wait...',
                        progressTextStyle: TextStyle(
                          fontFamily: "Raleway",
                        ));
                    await dialog.show();
                    db.addData('paymentRequests', {
                      'uid': user.uid,
                      'email': user.email,
                      'name': name.text,
                      'earning': earning.text,
                      'account': account.text,
                      'detail': detail.text,
                      'at': Timestamp.now()
                    }).then((value) async {
                      if (!value) {
                        await dialog.hide();
                        Fluttertoast.showToast(msg: 'Something goes wrong!');
                      }
                      await dialog.hide();
                      Fluttertoast.showToast(
                          msg:
                              'Request submitted, admin will contact you soon!');
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    "Send",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Raleway",
                        fontSize: 20),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
