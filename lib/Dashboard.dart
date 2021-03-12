import 'package:comrade/Drawerpages/invite.dart';
import 'package:comrade/Drawerpages/podcastsection.dart';
import 'package:comrade/utils/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:comrade/Alert/logoutalert.dart';
import 'package:comrade/Drawerpages/profilepage.dart';
import 'package:comrade/Drawerpages/earninghistory.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';
import './utils/user_state_methods.dart';

import 'CallScreens/pickup/pickup_layout.dart';
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

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      UserStateMethods()
          .setUserState(widget.user.uid, "Online");
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
            ? UserStateMethods().setUserState(
            widget.user.uid,"Online")
            : print("Resumed State");
        break;
      case AppLifecycleState.inactive:
        widget.user != null
            ? UserStateMethods().setUserState(
            widget.user.uid, "Offline")
            : print("Inactive State");
        break;
      case AppLifecycleState.paused:
        widget.user != null
            ? UserStateMethods().setUserState(
            widget.user.uid, "Waiting")
            : print("Paused State");
        break;
      case AppLifecycleState.detached:
        widget.user != null
            ? UserStateMethods().setUserState(
            widget.user.uid, "Offline")
            : print("Detached State");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {



    return PickupLayout(
      uid: widget.user.uid,
      scaffold: dashboardPage(context, widget.user),
    );


  }

  Widget dashboardPage(BuildContext context, User user) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Comrade Mentor"),
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
                  style: TextStyle(color: Colors.black),
                ),
                accountName: Text(
                  "Comrade Mentor",
                  style: TextStyle(color: Colors.black),
                ),
                decoration: BoxDecoration(color: Colors.white),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: user.photoURL == null ? null :  NetworkImage(user.photoURL),
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
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.payment,
                  color: Colors.white,
                ),
                title: Text(
                  "Earnings",
                  style: TextStyle(color: Colors.white),
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
                  Icons.money,
                  color: Colors.white,
                ),
                title: Text(
                  "Requet Payment",
                  style: TextStyle(color: Colors.white),
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
                  style: TextStyle(color: Colors.white),
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
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Invitefriends()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.policy,
                  color: Colors.white,
                ),
                title: Text(
                  "Terms and Policies",
                  style: TextStyle(color: Colors.white),
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
                  Icons.logout,
                  color: Colors.white,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(showAlertDialog(context));
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(children: []),
        ),
      ),
    );
  }
}
