import 'package:agent_word/utils.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class WordsFoundPage extends StatelessWidget {
  final List<Map<String, dynamic>> wordsFound;

  WordsFoundPage({this.wordsFound});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Hexcolor('#E5E5E5'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  margin: EdgeInsets.only(left: 31, top: 30),
                  child: CircleAvatar(
                    backgroundColor: Hexcolor('#F6FAF9'),
                    radius: 19,
                    child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: ikireBlueBalls,
                        onPressed: () => Navigator.of(context).pop()),
                  )),
              Container(
                margin: EdgeInsets.only(left: 62, top: 32),
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
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 41),
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
