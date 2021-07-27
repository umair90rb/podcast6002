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
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
        title: Text(
          'Your Podcasts',
          style: TextStyle(
            fontFamily: "Raleway",
          ),
        ),
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

  Widget podcastTile(dynamic podcast, context) {
    print(podcast);
    return Card(
      color: Colors.orange,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BGAudioPlayerScreen(MediaItem(
              id: podcast['podcast'],
              album: '',
              title: podcast['name'],
              artist: podcast['description'],
              artUri: podcast['thumbnail'],
              duration: Duration(seconds: podcast['duration'].toInt()),
            )),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(podcast['thumbnail']),
                backgroundColor: Colors.transparent,
              ),
              title: Text(
                podcast['name'],
                style: TextStyle(fontFamily: "Raleway", color: Colors.white),
              ),
              subtitle: Text(
                podcast['description'],
                style: TextStyle(fontFamily: "Raleway", color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
