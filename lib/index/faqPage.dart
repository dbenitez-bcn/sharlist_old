import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class FaqPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(FlutterI18n.translate(context, "faq_large"))),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildQuestion(context, FlutterI18n.translate(context, "question_one"), FlutterI18n.translate(context, "answare_one")),
        _buildQuestion(context, FlutterI18n.translate(context, "question_two"), FlutterI18n.translate(context, "answare_two")),
        _buildQuestion(context, FlutterI18n.translate(context, "question_three"), FlutterI18n.translate(context, "answare_three")),
        _buildQuestion(context, FlutterI18n.translate(context, "question_four"), FlutterI18n.translate(context, "answare_four")),
      ],
    );
  }

  Widget _buildQuestion(BuildContext context, String question, String answare){
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(question),
          subtitle: Text(answare),
        ),
       Divider(),
      ],
    );
  }
}
