import 'package:agent_word/alt_home.dart';
import 'package:agent_word/main.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(splash: SvgPicture.asset('assets/ikire_1.svg',
    // // scale: 2,
    // height: 500,
    // width: 500,
      ),

        nextScreen: MyHomePage());
  }
}
