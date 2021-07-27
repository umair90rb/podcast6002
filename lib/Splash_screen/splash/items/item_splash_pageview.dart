import 'package:flutter/material.dart';

class ItemSplashPageView extends StatelessWidget {
  const ItemSplashPageView({
    Key key,
    @required this.title,
    @required this.description,
    @required this.img_path,
  }) : super(key: key);

  final String title;
  final String description;
  final String img_path;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 0.9,
        child: Column(
          children: [
            Expanded(
              flex: 75,
              child: Container(
                margin: EdgeInsets.only(bottom: 32),
                child: Image.asset(
                  img_path,
                  scale: 8,
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 32),
                child: Text(title.toUpperCase(),
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Raleway",
                      fontSize: 16,
                    )),
              ),
            ),
            Expanded(
              flex: 30,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 32),
                child: Text(
                  description,
                  style: TextStyle(
                      color: Colors.black, fontSize: 16, fontFamily: "Raleway"),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
