import 'package:flutter/material.dart';
import 'package:on_list/index/drawer.dart';
import 'package:on_list/index/list.dart';
import 'package:on_list/index/newProduct.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class Index extends StatelessWidget {

  Future<List<dynamic>> getData(context) async{
    return [await haveLists(), await getCurrList(context)];
  }
  Future<bool> haveLists() async{
    String path = join(await getDatabasesPath(), "onlist.db");
    Database database = await openDatabase(path);
    List<Map<String, dynamic>> listas =  await database.rawQuery('SELECT * FROM Lista');
    if(listas.length>0)return true;
    else return false;
  }

  Future<String> getCurrList(context) async{
   SharedPreferences preferences = await  SharedPreferences.getInstance();
   return preferences.getString("currList") ?? FlutterI18n.translate(context, "appName");
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<dynamic>>(
      future: getData(context),
      builder:
          (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return _loading(context);
          default:
            if (!snapshot.hasError) {
              return IndexApp(title: snapshot.data[1], haveList: snapshot.data[0],);
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
  bool haveList;
  bool canShow = true;
  IndexApp({this.title, this.haveList});

  @override
  _IndexAppState createState() => new _IndexAppState();
}

class _IndexAppState extends State<IndexApp> {
  void reload(String newTitle, bool newHaveList){
    widget.title = newTitle;
    widget.haveList = newHaveList;
    Future.delayed(Duration(milliseconds:250)).then((value){
      setState(() {});
    });
  }

  void setCanShow(bool value){
    setState(() {
      widget.canShow=value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: widget.haveList ? ListProducts(list: widget.title, setCanShow: setCanShow,) : NoLists(),
      floatingActionButton: widget.haveList && widget.canShow ? AddFab(lista: widget.title,) : null,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: MyDrawer(reload: reload,),
    );
  }
}

class AddFab extends StatelessWidget {
final String lista;
AddFab({this.lista});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddProduct(lista: lista,)));
      },
      child: Icon(Icons.add),
      elevation: 8.0,
    );
  }
}


class NoLists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            FlutterI18n.translate(context, "no_lists"),
            style: TextStyle(color: Colors.grey[700], fontSize: 32.0),
          ),
          Text(
            FlutterI18n.translate(context, "add_lists_empty"),
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 24.0,
            ),
            textAlign: TextAlign.center,
          ),
          Icon(
            Icons.menu,
            color: Colors.grey[800],
            size: 150.0,
          )
        ],
      ),
    );
  }
}
