import 'dart:io';
import 'dart:typed_data';

import 'package:agent_word/splash_screen.dart';
import 'package:agent_word/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:string_validator/string_validator.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agent Word',
      theme: ThemeData(
        primaryColor: Colors.white,
        backgroundColor: Hexcolor('#E5E5E5'),
        accentColor: ikireBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: MySplashScreen(),
    );
  }
}
