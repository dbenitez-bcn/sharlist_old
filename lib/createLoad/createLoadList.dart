import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:on_list/icons/icomoon.dart';
import 'package:on_list/model/createLoadModel.dart';
import 'package:scoped_model/scoped_model.dart';

class CreateLoad extends StatefulWidget {
  @override
  _CreateLoadState createState() => new _CreateLoadState();
}

class _CreateLoadState extends State<CreateLoad> {
  final tfName = new TextEditingController();
  int valueIconOne = 1;
  int valueIconTwo = 2;
  int valueIconThree = 3;
  int valueIconFour = 4;
  final _formKey = GlobalKey<FormState>();
  String errorLabel;
  bool conecting = false;

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

  void checkEmpty(model) {
    if (tfName.text == "") {
      errorLabel = "Introduce un nombre";
      _formKey.currentState.validate();
    } else if (tfName.text.contains("/")) {
      errorLabel = "El nombre no puede contener '/'";
      _formKey.currentState.validate();
    } else {
      model.isCreate ? checkList() : conectList();
    }
  }

  void checkList() {
    Firestore.instance.runTransaction((Transaction transaction) async {
      QuerySnapshot reference =
          await Firestore.instance.collection(tfName.text).getDocuments();
      if (reference.documents.length > 0) {
        errorLabel = "La lista ya axiste";
        _formKey.currentState.validate();
      } else
        createList();
    });
  }

  void createList() async {
    print("Lista creada");
    List<int> passValues = [
      valueIconOne,
      valueIconTwo,
      valueIconThree,
      valueIconFour
    ];
    await Firestore.instance
        .collection(tfName.text)
        .document('password')
        .setData({"password": passValues});
  }

  void conectList() {
    final DocumentReference lista =
    Firestore.instance.document(tfName.text + '/password');

    Firestore.instance.runTransaction((Transaction tx) async {
      Future<DocumentSnapshot> postSnapshot = tx.get(lista);
      postSnapshot.asStream().forEach(passCorrect);
    });
    /*
    final DocumentReference lista =
        Firestore.instance.document(tfName.text + '/password');

    Firestore.instance.runTransaction((Transaction tx) async {
      print("running transacciont");
      DocumentSnapshot postSnapshot = await tx.get(lista);

      DocumentSnapshot postSnapshot = await tx.get(lista);
      //print("${postSnapshot['password'].toString()}-${passValues.toString()}");
      if(postSnapshot.exists){
        if(postSnapshot['password'].toString()==passValues.toString()){
          print("Conectar");
        }else{
          print("Pass incorrect");
        }
        //await postSnapshot['password'].toString()==passValues.toString()?print("Conectar"):print("Pass incorrect");
      }else{
        errorLabel = "Nombre incorrecto";
        _formKey.currentState.validate();

      }

    });
    */
  }
  void passCorrect(data){
    List<int> passValues = [
      valueIconOne,
      valueIconTwo,
      valueIconThree,
      valueIconFour
    ];
    try{
      if(data['password'].toString()==passValues.toString()){
        print("Conectar");
      }else{
        errorLabel = "Contraseña incorrecta";
        _formKey.currentState.validate();
      }
    }catch(e){
      errorLabel = "Nombre incorrecto";
      _formKey.currentState.validate();
    }
    /*
    if(data['password'].toString()==passValues.toString()){
      print("Conectar");
    }else{
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<CreateLoadModel>(
      model: CreateLoadModel(),
      child: ScopedModelDescendant<CreateLoadModel>(
        builder: (context, _, model) => Scaffold(
              appBar: AppBar(
                title: Text(model.isCreate
                    ? FlutterI18n.translate(context, "new_list")
                    : FlutterI18n.translate(context, "conect_list")),
              ),
              body: _content(context),
            ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            _dataInputs(context),
            _buttons(context),
          ],
        ),
      ),
    );
  }

  Widget _dataInputs(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _nameField(context),
          _passwordField(context),
        ],
      ),
    );
  }

  Widget _nameField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: tfName,
        decoration: InputDecoration(
          labelText: FlutterI18n.translate(context, "name"),
          labelStyle: TextStyle(fontSize: 28.0),
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(12.0),
          ),
        ),
        validator: (value) {

          conecting=false;
          setState(() {

          });
          return errorLabel;
        },
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
                border: Border.all(color: Colors.pink, width: 2.0),
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
                  color: Colors.pink,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttons(BuildContext context) {
    return ScopedModelDescendant<CreateLoadModel>(
      builder: (context, _, model) => Column(
            children: <Widget>[
              conecting
                  ? CircularProgressIndicator()
                  : SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: RaisedButton(
                  color: Colors.pink,
                  child: Text(
                    model.isCreate
                        ? FlutterI18n.translate(context, "create_list")
                        : FlutterI18n.translate(context, "conect_list"),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    conecting=true;
                    setState(() {

                    });
                    checkEmpty(model);
                  },
                ),
              ),
              FlatButton(
                textColor: Colors.black,
                child: Text(model.isCreate
                    ? FlutterI18n.translate(context, "already_list")
                    : FlutterI18n.translate(context, "create_new_list")),
                onPressed: () {
                  model.changeIsCreate();
                },
              ),
            ],
          ),
    );
  }

  Widget _buildRowIcons(
    BuildContext context,
  ) {
    return ScopedModelDescendant<CreateLoadModel>(
      builder: (context, _, model) => Padding(
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
