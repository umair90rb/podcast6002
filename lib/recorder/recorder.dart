import 'dart:async';
import 'dart:io' as io;

import 'package:audioplayers/audioplayers.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:file_picker/file_picker.dart';
import '../animation/FadeAnimation.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import '../services/db_services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RecorderExample extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  RecorderExample({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  State<StatefulWidget> createState() => new RecorderExampleState();
}

class RecorderExampleState extends State<RecorderExample> {
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  DbServices db = DbServices();

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  PlatformFile thumbnail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return SingleChildScrollView(
      child: new Center(
        child: new Padding(
          padding: new EdgeInsets.all(8.0),
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new FlatButton(
                        onPressed: () {
                          switch (_currentStatus) {
                            case RecordingStatus.Initialized:
                              {
                                _start();
                                break;
                              }
                            case RecordingStatus.Recording:
                              {
                                _pause();
                                break;
                              }
                            case RecordingStatus.Paused:
                              {
                                _resume();
                                break;
                              }
                            case RecordingStatus.Stopped:
                              {
                                _init();
                                break;
                              }
                            default:
                              break;
                          }
                        },
                        child: _buildText(_currentStatus),
                        color: Colors.lightBlue,
                      ),
                    ),
                    new FlatButton(
                      onPressed:
                      _currentStatus != RecordingStatus.Unset ? _stop : null,
                      child:
                      new Text("Stop", style: TextStyle(color: Colors.white)),
                      color: Colors.blueAccent.withOpacity(0.5),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    new FlatButton(
                      disabledTextColor: Colors.blueAccent.withOpacity(0.5),
                      disabledColor: Colors.black45,
                      onPressed: _currentStatus == RecordingStatus.Initialized || _currentStatus == RecordingStatus.Recording ? null : onPlayAudio,
                      child:
                      new Text("Play", style: TextStyle(color: Colors.white)),
                      color: Colors.blueAccent.withOpacity(0.5),
                    ),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Text(
                      _current == null ? "" : _current.duration.toString().substring(0, 7),
                      style: TextStyle(
                        fontSize: 22
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
                InkWell(
                  onTap: () async {
                    FilePickerResult result = await FilePicker.platform.pickFiles();
                    if(result != null) {
                      thumbnail = result.files.first;
                      setState(() {

                      });
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: CircleAvatar(
                    radius: 50,
                   child: thumbnail == null ? Icon(Icons.image) : null,
                    backgroundImage: thumbnail == null ? null : FileImage(io.File(thumbnail.path)),
                  ),
                ),
                FadeAnimation(0.2, makeInput(name, label: 'Title')),
                FadeAnimation(0.2, makeInput(description, label: 'Description')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        new FlatButton(
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
                                  'thumbnail':thumbnail,
                                  'name':name.text,
                                  'description':description.text
                                }).then((value) async {
                                  await dialog.hide();
                                  value ? Fluttertoast.showToast(msg: 'Podcast Uploaded!') :
                                          Fluttertoast.showToast(msg: 'Something goes wrong!');
                                });
                              });
                            }).catchError((error, stacktrace){
                              Fluttertoast.showToast(msg: 'Something goes wrong try again!');
                            });
                          },
                          child:
                          new Text("Upload Podcast", style: TextStyle(color: Colors.white)),
                          color: Colors.blueAccent.withOpacity(0.5),
                        ),
                      ],
                    )
                  ],
                ),
                // new Text("Status : $_currentStatus"),
                // new Text('Avg Power: ${_current?.metering?.averagePower}'),
                // new Text('Peak Power: ${_current?.metering?.peakPower}'),
                // new Text("File path of the record: ${_current?.path}"),
                // new Text("Format: ${_current?.audioFormat}"),
                // new Text(
                //     "isMeteringEnabled: ${_current?.metering?.isMeteringEnabled}"),
                // new Text("Extension : ${_current?.extension}"),
                // new Text(
                //     "Audio recording duration : ${_current?.duration.toString()}")
              ]),
        ),
      ),
    );
  }

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
          thumbnail = null;
          name.text = '';
          description.text = '';
          print(_currentStatus);
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  _stop() async {
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status;
    });
  }

  Widget _buildText(RecordingStatus status) {
    var text = "";
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          text = 'Start';
          break;
        }
      case RecordingStatus.Recording:
        {
          text = 'Pause';
          break;
        }
      case RecordingStatus.Paused:
        {
          text = 'Resume';
          break;
        }
      case RecordingStatus.Stopped:
        {
          text = 'Record Again';
          break;
        }
      default:
        break;
    }
    return Text(text, style: TextStyle(color: Colors.white));
  }

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(_current.path, isLocal: true);
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
