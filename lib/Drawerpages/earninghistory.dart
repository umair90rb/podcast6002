import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comrade/services/db_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:comrade/Dashboard.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

class Paymentshistory extends StatelessWidget {
  DbServices db = DbServices();

  Future getSession(user) async {
    List<DocumentSnapshot> docs = [];
    List<DocumentSnapshot> msgs = await db.getSnapshotWithTripleQuery("msgRequest", 'to', [user.uid], 'read', [true], 'status', ['accepted']);
    List<DocumentSnapshot> calls = await db.getSnapshotWithDualQuery("call", 'pid', [user.uid], 'status', ['ended', 'attended']);
    docs.addAll(msgs);
    docs.addAll(calls);
    return docs;
  }
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    DocumentSnapshot profile = Provider.of<DocumentSnapshot>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.orange,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Dashboard(user)));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Earnings History",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Raleway",
          ),
        ),
      ),
      body: FutureBuilder(
        future: getSession(user),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> earnings = snapshot.data;
            if (earnings.isEmpty)
              return Center(
                child: Text("No Earnings!"),
              );
            return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                itemCount: earnings.length,
                itemBuilder: (context, index) {
                  return earningTile(earnings[index], context, profile);
                });
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "${snapshot.error}",
                style: TextStyle(
                  fontFamily: "Raleway",
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

Widget earningTile(DocumentSnapshot call, context, DocumentSnapshot profile) {
  String type = call.data().containsKey('read') ? "Chat" : "Call";
  String user = call.data().containsKey('email') ? call['email'] : "Null";

  var at = "Null";
  if (call.data().containsKey('at')) {
    var date = call['at'].toDate();
    at = DateFormat('MM/dd, hh:mm a').format(date);
  }

  int amount = 20;
  switch (profile['experties']) {
    case "Relationship":
      amount = 20;
      break;
    case "Travel":
      amount = 20;
      break;
    case "Beauty":
      amount = 20;
      break;
    case "Emotional":
      amount = 20;
      break;
    default:
      amount = 40;
      break;
  }

  return Card(
    color: Colors.orange,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.white70, width: 1),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: Text(
            "$type Session($at)",
            style: TextStyle(fontFamily: "Raleway", color: Colors.white),
          ),
          trailing: Text(
            "\$$amount",
            style: TextStyle(fontFamily: "Raleway", color: Colors.white),
          ),
          subtitle: Text(
            "$user",
            style: TextStyle(fontFamily: "Raleway", color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
