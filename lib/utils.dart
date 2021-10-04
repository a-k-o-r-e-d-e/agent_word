import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

Color ikireBlue = HexColor('#4343EA');
Color ikireBlueLight = HexColor('#000085');
Color ikireBlueBalls = HexColor('#1414B8');
Color ikireOrange = HexColor('#FF6666');

String capitalize(String string) {
  if (string == null) {
    throw ArgumentError("string: $string");
  }

  if (string.isEmpty) {
    return string;
  }

  return string[0].toUpperCase() + string.substring(1);
}
