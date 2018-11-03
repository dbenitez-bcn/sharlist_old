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
    return Container(
      child: Column(
        children: <Widget>[
          _dataInputs(context),
          _buttons(context),
        ],
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
        PasswordIcons(),
      ],
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
                  onPressed: () {},
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
}

class PasswordIcons extends StatefulWidget {
  @override
  _PasswordIconsState createState() => new _PasswordIconsState();
}

class _PasswordIconsState extends State<PasswordIcons> {
  List<int> passValue = [1, 2, 3, 4]; //1-meat, 2-vegetable, 3-milk, 4-fish

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CreateLoadModel>(
      builder: (context, _, model) => Padding(
            padding: const EdgeInsets.only(
                top: 0.0, bottom: 16.0, left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildItem(context, 0, passValue[0]),
                _buildItem(context, 1, passValue[1]),
                _buildItem(context, 2, passValue[2]),
                _buildItem(context, 3, passValue[3]),
              ],
            ),
          ),
    );
  }

  Widget _buildItem(BuildContext context, int value, int index) {
    if (value == 1) {
      return _buildMeat(context, value, index);
    } else if (value == 2) {
      return _buildVegetable(context, value, index);
    } else if (value == 3) {
      return _buildMilk(context, value, index);
    } else {
      return _buildFish(context, value, index);
    }
  }

  Widget _buildMeat(BuildContext context, int value, int index) {
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

  Widget _buildVegetable(BuildContext context, int value, int index) {
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

  Widget _buildMilk(BuildContext context, int value, int index) {
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

  Widget _buildFish(BuildContext context, int value, int index) {
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
