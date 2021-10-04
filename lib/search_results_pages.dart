import 'package:agent_word/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class WordsFoundPage extends StatelessWidget {
  final List<Map<String, dynamic>> wordsFound;

  WordsFoundPage({this.wordsFound});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: HexColor('#E5E5E5'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  margin: EdgeInsets.only(left: 31, top: 40),
                  child: CircleAvatar(
                    backgroundColor: HexColor('#F6FAF9'),
                    radius: 19,
                    child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: ikireBlueBalls,
                        onPressed: () => Navigator.of(context).pop()),
                  )),
              Container(
                margin: EdgeInsets.only(left: 62, top: 42),
                child: Text(
                  "Words Found",
                  style: TextStyle(
                    color: ikireBlueBalls,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    visualDensity: VisualDensity(vertical: -4),
                    dense: true,
                    contentPadding: const EdgeInsets.only(left: 41,),
                    title: Text(
                      capitalize(wordsFound[index]['word']),
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          height: 1.5),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: wordsFound.length),
          )
        ],
      ),
    );
  }
}

class NoWordsFoundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(left: 31, top: 40),
              child: CircleAvatar(
                backgroundColor: HexColor('#F6FAF9'),
                child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: ikireBlueBalls,
                    onPressed: () => Navigator.pop(context)),
              )),
          Container(
            height: 108,
            width: 97,
            margin: EdgeInsets.only(left: 126, right: 126, top: 151),
            child:
            SvgPicture.asset(
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
      ),
    );
  }
}

