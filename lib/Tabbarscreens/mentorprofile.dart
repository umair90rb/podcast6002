import 'package:comrade/services/auth.dart';
import 'package:comrade/services/db_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'dart:io' as io;

class Mentorprofile extends StatefulWidget {
  @override
  _MentorprofileState createState() => _MentorprofileState();
}

class _MentorprofileState extends State<Mentorprofile> {
  DbServices _db = DbServices();
  AuthServices _auth = AuthServices();
  PlatformFile avatar;

  final _formKey = GlobalKey<FormState>();

  TextEditingController qualification ;
  TextEditingController experience ;
  TextEditingController description ;

  var user;
  String name = '';
  String exper = '';
  String picture = '';


  getProfile(String uid){
    _db.getDoc('profile', uid).then((profile) {
      print(profile);
      mounted ? setState(() {
        name = profile.data().containsKey('name') ? profile['name'] : '';
        exper = profile['experties'];
        picture = profile.data().containsKey('photoURL') ? profile['photoURL'] : '';
        qualification = TextEditingController(text: !profile.data().containsKey('qualification') ? null : profile['qualification']);
        experience = TextEditingController(text: !profile.data().containsKey('experience') ? null : profile['experience']);
        description = TextEditingController(text: !profile.data().containsKey('description') ? null : profile['description']);
      }) : null ;
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
    user = Provider.of<User>(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(children: [
            SafeArea(
              child: Container(
                child: Center(
                  child: Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                      ),
                      child: Text(
                        name,
                        // profile != null ? 'Name' : profile['name'],
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 10,
                      ),
                      child: Text(
                        "$exper Mentor",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30, left: 40, right: 40),
                      child: InkWell(
                        // onTap: () async {
                        //   FilePickerResult result = await FilePicker.platform.pickFiles();
                        //   var dialog = ProgressDialog(context);
                        //   dialog.style(message: 'Please wait...');
                        //   if(result != null) {
                        //     await dialog.show();
                        //     avatar = result.files.first;
                        //     _db.uploadFile('avatars', io.File(result.files.first.path)).then((value) {
                        //       _auth.updateUser(value).then((value) async {
                        //         await dialog.hide();
                        //         setState(() {});
                        //         return Fluttertoast.showToast(msg: 'Profile picture updated!');
                        //       });
                        //     });
                        //     setState(() {});
                        //
                        //   } else {
                        //     return Fluttertoast.showToast(msg: 'No file selected!');
                        //   }
                        // },
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                               NetworkImage(picture == '' ? 'https://via.placeholder.com/150' : picture),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      padding: EdgeInsets.only(bottom: 10),
                      child: TextField(
                        enabled: false,
                        onChanged: (value){},
                        controller: qualification,
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
                        enabled: false,
                        onChanged: (value){},
                        controller: experience,
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
                        enabled: false,
                        controller: description,
                        onChanged: (value){},
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
                    // NiceButton(
                    //   background: Colors.white,
                    //   width: size.width * 0.30,
                    //   radius: 10,
                    //   padding: const EdgeInsets.all(10),
                    //   text: "Save",
                    //   gradientColors: [Colors.orange, Colors.orange],
                    //   onPressed: () async {
                    //     if(qualification.text.isEmpty || charges.text.isEmpty || experience.text.isEmpty || description.text.isEmpty){
                    //       return Fluttertoast.showToast(msg: 'Nothing to updated!');
                    //     }
                    //     ProgressDialog dialog = ProgressDialog(context);
                    //     dialog.style(message: "Please wait...");
                    //     await dialog.show();
                    //
                    //     _db.updateDoc('profile', user.uid, {
                    //       'qualification':qualification.text,
                    //       'experience':experience.text,
                    //       'description':description.text,
                    //       'charges': charges.text
                    //     }).then((value) async {
                    //       await dialog.hide();
                    //       Fluttertoast.showToast(msg: 'Profile updated');
                    //     });
                    //   },
                    // ),
                    // SizedBox(height: 20,)
                    // For user app un-comment the below code and use it the same there as well
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // NiceButton(
                    //   background: Colors.white,
                    //   width: size.width * 1,
                    //   radius: 10,
                    //   padding: const EdgeInsets.all(10),
                    //   text: "Confirm Mentor",
                    //   gradientColors: [Colors.orange, Colors.orange],
                    //   onPressed: () {},
                    // ),
                  ]),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
