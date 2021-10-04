import 'package:agent_word/widgets/custom_back_button.dart';
import 'package:agent_word/widgets/loading_widget.dart';
import 'package:agent_word/widgets/no_words_found.dart';
import 'package:agent_word/widgets/words_found_list.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../utils.dart';

class SearchResultScreen extends StatelessWidget {
  final Database database;
  final String queryString;

  SearchResultScreen({@required this.database, @required this.queryString});

  @override
  Widget build(BuildContext context) {
    return _buildLoadingScreen(context);
  }

  _buildLoadingScreen(BuildContext context) {
    return FutureBuilder<List<Map<String, Object>>>(
        future: _searchDB(queryString),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: CustomBackButton(),
              title: Text(
                snapshot.hasData && snapshot.data.isNotEmpty
                    ? "Words Found"
                    : '',
                style: TextStyle(
                  color: ikireBlueBalls,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              centerTitle: true,
            ),
            body: Builder(builder: (_) {
              if (snapshot.hasData) {
                if (snapshot.data.isNotEmpty) {
                  return WordsFoundList(wordsFound: snapshot.data);
                }
                return NoWordsFound();
              }
              // Loading Widget Displays till future completes
              return LoadingWidget();
            }),
          );
        });
  }

  Future<List<Map<String, Object>>> _searchDB(String queryString) async {
    return database.rawQuery(queryString);
  }
}
