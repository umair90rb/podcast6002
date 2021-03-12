import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comrade/services/db_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:comrade/Dashboard.dart';
import 'package:provider/provider.dart';

class Paymentshistory extends StatelessWidget {
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard(user)));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Earnings History",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future: db.getSnapshotWithQuery("transaction", 'to', [user.uid]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List earnings = snapshot.data;
            return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                itemCount: earnings.length,
                itemBuilder: (context, index) {
                  return earningTile(earnings[index], context);
                });
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
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



Widget earningTile(DocumentSnapshot earning, context) {
  Timestamp at = earning['at'];

  print(earning);
  return Card(
    color: Colors.white70,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: Text("${at.toDate().year}/${at.toDate().month}/${at.toDate().day} ${at.toDate().hour}:${at.toDate().minute}"),
          trailing: Text("\$${earning['amount']}"),
        ),
      ],
    ),
  );
}

