import 'package:comrade/Dashboard.dart';
import 'package:comrade/login.dart';
import 'package:comrade/main.dart';
import 'package:comrade/services/auth.dart';
import 'package:comrade/services/db_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../confirm_email.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  DbServices db = DbServices();
  AuthServices auth = AuthServices();
  int _currentPage = 0;
  PageController _controller = PageController();

  List<Widget> _pages = [
    SliderPage(
        title: "One chat at a time",
        description: "Understand your thoughts\nand feelings.",
        image: "assets/images/illu.jpg"),
    SliderPage(
        title: "One chat at a time",
        description: "Understand your thoughts\nand feelings.",
        image: "assets/images/illu.jpg"),
    SliderPage(
        title: "One chat at a time",
        description: "Understand your thoughts\nand feelings.",
        image: "assets/images/illu.jpg"),
  ];

  _onchanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            PageView.builder(
              scrollDirection: Axis.horizontal,
              onPageChanged: _onchanged,
              controller: _controller,
              itemCount: _pages.length,
              itemBuilder: (context, int index) {
                return _pages[index];
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
//                children: List<Widget>.generate(
//                  _pages.length,
//                  (int index) {
//                    return AnimatedContainer(
//                      duration: Duration(milliseconds: 300),
//                      height: 10,
//                      width: (index == _currentPage) ? 30 : 10,
//                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 30),
//                      decoration: BoxDecoration(
//                        borderRadius: BorderRadius.circular(5),
//                        color: (index == _currentPage)
//                            ? Colors.blue
//                            : Colors.blue.withOpacity(0.5),
//                      ),
//                    );
//                  },
//                ),
                ),
                InkWell(
                  onTap: () {
                    _controller.nextPage(
                        duration: Duration(milliseconds: 800),
                        curve: Curves.easeInOutQuint);
                  },
                  child: AnimatedContainer(
                    alignment: Alignment.center,
                    duration: Duration(milliseconds: 100),
                    height: 70,
                    width: (_currentPage == (_pages.length - 1)) ? 200 : 75,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(50, 219, 208, 1),
                        borderRadius: BorderRadius.circular(35)),
                    child: (_currentPage == (_pages.length - 1))
                        ? InkWell(
                            onTap: () {
                              User user = auth.getUser;
                              print(user);
                              if (user != null) {
                                user.emailVerified
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Dashboard(auth.getUser),
                                        ))
                                    : Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ConfirmEmail()));
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                );
                              }
                            },
                            child: Text(
                              "GET STARTED",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "Raleway",
                              ),
                            ),
                          )
                        : Icon(
                            Icons.navigate_next,
                            size: 50,
                            color: Colors.white,
                          ),
                  ),
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

///

class SliderPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  SliderPage({this.title, this.description, this.image});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 5, top: 30),
              child: Text(
                description,
                style: TextStyle(
//              height: 2,
                  fontWeight: FontWeight.normal,
                  fontSize: 28,
                  letterSpacing: 0.7,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        scrollDirection: Axis.horizontal,
        controller: _controller,
        children: [
          MyPage1Widget(),
          MyPage2Widget(),
          MyPage3Widget(),
        ],
      ),
    );
  }
}

class MyPage1Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10, right: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Understand your thoughts\nand feelings.",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 27,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "One chat at a time.",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Container(
                      child: Image.asset(
                        "assets/images/6578.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 140, vertical: 20),
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyPage2Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10, right: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Understand your thoughts\nand feelings.",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 27,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "One chat at a time.",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Container(
                      child: Image.asset(
                        "assets/images/6578.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 140, vertical: 20),
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyPage3Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10, right: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Understand your thoughts\nand feelings.",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 27,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "One chat at a time.",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Container(
                      child: Image.asset(
                        "assets/images/6578.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 140, vertical: 20),
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
