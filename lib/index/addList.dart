import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:on_list/icons/icomoon.dart';
import 'package:on_list/utils/admob.dart';
import 'package:path/path.dart' as flutPath;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class AddList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, "add_list")),
      ),
      body: AddListBody(),
    );
  }
}

class AddListBody extends StatefulWidget {
  @override
  _AddListBodyState createState() => new _AddListBodyState();
}

class _AddListBodyState extends State<AddListBody> {
  final tfName = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool conecting = false;
  String errorLabel;
  int valueIconOne = 1;
  int valueIconTwo = 2;
  int valueIconThree = 3;
  int valueIconFour = 4;

  void changePassIconOne() {
    if (valueIconOne < 4)
      valueIconOne = valueIconOne + 1;
    else if (valueIconOne == 4) valueIconOne = 1;
    setState(() {});
  }

  void changePassIconTwo() {
    if (valueIconTwo < 4)
      valueIconTwo = valueIconTwo + 1;
    else if (valueIconTwo == 4) valueIconTwo = 1;
    setState(() {});
  }

  void changePassIconThree() {
    if (valueIconThree < 4)
      valueIconThree = valueIconThree + 1;
    else if (valueIconThree == 4) valueIconThree = 1;
    setState(() {});
  }

  void changePassIconFour() {
    if (valueIconFour < 4)
      valueIconFour = valueIconFour + 1;
    else if (valueIconFour == 4) valueIconFour = 1;
    setState(() {});
  }

  void firstStep(bool isCreate) async {
    if (tfName.text == "") {
      errorLabel = FlutterI18n.translate(context, "no_name");
      _formKey.currentState.validate();
    } else if (tfName.text.contains("/")) {
      errorLabel = FlutterI18n.translate(context, "no_slash");
      _formKey.currentState.validate();
    } else {
      if (await checkConection()) {
        setState(() {
          conecting = true;
        });
        isCreate ? createList() : accesList();
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

  void createList() async {
    if (await listExist()) {
      errorLabel = FlutterI18n.translate(context, "list_exist");
      _formKey.currentState.validate();
    } else {
      List<int> passValues = [
        valueIconOne,
        valueIconTwo,
        valueIconThree,
        valueIconFour
      ];
      await Firestore.instance
          .collection(tfName.text.toLowerCase())
          .document('password')
          .setData({"password": passValues}).whenComplete(insertListDb);
    }
  }

  void accesList() async {
    if (!await listExist()) {
      errorLabel = FlutterI18n.translate(context, "list_no_exist");
      _formKey.currentState.validate();
    } else {
      var password = await getPassword();
      password is List<dynamic> ?
      checkPasswords(password): someError();
    }
  }

  Future<dynamic> getPassword() async {
   return await Firestore.instance
        .document(tfName.text.toLowerCase() + '/password')
        .get()
        .then((data) {
     return data['password'];
    }).catchError((e){
      return "Error: $e";
    });
  }

  void checkPasswords(List<dynamic> password){
    List<int> passValues = [
      valueIconOne,
      valueIconTwo,
      valueIconThree,
      valueIconFour
    ];
    if(passValues.toString()==password.toString())insertListDb();
    else{
      errorLabel = FlutterI18n.translate(context, "bad_pass");
      _formKey.currentState.validate();
    }
  }
  void someError(){
    errorLabel = "";
    _formKey.currentState.validate();
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(FlutterI18n.translate(context, "some_error"),)));
  }
  
  void insertListDb() async {
    String name = tfName.text;
    List<int> passValues = [
      valueIconOne,
      valueIconTwo,
      valueIconThree,
      valueIconFour
    ];
    var databasesPath = await sqflite.getDatabasesPath();
    String path = flutPath.join(databasesPath, "onlist.db");
    sqflite.Database database = await sqflite.openDatabase(path);
    await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO Lista(name, password) VALUES(?,?)', [name, passValues]);
    }).then(createProperty);
  }

  void createProperty(data) async {
    SharedPreferences props = await SharedPreferences.getInstance();
    await props.setString("currList", tfName.text).then((bool success) {
      Navigator.pop(context);
    });
  }

  Future<bool> listExist() async {
    QuerySnapshot reference =
        await Firestore.instance.collection(tfName.text.toLowerCase()).getDocuments();
    if (reference.documents.length > 0)
      return true;
    else
      return false;
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
                  _passwordField(context),
                ] +
                (conecting ? _loadingBuilder(context) : _buttons(context))
            +[bannerSeparator(context)],
          ),
        ),
      ),
    );
  }

  Widget _passwordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor, width: 2.0),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: _buildRowIcons(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Container(
              padding: EdgeInsets.only(left: 5.0, right: 8.0),
              color: Colors.grey[50],
              child: Text(
                FlutterI18n.translate(context, "password"),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
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
          labelText: FlutterI18n.translate(context, "name"),
          labelStyle: TextStyle(fontSize: 28.0),
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

  Widget _buildRowIcons(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: changePassIconOne,
            child: _buildIcon(context, valueIconOne),
          ),
          GestureDetector(
            onTap: changePassIconTwo,
            child: _buildIcon(context, valueIconTwo),
          ),
          GestureDetector(
            onTap: changePassIconThree,
            child: _buildIcon(context, valueIconThree),
          ),
          GestureDetector(
            onTap: changePassIconFour,
            child: _buildIcon(context, valueIconFour),
          ),
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

  List<Widget> _buttons(BuildContext context) {
    return [_buildCreate(context),SizedBox(height: 8.0,), _buildConnect(context)];
  }

  Widget _buildCreate(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Text(
          FlutterI18n.translate(context, "create_list"),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () {
          firstStep(true);
        },
      ),
    );
  }

  Widget _buildConnect(BuildContext context) {
    return InkWell(
      splashColor: Colors.teal[200],
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Theme.of(context).primaryColor, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(3.0)),
          ),
          child: Center(
            child: Text(
              FlutterI18n.translate(context, "already_list"),
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
      ),
      onTap: () {
        firstStep(false);
      },
    );
    /*
    return InkWell(
      splashColor: Colors.teal[200],
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: FlatButton(
          onPressed: null,
          child: Text(
            FlutterI18n.translate(context, "conect_list"),
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      onTap: () {
        firstStep(false);
      },
    );

    */
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
