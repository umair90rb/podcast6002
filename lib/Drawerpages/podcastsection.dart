import 'package:comrade/Drawerpages/uploadpodcasts.dart';
import 'package:comrade/Drawerpages/yourpodcast.dart';
import 'package:comrade/recorder/test_recorder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'undpodcasts.dart';
import '../Dashboard.dart';

class Podcastsection extends StatelessWidget {
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
          "Podcasts",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Raleway",
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(),
                    child: Card(
                      elevation: 1,
                      child: ListTile(
                        selectedTileColor: Colors.white,
                        tileColor: Colors.white,
                        title: Text(
                          'Record Podcast',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Raleway",
                            color: Colors.black54,
                          ),
                          // textScaleFactor: 1.5,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TestRecorder()));
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: EdgeInsets.only(),
                    child: Card(
                      elevation: 1,
                      child: ListTile(
                        selectedTileColor: Colors.white,
                        tileColor: Colors.white,
                        title: Text(
                          'Update or Delete Podcast',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            fontFamily: "Raleway",
                          ),
                          // textScaleFactor: 1.5,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Updatendeletepodcasts()));
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: EdgeInsets.only(),
                    child: Card(
                      elevation: 1,
                      child: ListTile(
                        selectedTileColor: Colors.white,
                        tileColor: Colors.white,
                        title: Text(
                          'Upload Podcast From Gallery',
                          style: TextStyle(
                            fontFamily: "Raleway",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                          // textScaleFactor: 1.5,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UploadPodcasts()));
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: EdgeInsets.only(),
                    child: Card(
                      elevation: 1,
                      child: ListTile(
                        selectedTileColor: Colors.white,
                        tileColor: Colors.white,
                        title: Text(
                          'Your Podcast',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                          // textScaleFactor: 1.5,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => YourPodcast()));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class Undpodcasts {}
