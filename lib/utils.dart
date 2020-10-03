import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

Color ikireBlue = Hexcolor('#4343EA');
Color ikireBlueLight = Hexcolor('#000085');
Color ikireBlueBalls = Hexcolor('#1414B8');
Color ikireOrange = Hexcolor('#FF6666');

String capitalize(String string) {
  if (string == null) {
    throw ArgumentError("string: $string");
  }

  if (string.isEmpty) {
    return string;
  }

  return string[0].toUpperCase() + string.substring(1);
}
