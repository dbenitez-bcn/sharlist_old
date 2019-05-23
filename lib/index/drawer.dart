import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:on_list/index/addList.dart';
import 'package:on_list/index/help.dart';
import 'package:on_list/index/lista.dart';
import 'package:on_list/utils/admob.dart';
import 'package:on_list/utils/dialogs.dart';
import 'package:path/path.dart';
import 'package:share/share.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

const double DRAWER_WIDTH = 304.0;

class MyDrawer extends StatelessWidget {
  String path;
  Database database;
  List<Map> list;
  List<Widget> listItems;
  Lista mainList;

  final Function reload;

  MyDrawer({this.reload});

  void changeCurrList(Lista newMainList, bool newHaveList) async {
    SharedPreferences props = await SharedPreferences.getInstance();
    await props.setInt("currListId", newMainList.id).then((bool success) {
      reload(newMainList, newHaveList);
    });
  }

  Future<bool> loadData(BuildContext context) async {
    path = join(await getDatabasesPath(), "onlist2.db");
    database = await openDatabase(path);
    listItems = await database
        .rawQuery('SELECT * FROM Lista ORDER BY name ASC ')
        .then((data) =>
            data.map((list) => _buildListItem(context, list)).toList());
    int currList = await SharedPreferences.getInstance()
        .then((data) => data.getInt('currListId'));
    if (currList != null)
      mainList = await database.rawQuery('SELECT * FROM Lista WHERE id = ?',
          [currList]).then((data) => Lista.fromMap(data[0]));
    else
      mainList = Lista(
          name: FlutterI18n.translate(context, "appName"),
          id: -99,
          reference: "ashda");
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
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: _buildShare(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShare(BuildContext context) {

    void shareCallback(String decision){
      final RenderBox box = context.findRenderObject();
      final String text = FlutterI18n.translate(context, "share_list_text")+mainList.reference;
      if(decision=="share")
      Share.share(text,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }

    void shareList() {
      print(mainList.id);
      if (mainList.id > 0) {
        showDialog(
            context: context,
            builder: (BuildContext context) => ShareListDialog(
                  list: mainList,
                ));
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) => NotAbleShareDialog());
      }
    }

    return FlatButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.share,
            color: Colors.white,
          ),
          Text(
            FlutterI18n.translate(context, "share_this_list"),
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      onPressed: shareList,
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
        leading: Icon(Icons.help_outline),
        title: Text(FlutterI18n.translate(context, "help")),
      ),
      onTap: () => openWindow(HelpWindow()),
    );

    Widget dividerLine = Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Divider(
        height: 8.0,
      ),
    );

    return Column(
      children:
          listItems + [addList, dividerLine, help, bannerSeparator(context)],
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
        if (preferences.getInt('currListId') == lista.id) {
          changeCurrList(Lista.fromMap(listas[0]), true);
        } else {
          changeCurrList(mainList, true);
        }
        Navigator.of(context).pop();
      } else {
        await SharedPreferences.getInstance().then((preferences) {
          preferences.setInt("currListId", null);
          Navigator.of(context).pop();
          reload(
              Lista(
                  name: FlutterI18n.translate(context, "appName"),
                  id: -99,
                  reference: "ashda"),
              false);
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
        changeCurrList(lista, true);
      },
      onLongPress: () {
        showDialog<String>(
                context: context,
                builder: (BuildContext context) => DeleteListDialog())
            .then<String>((desicion) {
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
            height: DRAWER_WIDTH * 0.5,
            width: DRAWER_WIDTH * 0.5,
            child: CircularProgressIndicator(
              strokeWidth: 6.0,
            )),
      ],
    );
  }
}
