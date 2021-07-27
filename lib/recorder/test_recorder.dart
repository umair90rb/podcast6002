import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comrade/CallScreens/pickup/circle_painter.dart';
import 'package:comrade/CallScreens/pickup/curve_wave.dart';
import 'package:comrade/animation/FadeAnimation.dart';
import 'package:comrade/services/db_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' as io;

class TestRecorder extends StatefulWidget {
  @override
  _TestRecorderState createState() => _TestRecorderState();
}

class _TestRecorderState extends State<TestRecorder>  with TickerProviderStateMixin {
  String statusText = "";
  bool isComplete = false;
  DbServices db = DbServices();

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  PlatformFile thumbnail;
  AudioPlayer audioPlayer = AudioPlayer();
  RecordMp3 mp3 = RecordMp3.instance;

  AnimationController _controller;
  Color rippleColor = Colors.orange;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    super.initState();
  }



  Widget _button() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                rippleColor,
                Color.lerp(rippleColor, Colors.black, .05)
              ],
            ),
          ),
          child: ScaleTransition(
            scale: Tween(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(
                parent: _controller,
                curve: const CurveWave(),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Icon(Icons.mic, size: 100,)
            ),
          ),
        ),
      ),
    );
  }

  double shake(double animation) =>
      2 * (0.5 - (0.5 - Curves.bounceOut.transform(animation)).abs());


  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Record Podcasts',
          style: TextStyle(fontFamily: "Raleway"),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: [
            Visibility(
              visible: false,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: SizedBox(
                            width: 370.0,
                            height: 50.0,
                            child: RaisedButton(
                              splashColor: Colors.white,
                              color: Colors.orange,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: Color(0xFFFF9800))),
                              onPressed: () async {
                                startRecord();
                              },
                              child: Text(
                                "Start Recording",
                                style: TextStyle(
                                    color: Colors.white, fontFamily: "Raleway"),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: SizedBox(
                            width: 370.0,
                            height: 50.0,
                            child: RaisedButton(
                                splashColor: Colors.white,
                                color: Colors.orange,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(color: Color(0xFFFF9800))),
                                onPressed: () async {
                                  pauseRecord();
                                },
                                child: Text(
                                  RecordMp3.instance.status == RecordStatus.PAUSE
                                      ? 'Resume Recording'
                                      : 'Pause Recording',
                                  style: TextStyle(
                                      fontFamily: "Raleway", color: Colors.white),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: SizedBox(
                            width: 370.0,
                            height: 50.0,
                            child: RaisedButton(
                              splashColor: Colors.white,
                              color: Colors.orange,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: Color(0xFFFF9800))),
                              onPressed: () async {
                                stopRecord();
                              },
                              child: Text(
                                "Stop Recording",
                                style: TextStyle(
                                  fontFamily: "Raleway",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                play();
              },
              child: Container(
                margin: EdgeInsets.only(top: 10),
                alignment: AlignmentDirectional.center,
                width: 100,
                height: 50,
                child: isComplete && recordFilePath != null
                    ? Text(
                        "",
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      )
                    : Container(),
              ),
            ),
            Visibility(
              visible: !isComplete,
              child: Column(
                children: [
                  SizedBox(height:75),
                  InkWell(
                    onTap: (){
                      if(_controller.isAnimating){
                        pauseRecord();
                       _controller.stop(canceled: false);
                      } else {
                        startRecord();
                        _controller.repeat();
                      }
                    },
                    child: CustomPaint(
                      painter: CirclePainter(
                        _controller,
                        color: rippleColor,
                      ),
                      child: SizedBox(
                        child: _button(),
                      ),
                    ),
                  ),
                  SizedBox(height: 120,),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      statusText,
                      style: TextStyle(
                          color: Colors.black, fontSize: 20, fontFamily: "Raleway"),
                    ),
                  ),
                  Visibility(
                    visible: !_controller.isAnimating,
                    child: IconButton(
                      onPressed: () => stopRecord(),
                      icon: Icon(Icons.stop, size: 35,),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isComplete,
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      FilePickerResult result = await FilePicker.platform.pickFiles();
                      if (result != null) {
                        thumbnail = result.files.first;
                        setState(() {});
                      } else {
                        // User canceled the picker
                      }
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.orange,
                      child: thumbnail == null
                          ? Icon(Icons.image, color: Colors.white)
                          : null,
                      backgroundImage: thumbnail == null
                          ? null
                          : FileImage(io.File(thumbnail.path)),
                    ),
                  ),
                  FadeAnimation(0.2, makeInput(name, label: 'Title')),
                  FadeAnimation(0.2, makeInput(description, label: 'Description')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
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
                                    side: BorderSide(color: Color(0xFFFF9800))),
                                onPressed: () async {
                                  if (thumbnail == null ||
                                      name.text.isEmpty ||
                                      description.text.isEmpty ||
                                      recordFilePath == null) {
                                    return Fluttertoast.showToast(
                                        msg:
                                            'Name/Description/Thumbnail and recording is required!');
                                  }
                                  ProgressDialog dialog = ProgressDialog(context);
                                  dialog.style(
                                      message: "Uploading Podcast...",
                                      messageTextStyle:
                                          TextStyle(fontFamily: "Raleway"));
                                  await dialog.show();
                                  stopRecord();
                                  db.getDoc('profile', user.uid).then((profile){
                                    db
                                        .uploadFile('podcasts', io.File(recordFilePath))
                                        .then((podcast) {
                                      dialog.update(message:"Uploading Thumbnail...");
                                      db
                                          .uploadFile(
                                          'thumbnails', io.File(thumbnail.path))
                                          .then((thumbnail) {
                                        dialog.update(message:"Publishing Podcast...");
                                        db.addData('podcasts', {
                                          'podcast': podcast,
                                          'uid': user.uid,
                                          'thumbnail': thumbnail,
                                          'category': profile['experties'],
                                          'name': name.text,
                                          'description': description.text,
                                          'duration': _duration
                                        }).then((value) async {
                                          await dialog.hide();
                                          name.text = '';
                                          description.text = '';
                                          this.thumbnail = null;
                                          this.recordFilePath = null;
                                          this.statusText = '';
                                          setState(() {});
                                          value
                                              ? Fluttertoast.showToast(
                                              msg: 'Podcast Uploaded!')
                                              : Fluttertoast.showToast(
                                              msg: 'Something goes wrong!');
                                        });
                                      });
                                    }).catchError((error, stacktrace) {
                                      Fluttertoast.showToast(
                                          msg: 'Something goes wrong try again!');
                                    });
                                  });
                                },
                                child: new Text("Upload Podcast",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Raleway",
                                        fontSize: 20)),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Timer _timer;
  int _start = 0;
  int _duration;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          _start++;
        });
        print(_start);
      },
    );
  }

  @override
  void dispose() {
    _timer != null ? _timer.cancel() : null;
    _controller.dispose();
    super.dispose();
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      statusText = "Recording...";
      recordFilePath = await getFilePath();
      isComplete = false;
      RecordMp3.instance.start(recordFilePath, (type) {
        statusText = "Record error--->$type";
        setState(() {});
      });

      _start = 0;
      startTimer();
    } else {
      statusText = "No microphone permission provided";
    }
    setState(() {});
  }

  void pauseRecord() {
    if (RecordMp3.instance.status == RecordStatus.PAUSE) {
      bool s = RecordMp3.instance.resume();
      if (s) {
        statusText = "Recording...";
        setState(() {});
        startTimer();
      }
    } else {
      bool s = RecordMp3.instance.pause();
      if (s) {
        statusText = "Recording Paused";
        _timer.cancel();
        setState(() {});
      }
    }
  }

  void stopRecord() {
    bool s = RecordMp3.instance.stop();
    if (s) {
      statusText = "Recording Complete";
      isComplete = true;
      _timer.cancel();
      _duration = _start;
      _start = 0;
      setState(() {});
    }
  }

  void resumeRecord() {
    bool s = RecordMp3.instance.resume();
    if (s) {
      statusText = "Recording...";
      startTimer();
      setState(() {});
    }
  }

  String recordFilePath;

  void play() {
    if (recordFilePath != null && File(recordFilePath).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      audioPlayer.play(recordFilePath, isLocal: true);
    }
  }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}_${DateTime.now()}.mp3";
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
              fontFamily: "Raleway"),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          style: TextStyle(fontFamily: "Raleway"),
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
}
