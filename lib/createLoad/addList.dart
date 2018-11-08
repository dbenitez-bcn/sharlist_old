import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class AddList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, "add_list")),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          _buildCreate(context),
          _buildConnect(context),
        ],
      ),
    );
  }

  Widget _buildCreate(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: RaisedButton(
        color: Colors.pink,
        child: Text(
          FlutterI18n.translate(context, "create_list"),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _buildConnect(BuildContext context) {
    return InkWell(
      splashColor: Colors.pink[200],
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: FlatButton(
          onPressed: null,
          child: Text(FlutterI18n.translate(context, "conect_list"), style: TextStyle(color: Colors.black),),
        ),
      ),
      onTap: () {},
    );
  }
}
