import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comrade/Drawerpages/callhistory.dart';
import 'package:comrade/Drawerpages/chathistory.dart';
import 'package:comrade/Drawerpages/invite.dart';
import 'package:comrade/Drawerpages/podcastsection.dart';
import 'package:comrade/Drawerpages/reportbug.dart';
import 'package:comrade/chat/chat.dart';
import 'package:comrade/main.dart';
import 'package:comrade/resources/call_methods.dart';
import 'package:comrade/utils/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:comrade/Alert/logoutalert.dart';
import 'package:comrade/Drawerpages/profilepage.dart';
import 'package:comrade/Drawerpages/earninghistory.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';
import './utils/user_state_methods.dart';

import 'CallScreens/pickup/pickup_layout.dart';
import 'CallScreens/pickup/pickup_screen.dart';
import 'Drawerpages/requestpayment.dart';
import 'Drawerpages/termsnpolicies.dart';

class Dashboard extends StatefulWidget {
  User user;
  Dashboard(this.user);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final CallMethods callMethods = CallMethods();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      UserStateMethods().setUserState(widget.user.uid, "Online");
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        widget.user != null
            ? UserStateMethods().setUserState(widget.user.uid, "Online")
            : print("Resumed State");
        break;
      case AppLifecycleState.inactive:
        widget.user != null
            ? UserStateMethods().setUserState(widget.user.uid, "Offline")
            : print("Inactive State");
        break;
      case AppLifecycleState.paused:
        widget.user != null
            ? UserStateMethods().setUserState(widget.user.uid, "Waiting")
            : print("Paused State");
        break;
      case AppLifecycleState.detached:
        widget.user != null
            ? UserStateMethods().setUserState(widget.user.uid, "Offline")
            : print("Detached State");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: callMethods.callStream(uid: widget.user.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          QuerySnapshot query = snapshot.data;
          if (query.docs.isNotEmpty &&
              query.docs.first.data()['status'] != 'ended') {
            return PickupScreen(query);
          }
          return dashboardPage(context, widget.user);
        }
        return dashboardPage(context, widget.user);
      },
    );
  }

  Widget dashboardPage(BuildContext context, User user) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "Comrade Mentor",
          style: TextStyle(
            fontFamily: "Raleway",
          ),
        ),
        leading: GestureDetector(
          onTap: () => _drawerKey.currentState.openDrawer(),
          child: Icon(
            Icons.menu, // add custom icons also
          ),
        ),
      ),
      key: _drawerKey,
      endDrawerEnableOpenDragGesture: false,
      drawer: Drawer(
        child: Container(
          color: Colors.orange,
          child: ListView(
            padding: EdgeInsets.all(0),
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountEmail: Text(
                  user.email,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Raleway",
                  ),
                ),
                accountName: Text(
                  "Comrade Mentor",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Raleway",
                  ),
                ),
                decoration: BoxDecoration(color: Colors.white),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: user.photoURL == null
                      ? null
                      : NetworkImage(user.photoURL),
                  backgroundColor:
                      Theme.of(context).platform == TargetPlatform.android
                          ? Colors.black
                          : Colors.white,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                title: Text(
                  "Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Raleway",
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfilePage()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.payment,
                  color: Colors.white,
                ),
                title: Text(
                  "Earnings",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Raleway",
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Paymentshistory()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.call,
                  color: Colors.white,
                ),
                title: Text(
                  "Call History",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Raleway",
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Chathistory()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.chat,
                  color: Colors.white,
                ),
                title: Text(
                  "Chat History",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Raleway",
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Chathistory()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.money,
                  color: Colors.white,
                ),
                title: Text(
                  "Request Payment",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Raleway",
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Requestpayment()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.music_note,
                  color: Colors.white,
                ),
                title: Text(
                  "Podcasts",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Raleway",
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Podcastsection()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.support,
                  color: Colors.white,
                ),
                title: Text(
                  "Invite",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Raleway",
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Invitefriends()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.policy,
                  color: Colors.white,
                ),
                title: Text(
                  "Terms and Policies",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Raleway",
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Termsandpolicies()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.bug_report,
                  color: Colors.white,
                ),
                title: Text(
                  "Report a Bug",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Raleway",
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ReportBug()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Raleway",
                  ),
                ),
                onTap: () {
                  Navigator.pop(showAlertDialog(context));
                },
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: callMethods.msgStream(uid: user.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              print(snapshot.data.docs.length);
              return Container(
                child: SingleChildScrollView(
                  child: Column(
                      children: snapshot.data.docs
                          .map((e) => msgRequestWidget(e, user))
                          .toList()),
                ),
              );
            }
            return Container(
              child: SingleChildScrollView(
                child: Column(children: columnWidget),
              ),
            );
          }),
    );
  }

  showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max, showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'User Request',
      'A user is requested for chat session',
      platformChannelSpecifics,
    );
  }

  Widget msgRequestWidget(DocumentSnapshot doc, User user) {
    showNotification();
    return Card(
      margin: EdgeInsets.all(10),
      child: Container(
        width: double.maxFinite,
        height: 100,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              'A user has requested to chat you.',
              style: TextStyle(
                fontFamily: "Raleway",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange)),
                    onPressed: () async {
                      FirebaseFirestore.instance
                          .collection('msgRequest')
                          .doc(doc.id)
                          .set({'status': 'accepted', 'read': true},
                              SetOptions(merge: true)).then(
                        (value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Chat(
                              peerId: doc['from'],
                              id: doc['to'],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Accept',
                      style: TextStyle(
                        fontFamily: "Raleway",
                      ),
                    )),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                    onPressed: () async {
                      FirebaseFirestore.instance
                          .collection('msgRequest')
                          .doc(doc.id)
                          .set({'status': 'rejected', 'read': true},
                              SetOptions(merge: true)).then(
                        (value) async => await FirebaseFirestore.instance
                            .collection('msgRequest')
                            .doc(doc.id)
                            .delete(),
                      );
                      return Fluttertoast.showToast(msg: 'Request rejected');
                    },
                    child: Text(
                      'Reject',
                      style: TextStyle(
                        fontFamily: "Raleway",
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> columnWidget = [];
}
