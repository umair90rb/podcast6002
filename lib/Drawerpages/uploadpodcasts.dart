import 'package:comrade/Drawerpages/podcastsection.dart';
import 'package:flutter/material.dart';
import 'package:nice_button/NiceButton.dart';

class UploadPodcasts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
          "Upload Podcast",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 40, left: 40, right: 40),
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: 50,
                    left: 80,
                    right: 80,
                  ),
                  height: 200,
                  width: double.maxFinite,
                  child: Card(
                    elevation: 0,
                    color: Colors.grey[350],
                    child: Image.asset("assets/camera1.png"),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 5,
              // ),
              Padding(
                padding: EdgeInsets.only(
                  right: 190,
                ),
                child: Text("Name of the podcast "),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, left: 40, right: 40),
                child: TextFormField(
                  cursorWidth: 1.5,
                  cursorColor: Colors.orange,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(16),
                    filled: false,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: new TextStyle(
                      fontFamily: "Poppins", fontSize: 16, color: Colors.white),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 160,
                ),
                child: Text("Description of the Podcast"),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, left: 40, right: 40),
                child: TextFormField(
                  cursorWidth: 1.5,
                  cursorColor: Colors.orange,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(70),
                    filled: false,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: new TextStyle(
                      fontFamily: "Poppins", fontSize: 16, color: Colors.white),
                ),
              ),
              SizedBox(height: 30),
              NiceButton(
                width: size.width * 0.85,
                radius: 10,
                padding: const EdgeInsets.all(20),
                text: "Upload",
                fontSize: 20,
                textColor: Colors.white,
                gradientColors: [Colors.orange, Colors.orange],
                onPressed: () {},
                background: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
