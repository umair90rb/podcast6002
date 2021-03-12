import 'package:comrade/CallScreens/pickup/pickup_layout.dart';
import 'package:comrade/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'CallScreens/pickup/pickup_screen.dart';
import 'animation/FadeAnimation.dart';
import 'login.dart';
import 'models/call.dart';
import 'signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: AuthServices().user),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Comrade",
        // home: PickupScreen(
        //   call: Call(
        //     callerId: "XWv6KdOWlSVBUyLeg4DOQoN4xdH2",
        //     callerName: "Umair",
        //     callerPic: "",
        //     receiverId: "XWv6KdOWlSVBUyLeg4DOQoN4xdH2",
        //     hasDialled: false,
        //     receiverName: "Qais",
        //     receiverPic: "",
        //     channelId: "219"
        //   ),
        // ),
        home: HomePage(),
      ),
    );
  }
}



class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return homePageScreen(context);
  }

  Widget homePageScreen(context){
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeAnimation(
                      1,
                      Text(
                        "Welcome",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  FadeAnimation(
                      1.2,
                      Text(
                        "Welcome to Comrade. This is our app for our honorable mentors. Get connect with us and start earning.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700], fontSize: 15),
                      )),
                ],
              ),
              FadeAnimation(
                  1.4,
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/Illustration.png'))),
                  )),
              Column(
                children: <Widget>[
                  FadeAnimation(
                      1.5,
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(50)),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  FadeAnimation(
                      1.6,
                      Container(
                        padding: EdgeInsets.only(),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border(
                              bottom: BorderSide(color: Colors.black),
                              top: BorderSide(color: Colors.black),
                              left: BorderSide(color: Colors.black),
                              right: BorderSide(color: Colors.black),
                            )),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupPage()));
                          },
                          color: Colors.orange,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
