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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard(user)));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Request Payment",
          style: TextStyle(color: Colors.white),
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
                    "Please if you have decent amount of earnings in your account let the support know to pay you."),
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
                controller: name,
                cursorColor: Colors.orange,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "Name",
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
                enabled: false,
                controller: TextEditingController(text: user.email),
                maxLines: 1,
                cursorColor: Colors.orange,
                decoration: InputDecoration(
                  hintText: "Email",
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
                controller: earning,
                cursorColor: Colors.orange,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "How much earnings do you have",
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
                controller: account,
                cursorColor: Colors.orange,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "Account Number",
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
                controller: detail,
                cursorColor: Colors.orange,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText:
                      "Please write a small message request to let the admin know you have correct details given and how much earnings do you have.",
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
            NiceButton(
              background: Colors.white,
              width: size.width * 0.30,
              radius: 10,
              padding: const EdgeInsets.all(10),
              text: "Send",
              gradientColors: [Colors.orange, Colors.orange],
              onPressed: () async {
                if(name.text.isEmpty || earning.text.isEmpty || account.text.isEmpty){
                  return Fluttertoast.showToast(msg: 'Name/Earning/Account No is required!');
                }
                ProgressDialog dialog = ProgressDialog(context);
                dialog.style(message: 'Please wait...');
                await dialog.show();
                db.addCollection('paymentRequests', user.uid, "paymentRequest", DateTime.now().millisecondsSinceEpoch.toString(), {
                  'uid':user.uid,
                  'email':user.email,
                  'name':name.text,
                  'earning': earning.text,
                  'account':account.text,
                  'detail':detail.text
                }).then((value) async {
                  if(!value){
                    await dialog.hide();
                    Fluttertoast.showToast(msg: 'Something goes wrong!');
                  }
                  await dialog.hide();
                  Fluttertoast.showToast(msg: 'Request submitted, admin will contact you soon!');
                  Navigator.pop(context);
                });
              },
            ),
          ]),
        ),
      ),
    );
  }
}
