import 'package:comrade/Dashboard.dart';
import 'package:comrade/Splash_screen/splash/items/item_splash_pageview.dart';
import 'package:comrade/login.dart';
import 'package:comrade/main.dart';
import 'package:comrade/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../confirm_email.dart';
import '../style.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AuthServices auth = AuthServices();
  int _currentPage = 0;
  PageController _controller = PageController();
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
              ),
              Column(
                children: [
                  Expanded(
                    flex: 70,
                    child: PageView(
                      onPageChanged: (pageIndex) {
                        setState(() {
                          currentPageIndex = pageIndex;
                          print('current page index $currentPageIndex');
                        });
                      },
                      children: [
                        ItemSplashPageView(
                          title: 'Become a part of growing community',
                          description:
                              "Join us to contribute towards each other's success and happiness. Together we all can make this world a better place.",
                          img_path: 'assets/Screen01.png',
                        ),
                        ItemSplashPageView(
                          title: 'Earn on your own',
                          description:
                              "We are all in for flexibility. We ensure you empower others only when you want to. Pick your own schedule and language.",
                          img_path: 'assets/Screen02.png',
                        ),
                        ItemSplashPageView(
                          title: 'Motivate those in need',
                          description:
                              "Help others become their best in everything that they do. Help them make better decisions.",
                          img_path: 'assets/Screen03.png',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 7,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: FractionallySizedBox(
                          heightFactor: 0.15,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 33,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 4),
                                  child: AspectRatio(
                                    aspectRatio:
                                        currentPageIndex != 0 ? 1 / 1 : 3 / 1,
                                    child: Card(
                                      elevation: 0,
                                      clipBehavior: Clip.antiAlias,
                                      margin: EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: currentPageIndex != 0
                                                  ? [
                                                      AppTheme
                                                          .gradient1_disabled,
                                                      AppTheme
                                                          .gradient2_disabled,
                                                    ]
                                                  : [
                                                      AppTheme.gradient1,
                                                      AppTheme.gradient2,
                                                    ]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 33,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 4),
                                  child: AspectRatio(
                                    aspectRatio:
                                        currentPageIndex != 1 ? 1 / 1 : 3 / 1,
                                    child: Card(
                                      elevation: 0,
                                      clipBehavior: Clip.antiAlias,
                                      margin: EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: currentPageIndex != 1
                                                  ? [
                                                      AppTheme
                                                          .gradient1_disabled,
                                                      AppTheme
                                                          .gradient2_disabled,
                                                    ]
                                                  : [
                                                      AppTheme.gradient1,
                                                      AppTheme.gradient2,
                                                    ]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 33,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 4),
                                  child: AspectRatio(
                                    aspectRatio:
                                        currentPageIndex != 2 ? 1 / 1 : 3 / 1,
                                    child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      elevation: 0,
                                      margin: EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: currentPageIndex != 2
                                                  ? [
                                                      AppTheme
                                                          .gradient1_disabled,
                                                      AppTheme
                                                          .gradient2_disabled,
                                                    ]
                                                  : [
                                                      AppTheme.gradient1,
                                                      AppTheme.gradient2,
                                                    ]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  Expanded(
                    flex: 5,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 15,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 50,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: FractionallySizedBox(
                                widthFactor: 0.9,
                                heightFactor: 1,
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 0,
                                  shadowColor: AppTheme.gradient2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 360.0,
                                        height: double.infinity,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                AppTheme.gradient1,
                                                AppTheme.gradient2,
                                              ]),
                                        ),
                                        child: Text(
                                          'Get Started',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontFamily: "Raleway",
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              User user = auth.getUser;
                                              print(user);
                                              if (user != null) {
                                                user.emailVerified
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Dashboard(auth
                                                                    .getUser)))
                                                    : Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ConfirmEmail()));
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage()),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 50,
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: SizedBox(
                                width: 360.0,
                                height: 20.0,
                                child: RaisedButton(
                                  splashColor: Colors.orange,
                                  color: Colors.transparent,
                                  // color: Colors.orange,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(06.0),
                                      side:
                                          BorderSide(color: Color(0xFFFF9800))),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()));
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 18,
                                        fontFamily: "Raleway"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
