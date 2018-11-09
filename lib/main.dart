import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:on_list/index/index.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:on_list/tutorial/tutorial.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
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
  Widget build(BuildContext context) {
    createDb();
    return new MaterialApp(
      title: 'Onlist',
      theme: new ThemeData(
        primarySwatch: Colors.pink,
      ),
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
      builder:
          (BuildContext context, AsyncSnapshot<bool> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return _loading(context);
          default:
            if (!snapshot.hasError) {
              return snapshot.data
                  ? Tutorial()
                  : Index();
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
