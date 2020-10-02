import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AltHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 265,
              child: Text(
                'Find words that start and end with letters of your choice.',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
            ),
            SvgPicture.asset(
              'assets/ikire_read.svg',
              width: 172,
              height: 152,
            ),
            Text("Length of Word (Optional)"),
            TextField(),
            Text('Word Starts With :'),
            TextField(),
            Text('Word Ends With :'),
            RaisedButton(
              color: Color(0Xff4343EA),
              onPressed: () {},
              child: Text(
                "Search",
                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
          ],
        ),
      )
    );
  }
}
