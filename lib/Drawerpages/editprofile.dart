import 'package:comrade/Drawerpages/profile.dart';
import 'package:flutter/material.dart';
import 'package:nice_button/NiceButton.dart';

class Editprofile extends StatefulWidget {
  @override
  _EditprofileState createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final _formKey = GlobalKey<FormState>();

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
          "Edit Profile",
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
                    "Please fill out the this carefully. This is your profile description that will be visible to others."),
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
                cursorColor: Colors.orange,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "Qualification",
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
                cursorColor: Colors.orange,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "Experience in field",
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
                cursorColor: Colors.orange,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: "Detailed Description",
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
              text: "Save",
              gradientColors: [Colors.orange, Colors.orange],
              onPressed: () {},
            ),
          ]),
        ),
      ),
    );
  }
}
