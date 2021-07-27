import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comrade/services/db_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:comrade/Dashboard.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

class Callhistory extends StatelessWidget {
  DbServices db = DbServices();

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
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
          "Call Session's History",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Raleway",
          ),
        ),
      ),
      body: FutureBuilder(
        future: db.getSnapshotWithDualQuery("call", 'pid', [user.uid], 'status', ['ended', 'attended']),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List calls = snapshot.data;
            return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                itemCount: calls.length,
                itemBuilder: (context, index) {
                  return earningTile(calls[index], context);
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

Widget earningTile(DocumentSnapshot call, context) {
  var at = "Not Available";
  if (call.data().containsKey('at')) {
    var date = call['at'].toDate();
    at = DateFormat('MM/dd, hh:mm a').format(date);
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
            "User Email: ${call['email']}",
            style: TextStyle(fontFamily: "Raleway", color: Colors.white),
          ),
          trailing: Text(
            "$at",
            style: TextStyle(fontFamily: "Raleway", color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
