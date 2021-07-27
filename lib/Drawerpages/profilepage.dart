import 'package:comrade/Drawerpages/mentoringhistory.dart';
import 'package:comrade/Drawerpages/profile.dart';
import 'package:comrade/Drawerpages/reviews.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:comrade/Dashboard.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
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
          "Profile",
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
                          'My Profile',
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
                                  builder: (context) => Myaccount()));
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
                          'Mentoring History',
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
                                  builder: (context) => Mentoringhistory()));
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(),
                  //   child: Card(
                  //     elevation: 1,
                  //     child: ListTile(
                  //       selectedTileColor: Colors.white,
                  //       tileColor: Colors.white,
                  //       title: Text(
                  //         'Reviews',
                  //         style: TextStyle(
                  //           fontSize: 18,
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.black54,
                  //         ),
                  //         // textScaleFactor: 1.5,
                  //       ),
                  //       onTap: () {
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => Reviews()));
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
