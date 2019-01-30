import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
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
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart' as flutPath;

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  BannerAd myBanner;
  Timer _timerLink;
  void createDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "onlist2.db");
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE Lista (id INTEGER PRIMARY KEY, name TEXT, reference TEXT)");
    });
  }

  Future<void> _retrieveDynamicLink() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.retrieveDynamicLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      String listShared = getListShared(deepLink);
      if (listShared != null)connectList(listShared);
    }
  }

  String getListShared(Uri deepLink) {
    return deepLink.queryParameters['list'];
  }

  void connectList(listName) async {
    if (await listNotDb(listName))
      insertListDb(listName, listName.split("_")[0]);
  }

  void insertListDb(String referenceName, String listName) async {
    int idList;
    var databasesPath = await sqflite.getDatabasesPath();
    String path = flutPath.join(databasesPath, "onlist2.db");
    sqflite.Database database = await sqflite.openDatabase(path);
    await database.transaction((txn) async {
      idList = await txn.rawInsert(
          'INSERT INTO Lista(name, reference) VALUES(?,?)',
          [listName, referenceName]);
    }).then((data) {
      createProperty(idList);
    });
  }

  void createProperty(idList) async {
    SharedPreferences props = await SharedPreferences.getInstance();
    await props.setInt("currListId", idList);
  }
  Future<bool> listNotDb(String listName) async {
    var databasesPath = await sqflite.getDatabasesPath();
    String path = flutPath.join(databasesPath, "onlist2.db");
    sqflite.Database database = await sqflite.openDatabase(path);
    List<Map<String, dynamic>> lista = await database
        .rawQuery("SELECT * FROM Lista WHERE reference = ?", [listName]);
    return lista.length > 0 ? false : true;
  }

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: getAppId());
    myBanner = buildBanner()..load();
    createDb();
    WidgetsBinding.instance.addObserver(this);
    _retrieveDynamicLink();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = new Timer(const Duration(milliseconds: 850), () {
        _retrieveDynamicLink();
      });
    }
  }

  @override
  void dispose() {
    myBanner?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sharlist',
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
              if (!snapshot.data)
                myBanner
                  ..load()
                  ..show();
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
