import 'package:comrade/Dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class Invitefriends extends StatelessWidget {
  String text = 'https://www.comrade.com/';
  String subject = 'Join Comrade';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.orange,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard(user)));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Invite",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Center(
                  child: Container(
                    child: Text(
                      "Increase your earnings",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Center(
                  child: Container(
                    child: Text(
                      "Invite your friends and family members to Comrade and increase your earnings",
                      style: TextStyle(
                          fontSize: 18,
                          // fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 5,
              // ),
              Container(
                height: 300,
                child: Center(
                  child: Image.asset(
                    "assets/mentors.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // SizedBox(
              //   height: 5,
              // ),
              Padding(
                padding: EdgeInsets.only(),
                child: Center(
                  child: Container(
                    child: Text(
                      "Sent Invite",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 5,
              // ),
              Padding(
                padding: EdgeInsets.only(),
                // child: Center(
                child: Container(
                  height: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          elevation: 0.0,
                          color: Colors.white,
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(50))),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.message,
                                  color: Colors.black,
                                  size: 30.0,
                                ),
                                Text("TEXT")
                              ],
                            ),
                          ),
                          onPressed: _launchURL,
                        ),
                      ),
                      Expanded(
                        child: RaisedButton(
                          elevation: 0.0,
                          color: Colors.white,
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(50))),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.share,
                                  color: Colors.black,
                                  size: 30.0,
                                ),
                                Text("SHARE")
                              ],
                            ),
                          ),
                          onPressed: () {
                            final RenderBox box = context.findRenderObject();
                            Share.share(text,
                                subject: subject,
                                sharePositionOrigin:
                                    box.localToGlobal(Offset.zero) & box.size);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.only(),
                child: Center(
                  child: Text(
                    "OR COPY YOUR LINK",
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.only(),
                child: Card(
                  elevation: 0,
                  child: ListTile(
                    selectedTileColor: Colors.white,
                    tileColor: Colors.white,
                    title: Text(
                      'https://www.comrade.com/',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                      // textScaleFactor: 1.5,
                    ),
                    trailing: Text(
                      "COPY",
                      style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    onTap: () {
                      Clipboard.setData(new ClipboardData(text: text));
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text("Link Copied to Clipboard")));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_launchURL() async {
  const uri = 'sms:?body=Join Comrade\nhttps://www.comrade.com/';
  if (await canLaunch(uri)) {
    await launch(uri);
  } else {
    // iOS
    const uri = 'sms:?body=Join Comrade\nhttps://www.comrade.com/';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
}
