import 'dart:io';
import 'dart:typed_data';

import 'package:agent_word/splash_screen.dart';
import 'package:agent_word/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:string_validator/string_validator.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agent Word',
      theme: ThemeData(
        primaryColor: Colors.white,
        backgroundColor: Hexcolor('#E5E5E5'),
        accentColor: ikireBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: MySplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dbName = 'agent_word.db';
  String dbPath;
  String tableName = 'words_alpha';
  Database database;
  bool isWordStartError = false;
  bool isWordEndError = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _wordStartTxtController = TextEditingController();
  final TextEditingController _wordEndTxtController = TextEditingController();
  final TextEditingController _wordCountTxtController = TextEditingController();

  @override
  void dispose() {
    _wordEndTxtController.dispose();
    _wordStartTxtController.dispose();
    _wordCountTxtController.dispose();
    super.dispose();
  }

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

  // _insertIntoDb (String word, int length) async {
  //
  //   // print("Here");
  //   // Insert some records in a transaction
  //   await database.transaction((txn) async {
  //
  //     print('XXXX:YYYY');
  //
  //     int id2 = await txn.rawInsert(
  //         'INSERT INTO $tableName (word, length) VALUES(?, ?)',
  //         [word, length]).whenComplete(() => print('inserted2: '));
  //
  //   });
  //
  //   print("Step 3");
  //
  // }
  //
  // _loadTextFile (BuildContext context) async {
  //   String textData = await DefaultAssetBundle.of(context).loadString('assets/words_alpha.txt');
  //
  //   print("Started !!!!");
  //   List<String> list =
  //   LineSplitter().convert(textData).map((s) {
  //     // int length = s.length;
  //     // print("Still running");
  //     //
  //     return s;
  //   }).toList();
  //   print("Done!!!!!!!");
  //   print(list.sublist(0, 15));
  //
  //   list.forEach((element) {
  //     int length = element.length;
  //     _insertIntoDb(element, length);
  //   });
  // }
  //

  _deleteDB() async {
    // Delete the database
    await deleteDatabase(dbPath);
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
    } else if (!isAlpha(str)) {
      return "Word should contain letters only";
    }

    setState(() {
      if (isWordStart) {
        isWordStartError = true;
      } else {
        isWordEndError = false;
      }
    });

    return null;
  }

  _searchDB() async {
    if (formKey.currentState.validate()) {
      String wordStart = _wordStartTxtController.text;
      String wordEnd = _wordEndTxtController.text;
      String wordCount = _wordCountTxtController.text;


      String queryString = 'Select * FROM $tableName';
      //Get the records
      List <Map> list = await database.rawQuery(queryString);
      print(list);
    }
  }

  @override
  Widget build(BuildContext context) {
    double wordStartHeight = isWordStartError ? 50 : 30;
    double wordEndHeight = isWordEndError ? 50 : 30;

    return Scaffold(
      body: SafeArea(
        // Layout builder used to get the safe area height
        child: LayoutBuilder(
          builder: (context, constraints) {
            print('Screen height: ${MediaQuery
                .of(context)
                .size
                .height}');
            print('Real safe height: ${constraints.maxHeight}');
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: <Widget>[
                    // Container restricts the height of the stack to the height of our safe area
                    // This enables the stack to work with SingleChildScrollView
                    Container(height: MediaQuery
                        .of(context)
                        .size
                        .height,),

                    Positioned(
                        top: 31,
                        left: 48,
                        // right: 47,
                        child: Container(
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
                                  TextSpan(text: 'start ' , style: TextStyle(color: ikireOrange)),
                                  TextSpan(text: 'and '),
                                  TextSpan(text: 'end ', style: TextStyle(color: ikireOrange)),
                                  TextSpan(text: 'with letters of your choice.')

                                ]
                            ),
                          ),
                        )),
                    Positioned(
                        top: 119,
                        child: SvgPicture.asset(
                          'assets/images/ikire_read.svg',
                          width: 172,
                          height: 152,
                        )),
                    Positioned(
                      top: 345,
                      left: 50,
                      child: Text("Length of Word (Optional)", style: TextStyle(fontSize: 12, height: 1.5),),
                    ),
                    Positioned(
                      top: 369,
                      width: 103,
                      // height: 30,
                      left: 50,
                      child: NumberInputWithIncrementDecrement(
                        // decIconSize: 15,
                        // incIconSize: 15,
                          scaleHeight: 0.7,
                          // decIconBgColor: Hexcolor('#F0F0F0'),
                          incDecBgColor: Hexcolor('#F0F0F0'),
                          widgetContainerDecoration: BoxDecoration(

                            color: Hexcolor('#F0F0F0'),
                            // border: Border(),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          numberFieldDecoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 0),
                            border: InputBorder.none,

                          ),
                          controller: _wordCountTxtController),
                    ),

                    Positioned(
                      top: 416,
                      left: 50,
                      child: Text('Word Starts With :', style: TextStyle(fontSize: 12, height: 1.5),),
                    ),
                    Positioned(
                        top: 434,
                        width: 260,
                        height: wordStartHeight,
                        left: 50,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            return _validateWordInput(value, true);
                          },
                          controller: _wordStartTxtController,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Hexcolor('#F0F0F0'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                                borderSide: BorderSide.none,
                              )),
                        )),
                    Positioned(
                      top: 484,
                      left: 50,
                      child: Text('Word Ends With :', style: TextStyle(fontSize: 12, height: 1.5),),
                    ),
                    Positioned(
                        top: 502,
                        width: 260,
                        height: wordEndHeight,
                        left: 50,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            return _validateWordInput(value, false);
                          },
                          controller: _wordEndTxtController,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Hexcolor('#F0F0F0'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none,
                              )),
                        )),
                    Positioned(
                      left: 135,
                      height: 36,
                      width: 90,
                      top: 573,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius
                            .circular(5)),
                        color: Color(0Xff4343EA),
                        onPressed: _searchDB,
                        child: Text(
                          "Search",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              height: 1.5),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
