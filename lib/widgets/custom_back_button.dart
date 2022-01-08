import 'package:flutter/material.dart';

import '../utils.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 25),
      alignment: Alignment.center,
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF6FAF9)),
      child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(Icons.arrow_back),
          color: ikireBlueBalls,
          onPressed: () => Navigator.pop(context)),
    );
  }
}
