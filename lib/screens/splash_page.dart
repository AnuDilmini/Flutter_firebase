import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_interview/screens/home_page.dart';

class SplashPage extends StatefulWidget {
  static const routeName = '/splash-page';

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool result = true;
  @override
  void initState() {
    checkJustInstall();
    super.initState();
  }

  checkJustInstall() async {
    Timer(Duration(seconds: 1), () {
      Navigator.pushNamedAndRemoveUntil(
          context, HomePage.routeName, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(fit: StackFit.expand, alignment: Alignment.center, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.star,
              size: 50,
              color: Colors.cyan,
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              "Welcome",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ]),
    );
  }
}
