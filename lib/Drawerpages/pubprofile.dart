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
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              bottom: TabBar(
                unselectedLabelColor: Colors.black,
                labelColor: Colors.white,
                labelStyle: TextStyle(fontFamily: "Raleway"),
                onTap: (index) {},
                tabs: [
                  Tab(
                    text: "Mentor Profile",
                  ),
                  Tab(text: "Reviews")
                ],
                indicatorColor: Colors.white,
              ),
              title: Text('Review Profile'),
              backgroundColor: Colors.orange,
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
