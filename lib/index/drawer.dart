import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:on_list/index/addList.dart';
import 'package:on_list/icons/icomoon.dart';
import 'package:on_list/index/help.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatelessWidget {
  String path;
  Database database;
  List<Map> list;
  List<Widget> listItems;
  Lista mainList;

  final Function reload;

  MyDrawer({this.reload});

  void changeCurrList(String newList, bool newHaveList) async {
    SharedPreferences props = await SharedPreferences.getInstance();
    await props.setString("currList", newList).then((bool success) {
      reload(newList, newHaveList);
    });
  }

  Future<bool> loadData(BuildContext context) async {
    path = join(await getDatabasesPath(), "onlist.db");
    database = await openDatabase(path);
    listItems = await database.rawQuery('SELECT * FROM Lista').then(
        (data) => data.map((list) => _buildListItem(context, list)).toList());
    String currList = await SharedPreferences.getInstance()
        .then((data) => data.getString('currList'));
    if (currList != null)
      mainList = await database.rawQuery('SELECT * FROM Lista WHERE name = ?',
          [currList]).then((data) => Lista.fromMap(data[0]));
    else
      mainList = Lista(
          name: FlutterI18n.translate(context, "appName"),
          password: [0, 0, 0, 0],
          id: -99);
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
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildHeader(context),
          _buildBody(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0.0, 2.0),
            blurRadius: 10.0,
          ),
        ],
      ),
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
        style:
            TextStyle(color: Colors.white, fontSize: 34.0, letterSpacing: -0.5),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    void openWindow(Widget window) async {
      await Future.delayed(Duration(milliseconds: 250)).then((value) {
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => window));
      });
    }

    Widget addList = InkWell(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: ListTile(
        leading: Icon(Icons.add_circle_outline),
        title: Text(FlutterI18n.translate(context, "add_list")),
      ),
      onTap: () => openWindow(AddList()),
    );

    Widget help = InkWell(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: ListTile(
        leading: Icon(Icons.info_outline),
        title: Text(FlutterI18n.translate(context, "help")),
      ),
      onTap: () => openWindow(HelpWindow()),
    );

    Widget dividerLine = Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Divider( height: 8.0,),
    );
    return Column(
      children: listItems + [addList, dividerLine, help],
    );
  }

  Widget _buildListItem(BuildContext context, Map list) {
    final Lista lista = Lista.fromMap(list);

    void deteleList() async {
      await database.rawDelete("DELETE FROM Lista WHERE id = ?", [lista.id]);
      List<Map<String, dynamic>> listas =
          await database.rawQuery('SELECT * FROM Lista');
      if (listas.length > 0) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        if (preferences.getString('currList') == lista.name) {
          changeCurrList(listas[0]['name'], true);
        } else {
          changeCurrList(preferences.getString('currList'), true);
        }
        Navigator.of(context).pop();
      } else {
        await SharedPreferences.getInstance().then((preferences) {
          preferences.setString("currList", null);
          Navigator.of(context).pop();
          reload(FlutterI18n.translate(context, "appName"), false);
        });
      }
    }

    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: ListTile(
        leading: Icon(Icons.list),
        title: Text(lista.name),
      ),
      onTap: () {
        Navigator.of(context).pop();
        changeCurrList(lista.name, true);
      },
      onLongPress: () {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text(FlutterI18n.translate(context, "detele_list")),
                  content: Text(
                      FlutterI18n.translate(context, "detele_list_content")),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        FlutterI18n.translate(context, "cancel"),
                      ),
                      onPressed: () => Navigator.pop(context, "cancel"),
                    ),
                    FlatButton(
                      child: Text(
                        FlutterI18n.translate(context, "ok"),
                      ),
                      onPressed: () => Navigator.pop(context, "ok"),
                    ),
                  ],
                )).then<String>((desicion) {
          if (desicion == "ok") deteleList();
        });
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

  Lista({this.name, this.password, this.id});

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
    } else if (value == 4) {
      return _buildFish(context);
    } else if (value == 0) {
      return _buildNone(context);
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

  Widget _buildNone(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.15,
      height: MediaQuery.of(context).size.width * 0.15,
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
        color: Colors.green[100],
        border: new Border.all(color: Colors.green[700], width: 2.0),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.android,
        color: Colors.green[100],
        size: MediaQuery.of(context).size.width * 0.10,
      ),
    );
  }
}
