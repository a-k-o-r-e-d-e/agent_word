import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../utils.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 57,
            width: 57,
            margin: EdgeInsets.only(left: 150, right: 150, top: 230),
            child: LoadingIndicator(
              indicatorType: Indicator.ballPulse,
              pathBackgroundColor: Colors.grey,
              colors: [ikireBlueBalls],
            )),
        Container(
            margin: EdgeInsets.only(top: 10, left: 79, right: 79),
            child: Text(
              "AgentWord is fetching words",
              style: TextStyle(
                  color: ikireBlueLight,
                  fontWeight: FontWeight.w200,
                  fontSize: 14,
                  height: 1.5),
            ))
      ],
    );
  }
}
