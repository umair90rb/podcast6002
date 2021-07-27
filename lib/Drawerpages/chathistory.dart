import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comrade/services/db_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:comrade/Dashboard.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

class Chathistory extends StatelessWidget {
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
          "Chating Session History",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Raleway",
          ),
        ),
      ),
      body: FutureBuilder(
        future: db.getSnapshotWithTripleQuery("msgRequest", 'to', [user.uid], 'read', [true], 'status', ['accepted']),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List chats = snapshot.data;
            if (chats.isEmpty)
              return Center(
                child: Text("No chat history"),
              );
            return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  return chatTile(chats[index], context);
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

Widget chatTile(DocumentSnapshot chat, context) {
  var at = "Not Available";
  if (chat.data().containsKey('at')) {
    var date = chat['at'].toDate();
    at = DateFormat('MM/dd, hh:mm a').format(date);
  }
  return Card(
    color: Colors.orange,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.white70, width: 1),
      borderRadius: BorderRadius.circular(10),
    ),
    child: ListTile(
      title: Text(
        "Chat Session",
        style: TextStyle(fontFamily: "Raleway", color: Colors.white),
      ),
      subtitle: Text(
        "Session Status: ${chat['status']}",
        style: TextStyle(fontFamily: "Raleway", color: Colors.white),
      ),
      trailing: Text(
        "$at",
        style: TextStyle(fontFamily: "Raleway", color: Colors.white),
      ),
    ),
  );
}
