import 'package:comrade/services/db_services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../callscreen.dart';
import '../../constants.dart';
import '../../CallScreens/pickup/circle_painter.dart';
import '../../CallScreens/pickup/curve_wave.dart';
import '../../utils/permissions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class PickupScreen extends StatefulWidget {
  QuerySnapshot query;
  PickupScreen(this.query);

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Color rippleColor = Colors.red;
  DbServices db = DbServices();

  @override
  void initState() {
    super.initState();
    playRingtone();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }
  playRingtone() async {
    await FlutterRingtonePlayer.playRingtone();
  }
  stopRingtone() async {
    await FlutterRingtonePlayer.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    stopRingtone();
    print("=======DISPOSE=========");
    super.dispose();
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
              child: CachedNetworkImage(
                imageUrl: 'https://www.allthetests.com/quiz22/picture/pic_1171831236_1.png',
                placeholder: (context, url) => Container(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(kPrimaryColor),
                  ),
                  width: 180.0,
                  height: 180.0,
                  padding: EdgeInsets.all(70.0),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8.0)),
                ),
                errorWidget: (context, url, error) => Material(
                  child: Image.asset(
                    "images/img_not_available.jpeg",
                    width: 180.0,
                    height: 180.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  clipBehavior: Clip.hardEdge,
                ),
                width: 180.0,
                height: 180.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void pickCall(BuildContext context) async {
    await FlutterRingtonePlayer.stop();
    await db.updateDoc('call', widget.query.docs.first.id, {'status':'attended'});
    await Permissions.cameraAndMicrophonePermissionsGranted()
        ? Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CallScreen(widget.query.docs.first)))
        : Fluttertoast.showToast(msg: 'No Permission!');
  }

  double shake(double animation) =>
      2 * (0.5 - (0.5 - Curves.bounceOut.transform(animation)).abs());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
              painter: CirclePainter(
                _controller,
                color: rippleColor,
              ),
              child: SizedBox(
                width: 320.0,
                height: 180.0,
                child: _button(),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "Incoming...",
              style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                  fontFamily: "Raleway",
                  fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 75,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.redAccent),
                  child: IconButton(
                    iconSize: 30.0,
                    icon: Icon(Icons.call_end),
                    color: Colors.white,
                    onPressed: () async {
                      await db.updateDoc('call', widget.query.docs.first.id, {
                        'status':'declined'
                      });
                      await FlutterRingtonePlayer.stop();
                    },
                  ),
                ),
                SizedBox(
                  width: 25,
                ),
                Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.green),
                  child: IconButton(
                      iconSize: 30.0,
                      icon: Icon(Icons.call),
                      color: Colors.white,
                      onPressed: () => pickCall(context)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
