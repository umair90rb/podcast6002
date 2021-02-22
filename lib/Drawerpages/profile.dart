import 'package:comrade/Dashboard.dart';
import 'package:comrade/Drawerpages/profilepage.dart';
import 'package:flutter/material.dart';
import 'changepass.dart';
import 'editprofile.dart';

class Myaccount extends StatefulWidget {
  @override
  _MyaccountState createState() => _MyaccountState();
}

class _MyaccountState extends State<Myaccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: Center(
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 20,
              ),
              child: Text(
                "Name Here",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 40, left: 40, right: 40),
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage:
                    NetworkImage('https://via.placeholder.com/150'),
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.circle,
                    color: Colors.green,
                  ),
                  Text(
                    "Online - Active",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(),
              child: Card(
                elevation: 0,
                child: ListTile(
                  selectedTileColor: Colors.white,
                  tileColor: Colors.white,
                  leading: Container(
                    height: 45,
                    width: 45,
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.lock,
                        color: Colors.grey,
                        size: 30,
                      ),
                    ),
                  ),
                  title: Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    // textScaleFactor: 1.5,
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Changepass()));
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(),
              child: Card(
                elevation: 0,
                child: ListTile(
                  selectedTileColor: Colors.white,
                  tileColor: Colors.white,
                  leading: Container(
                    height: 45,
                    width: 45,
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.person,
                        color: Colors.grey,
                        size: 30,
                      ),
                    ),
                  ),
                  title: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    // textScaleFactor: 1.5,
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Editprofile()));
                  },
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
          ]),
        ),
      ),
    );
  }
}
