import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class Index extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return _loading(context);
          default:
            if (!snapshot.hasError) {
              return IndexApp(title: snapshot.data.getString('currList'));
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

class IndexApp extends StatefulWidget {
  String title;

  IndexApp({this.title});

  @override
  _IndexAppState createState() => new _IndexAppState();
}

class _IndexAppState extends State<IndexApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(widget.title),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: HeaderDrawer(),
    );
  }
}

class HeaderDrawer extends StatelessWidget {
  String path;
  Database database;
  List<Map> list;
  List<Lista> listas;
  // = await database.rawQuery('SELECT * FROM Test');// database = await sqflite.openDatabase(path);
  Future<List<Map>> getDataBase()async{
    path = join(await getDatabasesPath(), "onlist.db");
    database = await openDatabase(path);
    list = await database.rawQuery('SELECT * FROM Test');
      return list;
  }

  @override
  Widget build(BuildContext context) {
    return Text("Hula");
  }
  /*
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<String>(
      future: getDatabasesPath(),
      builder:
          (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return _buildLoading(context);
          case ConnectionState.done:
            path = join(snapshot.data, "onlist.db");
            return _connectDb(context);
          default:
            _buildLoading(context);
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Database>(
      future: getDataBase(),
      builder: (BuildContext context, AsyncSnapshot<Database> snapshot){
        switch (snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return _buildLoading(context);
          case ConnectionState.done:
            database = snapshot.data;
            return _buildDrawer(context);
          default:
            _buildLoading(context);
        }
      },
    );
  }
  Widget _buildDrawer(BuildContext context){
    return Column(
      children: <Widget>[
        Text("lista1"),
        Text("lista2"),
        Text("lista3"),
      ],
    );
  }
  Widget _buildLoading(BuildContext context){
    return SizedBox(
      height: MediaQuery.of(context).size.height*0.20,
      width: MediaQuery.of(context).size.width,
      child: Container(
          color: Colors.pink,
          child: CircularProgressIndicator(backgroundColor: Colors.white,)),
    );
  }

  */
}

class Lista {
  final String name;
  final List<int> password;
  final int id;

  Lista.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null),
        assert(map['password'] != null),
        assert(map['id'] != null),
        name = map['name'],
        password = map['password'],
        id = map['id'];
  @override
  String toString() => "Record<$name:$password>";
}