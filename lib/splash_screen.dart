import 'package:agent_word/alt_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:your_splash/your_splash.dart';

class MySplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen.timed(
        seconds: 3,
        route: MaterialPageRoute(builder: (_) => AltHomePage()),
        body: _buildSplashScreen());
  }

  _buildSplashScreen() {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              height: 184,
              margin: const EdgeInsets.only(top: 125, left: 73, right: 73),
              child: Image.asset('assets/images/splash_screen_image.png')),
          Container(
            margin: EdgeInsets.only(top: 15, left: 77),
            child: Text(
              "AGENTWORD",
              style: TextStyle(
                  color: Hexcolor('#2222C3'),
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  height: 1.5),
            ),
          )
        ],
      ),
    );
  }
}


