import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comrade/Drawerpages/podcastsection.dart';
import 'package:flutter/material.dart';
import 'package:media_info/media_info.dart';
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
    var user = Provider.of<User>(context);
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
          "Upload Podcast",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Raleway",
          ),
        ),
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[

                  InkWell(
                    onTap: () async {
                      FilePickerResult result = await FilePicker.platform
                          .pickFiles(
                              allowedExtensions: ['jpg', 'png', 'jpeg'],
                              type: FileType.custom,
                              allowMultiple: false);
                      if (result != null) {
                        thumbnail = result.files.first;
                        setState(() {});
                      } else {
                        Fluttertoast.showToast(msg: 'No file Selected!');
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.orange,
                      radius: 50,
                      child: thumbnail == null
                          ? Icon(
                              Icons.image,
                              color: Colors.white,
                            )
                          : null,
                      backgroundImage: thumbnail == null
                          ? null
                          : FileImage(io.File(thumbnail.path)),
                    ),
                  ),

                  SizedBox(height: 30),
                  // NiceButton(
                  //   width: size.width * 0.85,
                  //   radius: 10,
                  //   padding: const EdgeInsets.all(20),
                  //   text: _current == null
                  //       ? "Select Podcast"
                  //       : "Selected(${_current.extension})",
                  //   fontSize: 20,
                  //   textColor: Colors.white,
                  //   gradientColors: [Colors.orange, Colors.orange],
                  //   background: Colors.white,
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
                          FilePickerResult result = await FilePicker.platform
                              .pickFiles(allowedExtensions: [
                            'wav',
                            'mp3',
                            'acc',
                            'ogg'
                          ], type: FileType.custom, allowMultiple: false);

                          if (result != null) {
                            _current = result.files.first;
                            _mediaInfo
                                .getMediaInfo(_current.path)
                                .then((value) {
                              print(value);
                              _currentInfo = value;
                            });
                            setState(() {});
                          } else {
                            return Fluttertoast.showToast(
                                msg: 'No file Selected!');
                          }
                        },
                        child: Text(
                          _current == null
                              ? "Select Podcast"
                              : "Selected(${_current.extension})",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Raleway",
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  FadeAnimation(0.2, makeInput(name, label: 'Title')),
                  FadeAnimation(
                      0.2, makeInput(description, label: 'Description')),

                  SizedBox(height: 20),
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
                          if (_current.path == null ||
                              thumbnail == null ||
                              name.text.isEmpty ||
                              description.text.isEmpty) {
                            return Fluttertoast.showToast(
                                msg:
                                    'Name/Description/Thumbnail and recording is required!');
                          }
                          ProgressDialog dialog = ProgressDialog(context);
                          dialog.style(
                              message: "Uploading Podcast...",
                              progressTextStyle: TextStyle(
                                fontFamily: "Raleway",
                              ));
                          await dialog.show();
                          db.getDoc('profile', user.uid).then((profile){
                            db
                                .uploadFile('podcasts', io.File(_current.path))
                                .then((podcast) {
                              dialog.update(message:"Uploading Thumbnail...");
                              db
                                  .uploadFile(
                                  'thumbnails', io.File(thumbnail.path))
                                  .then((thumbnail) {
                                dialog.update(message: "Publishing Podcast...");
                                db.addData('podcasts', {
                                  'podcast': podcast,
                                  'uid': user.uid,
                                  'category': profile['experties'],
                                  'email': user.email,
                                  'thumbnail': thumbnail,
                                  'name': name.text,
                                  'description': description.text,
                                  'duration':
                                  _currentInfo.containsKey('durationMs')
                                      ? _currentInfo['durationMs'] / 1000
                                      : 0
                                }).then((value) async {
                                  await dialog.hide();
                                  value
                                      ? Fluttertoast.showToast(
                                      msg: 'Podcast Uploaded!')
                                      : Fluttertoast.showToast(
                                      msg: 'Something goes wrong!');
                                });
                              });
                            });
                          });
                        },
                        child: Text(
                          "Upload",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: "Raleway",
                          ),
                        ),
                      ),
                    ),
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
        obscureText: obscureText,
        cursorColor: Colors.orange,
        decoration: InputDecoration(
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
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
