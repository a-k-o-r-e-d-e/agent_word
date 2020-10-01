import 'package:agent_word/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:string_validator/string_validator.dart';
import 'package:agent_word/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sqflite/sqflite.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: ikireBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dbName = 'words2.db';
  String dbPath;
  String tableName = 'words_alpha';
  Database database;

  final TextEditingController _wordStartTxtController = TextEditingController();
  final TextEditingController _wordEndTxtController = TextEditingController();

  @override
  void dispose() {
    _wordEndTxtController.dispose();
    _wordStartTxtController.dispose();
    super.dispose();
  } // _setUpDB () async {
  //   // Get a location using getDatabasesPath
  //   var databasesPath = await getDatabasesPath();
  //   dbPath = join(databasesPath, dbName);
  //
  //   // var db = await openDatabase(dbName);
  //   String sqlString = "CREATE TABLE $tableName (id INTEGER PRIMARY KEY, word TEXT, length INTEGER)";
  //
  //   // open the database
  //    database = await openDatabase(dbPath, version: 2,
  //       onCreate: (Database db, int version) async {
  //         // When creating the db, create the table
  //         print("On create called ");
  //
  //         print(sqlString);
  //         await db.execute(
  //             sqlString);
  //
  //       }).catchError((onError) {
  //         print(onError.runtimeType);
  //    });
  //
  //   print(database);
  //
  //   // database.execute(sqlString).whenComplete(() => print("On create called "));
  //
  // }
  //
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
  // _deleteDB () async {
  //
  //   // Delete the database
  //   await deleteDatabase(dbPath);
  // }

  String _validateWordInput(String str) {
    if (_wordStartTxtController.text.isEmpty &&
        _wordEndTxtController.text.isEmpty) {
      return "Atleast one of these two must be filled";
    } else if (!isAlpha(str)) {
      return "Word should contain letters only";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      body: Center(
        child: Form(
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              Positioned(
                  top: 40,
                  // left: 48,
                  // right: 47,
                  child: Container(
                    width: 265,
                    child: RichText(
                      text: TextSpan(
                        text: 'Find words that ',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: ikireBlue,
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
                    'assets/ikire_read.svg',
                    width: 172,
                    height: 152,
                  )),
              Positioned(
                top: 345,
                left: 50,
                child: Text("Length of Word (Optional)", style: TextStyle(fontSize: 12),),
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
                        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                      border: InputBorder.none,

                    ),
                    controller: TextEditingController()),
              ),
              //     TextFormField(
              //   keyboardType: TextInputType.text,
              //   validator: _validateWordInput,
              //   decoration: InputDecoration(
              //       filled: true,
              //       fillColor: Hexcolor('#F0F0F0'),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(3),
              //         borderSide: BorderSide.none,
              //       )
              //   ),
              // )),

              Positioned(
                  top: 416,
                  width: 183,
                  left: 50,
                  child: Text('Word Starts With :', style: TextStyle(fontSize: 12),),
              ),
              Positioned(
                  top: 434,
                  width: 260,
                  height: 30,
                  left: 50,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    validator: _validateWordInput,
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
                  height: 13,
                  width: 176,
                  left: 50,
                  child: Text('Word Ends With :', style: TextStyle(fontSize: 12),),
              ),
              Positioned(
                  top: 502,
                  width: 260,
                  height: 30,
                  left: 50,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    validator: _validateWordInput,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Hexcolor('#F0F0F0'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3),
                          borderSide: BorderSide.none,
                        )),
                  )),
              Positioned(
                left: 135,
                height: 36,
                width: 90,
                top: 573,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  color: Color(0Xff4343EA),
                  onPressed: () {},
                  child: Text(
                    "Search",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
