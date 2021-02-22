import 'package:comrade/Drawerpages/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:comrade/Dashboard.dart';

class Reviews extends StatelessWidget {
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
                MaterialPageRoute(builder: (context) => ProfilePage()));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Reviews",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Center(
          child: Text(
            "You don't have any mentoring done",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
