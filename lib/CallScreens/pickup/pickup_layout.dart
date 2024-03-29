import '../../models/call.dart';
import '../../CallScreens/pickup/pickup_screen.dart';
import '../../resources/call_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final String uid;
  final CallMethods callMethods = CallMethods();

  PickupLayout({
    @required this.scaffold,
    @required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return uid != null
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(uid: uid),
            // initialData: null,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.data() != null) {
                print(snapshot.data.data());
                // Map<dynamic, dynamic> da = snapshot.data.data();
                Call call = Call.fromMap(snapshot.data.data());

                if (!call.hasDialled) {
                  FlutterRingtonePlayer.playRingtone();
                  print("PLAY");
                  // return PickupScreen(
                  //
                  // );
                }
                // print("STOP");
                print("=====================////====");
                FlutterRingtonePlayer.stop();
                return scaffold;
              }
              // print("STOP");
              FlutterRingtonePlayer.stop();
              return scaffold;
            })
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
