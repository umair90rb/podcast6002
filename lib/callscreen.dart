import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comrade/services/db_services.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';

// import 'package:agora_rtc_engine/rtc_engine.dart';

import 'package:fluttertoast/fluttertoast.dart';

class CallScreen extends StatefulWidget {
  DocumentSnapshot doc;
  CallScreen(this.doc);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  DbServices db = DbServices();
  /// Define App ID and Token
  // String APP_ID = "08d675d2350c42a49ae5bff08b2424e1";
  // String APP_ID = "6cb4c202c8a2486a88b07787704572f5";
  String APP_ID = "925300e606f2495ca1f48fa46b0bd88c";

  // String token =
  //     "0066cb4c202c8a2486a88b07787704572f5IACneRrEPIetQRmMyppsu/K6F4Itsiteb60z6kdyZncVddJjSIgAAAAAEAB33sfLnbClYAEAAQCcsKVg";

  StreamSubscription callStreamReference;
  bool loudSpeaker = false;
  bool muted = false;
  bool mic = false;

  Timer _timer;
  int _start = 0;
  Duration duration ;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
          setState(() {
            _start++;
            duration = Duration(seconds: _start);
          });
      },
    );
  }

  String formateDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }



  @override
  void initState() {
    duration = Duration(seconds: 0);
    initPlatformState();
  }

  // Initialize the app
  Future<void> initPlatformState() async {
    // String channel = '123';
    // Create RTC client instance
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.disableVideo();
    // Define event handler
    eventHandler();
    await AgoraRtcEngine.setEnableSpeakerphone(false);
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    await AgoraRtcEngine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await AgoraRtcEngine.joinChannel(null, widget.doc['channel'], null, 0);
    startTimer();
  }

  void eventHandler() {
    AgoraRtcEngine.onError = (dynamic code) {
      print("onError $code");
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      print("onJoinChannelSuccess");
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      print("onUserJoined");
    };

    AgoraRtcEngine.onUpdatedUserInfo = (AgoraUserInfo userInfo, int i) {
      print("onUpdateUserInfo");
    };

    AgoraRtcEngine.onRejoinChannelSuccess = (String string, int a, int b) {
      print("onRejoinChannelSuccess");
    };

    AgoraRtcEngine.onUserOffline = (int a, int b) {
      print("onUserOffline");
      Navigator.pop(context);
    };

    AgoraRtcEngine.onRegisteredLocalUser = (String s, int i) {
      print("onRegisteredLocalUser");
    };

    AgoraRtcEngine.onLeaveChannel = () {
      print("onLeaveChannel");
    };

    AgoraRtcEngine.onConnectionLost = () {
      print("onConnectionLost");
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      // if call was picked
      print("onUserOffline");
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Call Ended');
    };
  }

  // Create a simple chat UI
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 200,
          ),
          Center(
              child: Text(
            'Call Connected...',
            style: TextStyle(
              fontSize: 18,
            ),
          ),),
          SizedBox(
            height: 30,
          ),
          Center(
              child: Text(
                "User Email\n${widget.doc['email']}",
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),),
          SizedBox(
            height: 30,
          ),
          Center(
              child: Text(
                "${formateDuration(duration)}",
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              )),
          Expanded(
            child: Container(),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RawMaterialButton(
                onPressed: () async {
                  setState(() {
                    muted = !muted;
                  });
                  await AgoraRtcEngine.muteAllRemoteAudioStreams(muted);
                },
                child: Icon(
                  Icons.volume_mute,
                  size: 35.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: muted ? Colors.green : Colors.white,
                padding: const EdgeInsets.all(15.0),
              ),
              SizedBox(
                height: 20,
              ),
              RawMaterialButton(
                onPressed: () async {
                  setState(() {
                    mic = !mic;
                  });
                  await AgoraRtcEngine.muteLocalAudioStream(mic);
                },
                child: Icon(
                  mic ? Icons.mic : Icons.mic_off,
                  size: 35.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(15.0),
              ),
              SizedBox(
                height: 20,
              ),
              RawMaterialButton(
                onPressed: () async {
                  setState(() {
                    loudSpeaker = !loudSpeaker;
                  });
                  await AgoraRtcEngine.setEnableSpeakerphone(loudSpeaker);
                },
                child: Icon(
                  Icons.volume_up,
                  size: 35.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: loudSpeaker ? Colors.green : Colors.white,
                padding: const EdgeInsets.all(15.0),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          RawMaterialButton(
            onPressed: (){
              db.updateDoc('call', widget.doc.id, {
                'status':'ended'
              }).then((value){
                return Navigator.pop(context);
              });
            },
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    FirebaseFirestore.instance
        .collection('call')
        .doc(widget.doc.id)
        .set({'status': 'ended'}, SetOptions(merge: true));
    // callStreamReference.cancel();
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    _timer.cancel();
    super.dispose();
  }
}
