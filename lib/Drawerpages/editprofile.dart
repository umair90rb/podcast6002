
import 'package:comrade/Drawerpages/profile.dart';
import 'package:comrade/services/auth.dart';
import 'package:comrade/services/db_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class Editprofile extends StatefulWidget {
  @override
  _EditprofileState createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController name ;
  TextEditingController qualification ;
  TextEditingController experience ;
  TextEditingController description ;

  DbServices _db = DbServices();
  AuthServices _auth = AuthServices();

  var user;
  var profile;

  getProfile(String uid){
    _db.getDoc('profile', uid).then((profile) {
        profile = profile;
        name = TextEditingController(text: !profile.data().containsKey('name') ? null : profile['name']);
        qualification = TextEditingController(text: !profile.data().containsKey('qualification') ? null : profile['qualification']);
        experience = TextEditingController(text: !profile.data().containsKey('experience') ? null : profile['experience']);
        description = TextEditingController(text: !profile.data().containsKey('description') ? null : profile['description']);

      mounted ? setState(() {}) : null ;
    });
  }


  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => getProfile(user.uid));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    user = Provider.of<User>(context);
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
              child: TextFormField(
                controller: name,
                onChanged: (value) => {},
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
                controller: qualification,
                onChanged: (value) => {},
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
                controller: experience,
                onChanged: (value) => {},
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
                controller: description,
                onChanged: (value) => {},
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
              onPressed: () async {
                if(name.text.isEmpty || qualification.text.isEmpty || experience.text.isEmpty || description.text.isEmpty){
                  return Fluttertoast.showToast(msg: 'Nothing to updated!');
                }
                ProgressDialog dialog = ProgressDialog(context);
                dialog.style(message: "Please wait...");
                await dialog.show();

                _db.updateDoc('profile', user.uid, {
                  'name':name.text,
                  'qualification':qualification.text,
                  'experience':experience.text,
                  'description':description.text
                }).then((value) async {
                  await dialog.hide();
                  Fluttertoast.showToast(msg: 'Profile updated');
                });
              },
            ),
          ]),
        ),
      ),
    );
  }
}
