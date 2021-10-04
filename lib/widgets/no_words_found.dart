import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

class NoWordsFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 108,
          width: 97,
          margin: EdgeInsets.only(left: 126, right: 126, top: 151),
          child: SvgPicture.asset(
            'assets/images/notes.svg',
            width: 108,
            height: 97,
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: 10, left: 64, right: 64),
            child: Text(
              "No word matches your request!",
              style: TextStyle(
                  color: HexColor('#E50404'),
                  fontWeight: FontWeight.w200,
                  fontSize: 14,
                  height: 1.5),
            ))
      ],
    );
  }
}
