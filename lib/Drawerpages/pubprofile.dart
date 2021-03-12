import 'package:flutter/material.dart';
import 'package:comrade/Tabbarscreens/mentorreviews.dart';
import 'package:comrade/Tabbarscreens/mentorprofile.dart';

class Pubprofile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: TabBar(
              labelColor: Colors.orange,
              labelPadding: EdgeInsets.only(top: 10),
              tabs: [
                Tab(
                  text: "Mentor Profile",
                ),
                Tab(text: "Reviews")
              ],
              indicatorColor: Colors.white,
            ),
            body: TabBarView(
              children: [
                Mentorprofile(),
                Mentorreviews(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
