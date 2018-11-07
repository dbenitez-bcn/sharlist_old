import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:on_list/createLoad/addList.dart';
import 'package:on_list/icons/icomoon.dart';
import 'package:on_list/index/list.dart';
import 'package:on_list/index/newProduct.dart';
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
  void reload(String newList){
    widget.title = newList;
    Future.delayed(Duration(milliseconds:250)).then((value){
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListProducts(list: widget.title,),
      floatingActionButton: AddFab(lista: widget.title,),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: MyDrawer(reload: reload,),
    );
  }
}

class MyDrawer extends StatelessWidget {
  String path;
  Database database;
  List<Map> list;
  List<Widget> listItems;
  Lista mainList;

  final Function reload;

  void changeCurrList(String newList) async{
    SharedPreferences props = await SharedPreferences.getInstance();
    await props.setString("currList", newList).then((bool success) {
      reload(newList);
    });
  }

  MyDrawer({this.reload});

  Future<bool> loadData(BuildContext context) async {
    path = join(await getDatabasesPath(), "onlist.db");
    database = await openDatabase(path);
    listItems = await database.rawQuery('SELECT * FROM Lista').then(
        (data) => data.map((list) => _buildListItem(context, list)).toList());
    String currList = await SharedPreferences.getInstance()
        .then((data) => data.getString('currList'));
    mainList = await database.rawQuery('SELECT * FROM Lista WHERE name = ?',
        [currList]).then((data) => Lista.fromMap(data[0]));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<bool>(
      future: loadData(context),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return _buildLoading(context);
          case ConnectionState.done:
            if (!snapshot.hasError) return _buildDrawer(context);
            return Text("Error :(");
          default:
            _buildLoading(context);
        }
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildHeader(context),
        _buildLine(context),
        _buildBody(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.pink,
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildNameDrawer(context),
            PasswordIcons(
              pass: mainList.password,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameDrawer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, top: 8.0),
      child: Text(
        mainList.name,
        style: TextStyle(color: Colors.white, fontSize: 32.0),
      ),
    );
  }

  Widget _buildLine(BuildContext context) {
    return Container(
      height: 1.0,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey,
    );
  }

  Widget _buildBody(BuildContext context) {
    Widget addList = InkWell(
      splashColor: Colors.pink[200],
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: ListTile(
        leading: Icon(Icons.add_circle),
        title: Text(FlutterI18n.translate(context, "add_list")),
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddList()));
      },
    );
    return Column(
      children: listItems + [addList],
      //children: listItems+listItems+listItems+listItems+listItems+listItems+listItems+listItems+listItems + [addList],
    );
  }

  Widget _buildListItem(BuildContext context, Map list) {
    final Lista lista = Lista.fromMap(list);

    return InkWell(
      splashColor: Colors.pink[200],
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: ListTile(
        leading: Icon(Icons.list),
        title: Text(lista.name),
      ),
      onTap: () {
        Navigator.of(context).pop();
        changeCurrList(lista.name);
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
            height: MediaQuery.of(context).size.width * 0.3,
            width: MediaQuery.of(context).size.width * 0.3,
            child: CircularProgressIndicator(
              strokeWidth: 6.0,
            )),
      ],
    );
  }
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
  String toString() => "Lista: $name($id) - $password";
}

class PasswordIcons extends StatelessWidget {
  final List<int> pass;

  PasswordIcons({this.pass});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildIcon(context, pass[0]),
          _buildIcon(context, pass[1]),
          _buildIcon(context, pass[2]),
          _buildIcon(context, pass[3]),
        ],
      ),
    );
  }

  Widget _buildIcon(BuildContext context, int value) {
    if (value == 1) {
      return _buildMeat(context);
    } else if (value == 2) {
      return _buildVegetable(context);
    } else if (value == 3) {
      return _buildMilk(context);
    } else {
      return _buildFish(context);
    }
  }

  Widget _buildMeat(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.15,
      height: MediaQuery.of(context).size.width * 0.15,
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
        color: Colors.red[100],
        border: new Border.all(color: Colors.red, width: 2.0),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icomoon.meat,
        color: Colors.red,
        size: MediaQuery.of(context).size.width * 0.10,
      ),
    );
  }

  Widget _buildVegetable(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.15,
      height: MediaQuery.of(context).size.width * 0.15,
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
        color: Colors.lightGreenAccent[100],
        border: new Border.all(color: Colors.lightGreenAccent[700], width: 2.0),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icomoon.vegetable,
        color: Colors.lightGreenAccent[700],
        size: MediaQuery.of(context).size.width * 0.10,
      ),
    );
  }

  Widget _buildMilk(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.15,
      height: MediaQuery.of(context).size.width * 0.15,
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: new Border.all(color: Colors.black, width: 2.0),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icomoon.milk,
        color: Colors.black,
        size: MediaQuery.of(context).size.width * 0.10,
      ),
    );
  }

  Widget _buildFish(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.15,
      height: MediaQuery.of(context).size.width * 0.15,
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
        color: Colors.lightBlue[100],
        border: new Border.all(color: Colors.lightBlue, width: 2.0),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icomoon.fish,
        color: Colors.lightBlue,
        size: MediaQuery.of(context).size.width * 0.10,
      ),
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