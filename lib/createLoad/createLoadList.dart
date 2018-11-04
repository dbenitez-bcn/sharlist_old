import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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

  void changePassIconOne(){
    if(valueIconOne<4)valueIconOne=valueIconOne+1;
    else if (valueIconOne==4)valueIconOne=1;
    setState(() {

    });
  }

  void changePassIconTwo(){
    if(valueIconTwo<4)valueIconTwo=valueIconTwo+1;
    else if (valueIconTwo==4)valueIconTwo=1;
    setState(() {

    });
  }

  void changePassIconThree(){
    if(valueIconThree<4)valueIconThree=valueIconThree+1;
    else if (valueIconThree==4)valueIconThree=1;
    setState(() {

    });
  }

  void changePassIconFour(){
    if(valueIconFour<4)valueIconFour=valueIconFour+1;
    else if (valueIconFour==4)valueIconFour=1;
    setState(() {

    });
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
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: tfName,
            decoration: InputDecoration(
              labelText: FlutterI18n.translate(context, "name"),
              labelStyle: TextStyle(fontSize: 28.0),
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
        _passwordField(context),
      ],
    );
  }

  Widget _passwordField(BuildContext context){
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
                style: TextStyle(color: Colors.pink, fontSize: 20.0,),
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
              SizedBox(
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
                    List<int> passValues = [valueIconOne, valueIconTwo, valueIconThree, valueIconFour];
                    print("Name-> ${tfName.text} | Pass-> $passValues");
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
            padding: const EdgeInsets.only(
                top: 16.0, bottom: 16.0),
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
        Icons.android,
        color: Colors.red,
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
        Icons.android,
        color: Colors.lightGreenAccent[700],
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
        Icons.android,
        color: Colors.black,
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
        Icons.android,
        color: Colors.lightBlue,
      ),
    );
  }
}

/*

class IconPass {
  final int index;
  final int value;
}

*/
