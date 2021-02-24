import 'package:comrade/Drawerpages/podcastsection.dart';
import 'package:flutter/material.dart';
import 'package:media_info/media_info.dart';
import 'package:nice_button/NiceButton.dart';
import '../services/db_services.dart';
import 'package:file_picker/file_picker.dart';
import '../animation/FadeAnimation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io' as io;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UploadPodcasts extends StatefulWidget {

  @override
  _UploadPodcastsState createState() => _UploadPodcastsState();
}

class _UploadPodcastsState extends State<UploadPodcasts> {
  DbServices db = DbServices();

  TextEditingController name = TextEditingController();

  TextEditingController description = TextEditingController();

  PlatformFile thumbnail;

  PlatformFile _current;

  Map<String, dynamic> _currentInfo;

  final MediaInfo _mediaInfo = MediaInfo();

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
                MaterialPageRoute(builder: (context) => Podcastsection()));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Upload Podcast",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Center(
          child:
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  // Padding(
                  //   padding: EdgeInsets.only(top: 40, left: 40, right: 40),
                  //   child: Container(
                  //     padding: EdgeInsets.only(
                  //       bottom: 50,
                  //       left: 80,
                  //       right: 80,
                  //     ),
                  //     height: 200,
                  //     width: double.maxFinite,
                  //     child: Card(
                  //       elevation: 0,
                  //       color: Colors.grey[350],
                  //       child: Image.asset("assets/camera1.png"),
                  //     ),
                  //   ),
                  // ),
                  // // SizedBox(
                  // //   height: 5,
                  // // ),
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //     right: 190,
                  //   ),
                  //   child: Text("Name of the podcast "),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.only(top: 5, left: 40, right: 40),
                  //   child: TextFormField(
                  //     cursorWidth: 1.5,
                  //     cursorColor: Colors.orange,
                  //     decoration: InputDecoration(
                  //       contentPadding: EdgeInsets.all(16),
                  //       filled: false,
                  //       enabledBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(5.0),
                  //         borderSide: BorderSide(
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //     ),
                  //     keyboardType: TextInputType.emailAddress,
                  //     style: new TextStyle(
                  //         fontFamily: "Poppins", fontSize: 16, color: Colors.white),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //     right: 160,
                  //   ),
                  //   child: Text("Description of the Podcast"),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.only(top: 5, left: 40, right: 40),
                  //   child: TextFormField(
                  //     cursorWidth: 1.5,
                  //     cursorColor: Colors.orange,
                  //     decoration: InputDecoration(
                  //       contentPadding: EdgeInsets.all(70),
                  //       filled: false,
                  //       enabledBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(5.0),
                  //         borderSide: BorderSide(
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //     ),
                  //     keyboardType: TextInputType.emailAddress,
                  //     style: new TextStyle(
                  //         fontFamily: "Poppins", fontSize: 16, color: Colors.white),
                  //   ),
                  // ),

                  InkWell(
                    onTap: () async {
                      FilePickerResult result = await FilePicker.platform.pickFiles(
                        allowedExtensions: ['jpg', 'png', 'jpeg'],
                          type: FileType.custom,
                        allowMultiple: false
                      );
                      if(result != null) {
                        thumbnail = result.files.first;
                        setState(() {});
                      } else {
                        Fluttertoast.showToast(msg: 'No file Selected!');
                      }
                    },
                    child: CircleAvatar(
                      radius: 50,
                      child: thumbnail == null ? Icon(Icons.image) : null,
                      backgroundImage: thumbnail == null ? null : FileImage(io.File(thumbnail.path)),
                    ),
                  ),

                  SizedBox(height: 30),
                  NiceButton(
                    width: size.width * 0.85,
                    radius: 10,
                    padding: const EdgeInsets.all(20),
                    text: _current == null ? "Select Podcast" : "Selected(${_current.extension})",
                    fontSize: 20,
                    textColor: Colors.white,
                    gradientColors: [Colors.orange, Colors.orange],
                    background: Colors.white,
                    onPressed: () async {
                        FilePickerResult result = await FilePicker.platform.pickFiles(
                            allowedExtensions: ['wav', 'mp3', 'acc', 'ogg'],
                            type: FileType.custom,
                            allowMultiple: false
                        );

                        if(result != null) {
                          _current = result.files.first;
                          _mediaInfo.getMediaInfo(_current.path).then((value){
                            print(value);
                            _currentInfo = value;
                          });
                          print(_currentInfo['durationMs']);
                          setState(() {});
                        } else {
                          return Fluttertoast.showToast(msg: 'No file Selected!');
                        }
                    },
                  ),
                  SizedBox(height: 30),

                  FadeAnimation(0.2, makeInput(name, label: 'Title')),
                  FadeAnimation(0.2, makeInput(description, label: 'Description')),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Column(
                  //       children: [
                  //         new FlatButton(
                  //           onPressed: () async {
                  //             if(_current.path == null || thumbnail == null || name.text.isEmpty || description.text.isEmpty){
                  //               return Fluttertoast.showToast(msg: 'Name/Description/Thumbnail and recording is required!');
                  //             }
                  //             ProgressDialog dialog = ProgressDialog(context);
                  //             dialog.style(message: "Please wait...");
                  //             await dialog.show();
                  //             db.uploadFile('podcasts', io.File(_current.path)).then((podcast) {
                  //               db.uploadFile('thumbnails', io.File(thumbnail.path)).then((thumbnail){
                  //                 db.addData('podcasts', {
                  //                   'podcast':podcast,
                  //                   'thumbnail':thumbnail,
                  //                   'name':name.text,
                  //                   'description':description.text
                  //                 }).then((value) async {
                  //                   await dialog.hide();
                  //                   value ? Fluttertoast.showToast(msg: 'Podcast Uploaded!') :
                  //                   Fluttertoast.showToast(msg: 'Something goes wrong!');
                  //                 });
                  //               });
                  //             });
                  //           },
                  //           child:
                  //           new Text("Upload Podcast", style: TextStyle(color: Colors.white)),
                  //           color: Colors.blueAccent.withOpacity(0.5),
                  //         ),
                  //       ],
                  //     )
                  //   ],
                  // ),

                  SizedBox(height: 30),
                  NiceButton(
                    width: size.width * 0.85,
                    radius: 10,
                    padding: const EdgeInsets.all(20),
                    text: "Upload",
                    fontSize: 20,
                    textColor: Colors.white,
                    gradientColors: [Colors.orange, Colors.orange],
                    background: Colors.white,
                    onPressed: () async {
                      if(_current.path == null || thumbnail == null || name.text.isEmpty || description.text.isEmpty){
                        return Fluttertoast.showToast(msg: 'Name/Description/Thumbnail and recording is required!');
                      }
                      ProgressDialog dialog = ProgressDialog(context);
                      dialog.style(message: "Please wait...");
                      await dialog.show();
                      db.uploadFile('podcasts', io.File(_current.path)).then((podcast) {
                        db.uploadFile('thumbnails', io.File(thumbnail.path)).then((thumbnail){
                          db.addData('podcasts', {
                            'podcast':podcast,
                            'uid':user.uid,
                            'email':user.email,
                            'thumbnail':thumbnail,
                            'name':name.text,
                            'description':description.text,
                            'duration': _currentInfo.containsKey('durationMs') ? _currentInfo['durationMs']/1000 : 0
                          }).then((value) async {
                            await dialog.hide();
                            value ? Fluttertoast.showToast(msg: 'Podcast Uploaded!') :
                            Fluttertoast.showToast(msg: 'Something goes wrong!');
                          });
                        });
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
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
        obscureText: obscureText,
        cursorColor: Colors.orange,
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
