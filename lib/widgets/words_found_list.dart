import 'package:agent_word/utils.dart';
import 'package:flutter/material.dart';

class WordsFoundList extends StatelessWidget {
  final List<Map<String, Object?>>? wordsFound;

  WordsFoundList({required this.wordsFound});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            visualDensity: VisualDensity(vertical: -4),
            dense: true,
            contentPadding: const EdgeInsets.only(
              left: 41,
            ),
            title: Text(
              capitalize(wordsFound![index]['word'] as String),
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w300, height: 1.5),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: wordsFound?.length ?? 0);
  }
}
