import 'dart:io';
import 'dart:typed_data';

import 'package:agent_word/search_results_pages.dart';
import 'package:agent_word/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:string_validator/string_validator.dart';

class AltHomePage extends StatefulWidget {
  @override
  _AltHomePageState createState() => _AltHomePageState();
}

class _AltHomePageState extends State<AltHomePage> {
  String dbName = 'agent_word.db';

  String dbPath;

  String tableName = 'words_alpha';

  Database database;

  bool isWordStartError = false;

  bool isWordEndError = false;
  bool _loading = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _wordStartTxtController = TextEditingController();

  final TextEditingController _wordEndTxtController = TextEditingController();

  final TextEditingController _wordCountTxtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setUpDB();
  }

  _setUpDB() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    dbPath = join(databasesPath, dbName);

    var exists = await databaseExists(dbPath);

    if (!exists) {
      // Should only happen the first time you create your application
      print("Creating a new database copy from assets");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(dbPath)).create(recursive: true);
      } catch (_) {}

      // copy from asset
      ByteData data = await rootBundle.load(join("assets", "agent_word.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(dbPath).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }

    // var db = await openDatabase(dbName);
    // String sqlCreate = "CREATE TABLE $tableName (id INTEGER PRIMARY KEY, word TEXT, length INTEGER)";

    // open the database
    database = await openDatabase(dbPath, readOnly: true);

    print(database);

    // database.execute(sqlCreate).whenComplete(() => print("On create called "));
  }

  String _validateWordInput(String str, bool isWordStart) {
    setState(() {
      if (isWordStart) {
        isWordStartError = true;
      } else {
        isWordEndError = true;
      }
    });

    if (_wordStartTxtController.text.isEmpty &&
        _wordEndTxtController.text.isEmpty) {
      return "Atleast one of these two must be filled";
    } else if (!isAlpha(str) && str.isNotEmpty) {
      return "Word should contain letters only";
    }

    return null;

    setState(() {
      if (isWordStart) {
        isWordStartError = true;
      } else {
        isWordEndError = false;
      }
    });
  }

  _submitForm(BuildContext context) {
    if (formKey.currentState.validate()) {
      String wordStart = _wordStartTxtController.text;
      String wordEnd = _wordEndTxtController.text;
      int wordCount = int.parse(_wordCountTxtController.text);

      String queryString =
          "SELECT word FROM $tableName WHERE word LIKE '$wordStart%$wordEnd'";

      if (wordCount != 0) {
        queryString += " AND length=$wordCount";
      }

      Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
          LoadingPage(database: database, queryString: queryString,)));
      //Get the records
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            print('Screen height: ${MediaQuery
                .of(context)
                .size
                .height}');
            print('Real safe height: ${constraints.maxHeight}');
            return Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 48, top: 31),
                      width: 265,
                      child: RichText(
                        text: TextSpan(
                            text: 'Find words that ',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: ikireBlue,
                              height: 1.5,
                              fontSize: 18,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'start ',
                                  style: TextStyle(color: ikireOrange)),
                              TextSpan(text: 'and '),
                              TextSpan(
                                  text: 'end ',
                                  style: TextStyle(color: ikireOrange)),
                              TextSpan(text: 'with letters of your choice.')
                            ]),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 94, right: 94, top: 40, bottom: 50),
                        // width: 172,
                        // height: 152,
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/images/ikire_read.svg',
                            width: 172,
                            height: 152,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        width: 156,
                        margin: const EdgeInsets.only(
                          left: 50,
                        ),
                        child: Text(
                          "Length of Word (Optional)",
                          style: TextStyle(fontSize: 12, height: 1.5),
                        )),
                    Container(
                      margin: const EdgeInsets.only(left: 50, top: 8),
                      width: 103,
                      child: NumberInputWithIncrementDecrement(
                          scaleHeight: 0.75,
                          incDecBgColor: Hexcolor('#F0F0F0'),
                          widgetContainerDecoration: BoxDecoration(
                            color: Hexcolor('#F0F0F0'),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          numberFieldDecoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            border: InputBorder.none,
                          ),
                          controller: _wordCountTxtController),
                    ),
                    Container(
                        margin: const EdgeInsets.only(left: 50, top: 10),
                        child: Text(
                          'Word Starts With :',
                          style: TextStyle(fontSize: 12),
                        )),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 50,
                        right: 50,
                      ),
                      // height: 30,
                      width: 260,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          return _validateWordInput(value, true);
                        },
                        controller: _wordStartTxtController,
                        style: TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.all(10),
                            filled: true,
                            fillColor: Hexcolor('#F0F0F0'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: BorderSide.none,
                            )),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(left: 50, top: 10),
                        child: Text(
                          'Word Ends With :',
                          style: TextStyle(fontSize: 12, height: 1.5),
                        )),
                    Container(
                      margin: const EdgeInsets.only(left: 50, right: 50),
                      width: 260,
                      // height: 30,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          return _validateWordInput(value, false);
                        },
                        controller: _wordEndTxtController,
                        style: TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            isDense: true,
                            filled: true,
                            fillColor: Hexcolor('#F0F0F0'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide.none,
                            )),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 135, right: 135, bottom: 10, top: 20),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: Color(0Xff4343EA),
                        onPressed: () {
                          _submitForm(context);
                        },
                        child: Text(
                          "Search",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              height: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ));
  }
}


class LoadingPage extends StatelessWidget {

  final Database database;
  final String queryString;

  LoadingPage({ @required this.database, @required this.queryString});

  @override
  Widget build(BuildContext context) {
    _searchDB(context, queryString);
    return _buildLoadingScreen(context);
  }


  _buildLoadingScreen(BuildContext context) {
    return Scaffold(
      // backgroundColor: Hexcolor('#E5E5E5'),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(left: 31, top: 40),
                child: CircleAvatar(
                  backgroundColor: Hexcolor('#F6FAF9'),
                  child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: ikireBlueBalls,
                      onPressed: () => Navigator.pop(context)),
                )),
            Container(
                height: 57,
                width: 57,
                margin: EdgeInsets.only(left: 150, right: 150, top: 230),
                child: LoadingIndicator(
                  indicatorType: Indicator.ballPulse,
                  color: ikireBlueBalls,
                  colors: [Colors.grey],
                )),
            Container(
                margin: EdgeInsets.only(top: 10, left: 79, right: 79),
                child: Text(
                  "Agentword is fetching words",
                  style: TextStyle(
                      color: ikireBlueLight,
                      fontWeight: FontWeight.w200,
                      fontSize: 14,
                      height: 1.5),
                ))
          ],
        ),
      ),
    );
  }

  _searchDB(BuildContext context, String queryString) async {
    // setState(() {
    //   _loading = true;
    // });

    // FocusScopeNode currentFocus = FocusScope.of(context);


    await database.rawQuery(queryString).then((value) {
      value.forEach((element) {
        print(element);
      });

      var nextPage;

      if (value.isNotEmpty) {
        nextPage = WordsFoundPage(
          wordsFound: value,
        );
      } else {
        nextPage = NoWordsFoundPage();
      }
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {
            return nextPage;
          }));
    });
  }
}
