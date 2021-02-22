import 'package:comrade/Drawerpages/podcastsection.dart';
import 'package:flutter/material.dart';

class Recordpodcasts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.orange,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Podcastsection()));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Record Podcast",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
