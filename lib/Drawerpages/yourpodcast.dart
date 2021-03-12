import 'package:audio_service/audio_service.dart';
import 'package:comrade/audio_service/BGAudioPlayerScreen.dart';
import 'package:comrade/services/db_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YourPodcast extends StatefulWidget {
  @override
  _YourPodcastState createState() => _YourPodcastState();
}

class _YourPodcastState extends State<YourPodcast> {
  DbServices db = DbServices();
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Your Podcast'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: db.getSnapshotWithQuery("podcasts", 'uid', [user.uid]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List podcasts = snapshot.data;
            return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                itemCount: podcasts.length,
                itemBuilder: (context, index) {
                  return podcastTile(podcasts[index], context);
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

  Widget podcastTile(dynamic podcast, context) {
    print(podcast);
    return Card(
      color: Colors.white70,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BGAudioPlayerScreen(
              MediaItem(id: podcast['podcast'],
                album: podcast['name'],
                title: podcast['description'],
                artist: podcast['email'],
                artUri: podcast['thumbnail'],
                duration: Duration(seconds: podcast['duration'].toInt()),)
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.album, size: 50, color: Colors.black),
              title: Text(podcast['name']),
              subtitle: Text(podcast['description']),
            ),
          ],
        ),
      ),
    );
  }
}
