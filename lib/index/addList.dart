import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:on_list/utils/admob.dart';
import 'package:path/path.dart' as flutPath;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:math';

class AddList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, "add_list")),
      ),
      body: bodyAddList(),
    );
  }
}

class bodyAddList extends StatefulWidget {
  @override
  _bodyAddListState createState() => new _bodyAddListState();
}

class _bodyAddListState extends State<bodyAddList> {
  final tfName = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool conecting = false;
  String errorLabel;

  void firstStep() async {
    if (tfName.text == "")
      someError("no_name");
    else if (tfName.text.contains("/"))
      someError("no_slash");
    else {
      if (await checkConection()) {
        setState(() {
          conecting = true;
        });
        tfName.text.contains("_") ? connectList() : createList();
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              FlutterI18n.translate(context, "connect_error"),
            ),
          ),
        );
      }
    }
  }

  Future<bool> checkConection() async {
    try {
      final result = await InternetAddress.lookup('firebase.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else
        return false;
    } on SocketException catch (_) {
      return false;
    }
  }

  void connectList() async {
    if (await listExist(tfName.text)) {
      if (await listInDb(tfName.text))
        someError("list_in_db");
      else
        insertListDb(tfName.text, tfName.text.split("_")[0]);
    } else
      someError("list_no_exist");
  }

  void createList() async {
    DateTime time = DateTime.now();
    Random rand = Random(1000);
    String referenceName = tfName.text +
        "_" +
        "${time.day}${time.millisecond}${rand.nextInt(1000)}";

    if (await listExist(referenceName)) {
      createList();
    } else {
      await Firestore.instance
          .collection(referenceName)
          .document('referenceName')
          .setData({"referenceName": referenceName}).whenComplete(() {
        insertListDb(referenceName, tfName.text);
      });
    }
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

  Future<bool> listInDb(String listName) async {
    var databasesPath = await sqflite.getDatabasesPath();
    String path = flutPath.join(databasesPath, "onlist2.db");
    sqflite.Database database = await sqflite.openDatabase(path);
    List<Map<String, dynamic>> lista = await database
        .rawQuery("SELECT * FROM Lista WHERE reference = ?", [listName]);
    return lista.length > 0 ? true : false;
  }

  void createProperty(idList) async {
    SharedPreferences props = await SharedPreferences.getInstance();
    await props.setInt("currListId", idList).then((bool success) {
      Navigator.pop(context);
    });
  }

  Future<bool> listExist(String referenceName) async {
    QuerySnapshot reference =
        await Firestore.instance.collection(referenceName).getDocuments();
    if (reference.documents.length > 0)
      return true;
    else
      return false;
  }

  void someError(String text) {
    errorLabel = FlutterI18n.translate(context, text);
    _formKey.currentState.validate();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
                  _nameField(context),
                ] +
                (conecting
                    ? _loadingBuilder(context)
                    : [_buildCreate(context)]) +
                [bannerSeparator(context)],
          ),
        ),
      ),
    );
  }

  Widget _nameField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: tfName,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: FlutterI18n.translate(context, "new_list"),
          labelStyle: TextStyle(fontSize: 28.0),
          helperText: FlutterI18n.translate(context, "helper_new_list"),
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(12.0),
          ),
        ),
        validator: (value) {
          conecting = false;
          setState(() {});
          return errorLabel;
        },
      ),
    );
  }

  Widget _buildCreate(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Text(
          FlutterI18n.translate(context, "create_new_list"),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: firstStep,
      ),
    );
  }

  List<Widget> _loadingBuilder(BuildContext context) {
    return [
      Padding(
        padding: EdgeInsets.all(24.0),
        child: CircularProgressIndicator(),
      )
    ];
  }
}
