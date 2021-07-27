import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comrade/services/db_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Mentoringhistory extends StatelessWidget {
  DbServices db = DbServices();
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    dynamic size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.orange,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Mentoring History",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Raleway",
          ),
        ),
      ),
      body: FutureBuilder<dynamic>(
          future: db.getSnapshotWithQuery('call', 'pid', [user.uid]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              List<QueryDocumentSnapshot> docs = snapshot.data;
              if (docs.isEmpty) {
                return Center(
                  child: Text(
                    "You don't have any mentorings done",
                    style: TextStyle(fontSize: 20),
                  ),
                );
              } else {
                print(docs);
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.5,
                        child: ListView.builder(
                            itemCount: docs.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Icon(
                                  Icons.call,
                                ),
                                title: Text(
                                  'User Email: ${docs[index]['email']}',
                                  style: TextStyle(
                                    fontFamily: "Raleway",
                                  ),
                                ),
                              );
                            }),
                      ),
                      Divider(),
                      FutureBuilder<dynamic>(
                          future: db.getSnapshotWithQuery(
                              'msgRequest', 'to', [user.uid]),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<QueryDocumentSnapshot> docs = snapshot.data;
                              if (docs.isEmpty) {
                                return Center(
                                  child: Text(
                                    "You don't have any chat mentoring done",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Raleway",
                                    ),
                                  ),
                                );
                              } else {
                                print(docs);
                                return SizedBox(
                                  height: size.height * 0.5,
                                  child: ListView.builder(
                                      itemCount: docs.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          leading: Icon(
                                            Icons.message,
                                          ),
                                          title: Text('Status: ${docs[index]['status']}'),
                                        );
                                      }),
                                );
                              }
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  "Something goes wrong!",
                                  style: TextStyle(fontSize: 20),
                                ),
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }),
                    ],
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Something goes wrong!",
                  style: TextStyle(fontSize: 20),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  bool isKey(DocumentSnapshot doc, String key) {
    return doc.data().containsKey('email');
  }
}
