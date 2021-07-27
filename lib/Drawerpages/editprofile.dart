import 'dart:io';

import 'package:comrade/Drawerpages/profile.dart';
import 'package:comrade/services/auth.dart';
import 'package:comrade/services/db_services.dart';
import 'package:file_picker/file_picker.dart';
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

  TextEditingController name;
  TextEditingController qualification;
  TextEditingController experience;
  TextEditingController description;
  TextEditingController bio;
  List certification = List();
  List licence = List();



  DbServices _db = DbServices();
  AuthServices _auth = AuthServices();

  var user;
  var profile;

  getProfile(String uid) {
    _db.getDoc('profile', uid).then((profile) {
      profile = profile;
      name = TextEditingController(
          text: !profile.data().containsKey('name') ? null : profile['name']);
      qualification = TextEditingController(
          text: !profile.data().containsKey('qualification')
              ? null
              : profile['qualification']);
      certification = !profile.data().containsKey('certification')
              ? []
              : profile['certification'];
      licence = !profile.data().containsKey('licence')
          ? []
          : profile['licence'];
      experience = TextEditingController(
          text: !profile.data().containsKey('experience')
              ? null
              : profile['experience']);
      description = TextEditingController(
          text: !profile.data().containsKey('description')
              ? null
              : profile['description']);
      bio = TextEditingController(
          text: !profile.data().containsKey('bio')
              ? null
              : profile['bio']);

      mounted ? setState(() {}) : null;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => getProfile(user.uid));
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
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Edit Profile",
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
                  "Please fill out the this carefully. This is your profile description that will be visible to others.",
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
              child: TextFormField(
                style: TextStyle(
                  fontFamily: "Raleway",
                ),
                controller: name,
                onChanged: (value) => {},
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
                style: TextStyle(
                  fontFamily: "Raleway",
                ),
                controller: experience,
                onChanged: (value) => {},
                cursorColor: Colors.orange,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "Experience in field",
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
                controller: description,
                onChanged: (value) => {},
                cursorColor: Colors.orange,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: "Detailed Description",
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
                controller: bio,
                onChanged: (value) => {},
                cursorColor: Colors.orange,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: "Bio",
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
            _selectImage(certification, "Select Certifications from Gallery"),
            SizedBox(
              height: 20,
            ),
            _selectImage(licence, "Select Licence from Gallery"),
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
                  hoverElevation: 5,
                  elevation: 2,
                  color: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: () async {
                    // var certificationContain = certification.where((element) => element.runtimeType != String);
                    // var licenceContain = licence.where((element)
                    // {
                    // print(element.runtimeType);
                    // return element.runtimeType != String;
                    // });
                    // print(certificationContain);
                    // print(licenceContain);
                    // if (name.text.isEmpty &&
                    //     qualification.text.isEmpty &&
                    //     experience.text.isEmpty &&
                    //     description.text.isEmpty &&
                    //     bio.text.isEmpty &&
                    //     certificationContain.isEmpty &&
                    //     licenceContain.isEmpty
                    // ) {
                    //   return Fluttertoast.showToast(msg: 'Nothing to updated!');
                    // }
                    ProgressDialog dialog = ProgressDialog(context);
                    dialog.style(
                        message: "Please wait...",
                        progressTextStyle: TextStyle(
                          fontFamily: "Raleway",
                        ));
                    await dialog.show();
                    List certificationsUrl = await uploadImage(certification);
                    List licenceUrl = await uploadImage(licence);
                    _db.updateDoc('profile', user.uid, {
                      'name': name.text,
                      'qualification': qualification.text,
                      'experience': experience.text,
                      'description': description.text,
                      'bio': bio.text,
                      'licence':licenceUrl,
                      'certification': certificationsUrl
                    }).then((value) async {
                      await dialog.hide();
                      certification.clear();
                      licence.clear();
                      Fluttertoast.showToast(msg: 'Profile updated');
                    });
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                        fontFamily: "Raleway",
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5,)
          ]),
        ),
      ),
    );
  }

  Future uploadImage(List images) async {
    List urls = [];
    await Future.wait(
      images.map((e) async {
        String url = e.runtimeType == String ? e :  await _db.uploadFile('images/${user.uid}/', e);
        urls.add(url);
      }),
    );
    return urls;
  }

  _selectImage(List images, String label) {
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
                        .pickFiles(type: FileType.image, allowMultiple: true);
                    if (result != null) {
                      images.clear();
                      setState(() {
                        images.addAll(result.paths.map((path) => File(path)).toList());
                      });
                    } else {
                      return Fluttertoast.showToast(msg: 'No file chosen!');
                    }
                  },
                  child: Text(label))),
          SizedBox(
            height: images == null || images.length == 0 ? 0 : 125,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: images.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(5),
                  child: images[index].runtimeType != String ? Image.file(
                    images[index],
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ) : Image.network(
                    images[index],
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                  clipBehavior: Clip.hardEdge,
                );
              },
            ),
          )
        ],
      ),
    );
  }

}
