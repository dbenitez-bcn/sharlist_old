import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:on_list/index/index.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:on_list/tutorial/tutorial.dart';
import 'package:sqflite/sqflite.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:on_list/utils/admob.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  BannerAd myBanner;
  void createDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "onlist.db");
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE Lista (id INTEGER PRIMARY KEY, name TEXT, password BLOB)");
        });
  }

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: getAppId());
    myBanner = buildBanner()..load();
    createDb();
    super.initState();
  }

  @override
  void dispose() {
    myBanner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Home list',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          primarySwatch: Colors.teal, splashColor: Colors.teal[200]),
      home: _myHome(context),
      localizationsDelegates: [
        FlutterI18nDelegate(false, 'en'),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      routes: <String, WidgetBuilder>{
        '/index': (BuildContext context) => Index(),
      },
    );
  }

  Future<bool> firstTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getBool("firstTime") ?? true;
  }

  Widget _myHome(BuildContext context) {
    return new FutureBuilder<bool>(
      future: firstTime(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return _loading(context);
          default:
            if (!snapshot.hasError) {
              if(!snapshot.data)myBanner..load()..show();
              return snapshot.data ? Tutorial() : Index();
            } else {
              return new Text("Error :(");
            }
        }
      },
    );
  }

  Widget _loading(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.width * 0.5,
          child: CircularProgressIndicator(
            strokeWidth: 10.0,
          ),
        ),
      ),
    );
  }
}