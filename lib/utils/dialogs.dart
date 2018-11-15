import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class DeleteListDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(FlutterI18n.translate(context, "detele_list")),
      content: Text(FlutterI18n.translate(context, "detele_list_content")),
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
    );
  }
}

class UpdateRecordDialog extends StatelessWidget {
  String nameValue;
  String descValue;
  final tfName = new TextEditingController();
  final tfDesc = new TextEditingController();

  void setValues(){
    tfName.text=nameValue;
    tfDesc.text=descValue;
  }
  UpdateRecordDialog({this.nameValue, this.descValue});
  @override
  Widget build(BuildContext context) {
    setValues();
    return SimpleDialog(
      title: Text(FlutterI18n.translate(context, "update_record")),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 24.0, bottom: 8.0),
          child: TextField(
            controller: tfName,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: FlutterI18n.translate(context, "name"),
              labelStyle: TextStyle(fontSize: 28.0),
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: tfDesc,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: FlutterI18n.translate(context, "descripcion"),
              labelStyle: TextStyle(fontSize: 28.0),
              hintText: FlutterI18n.translate(context, "descripcion_opcional"),
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text(
                  FlutterI18n.translate(context, "cancel"),
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () => Navigator.pop(context, {'accion':"cancel"})
              ),
              FlatButton(
                child: Text(
                  FlutterI18n.translate(context, "ok"),
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () => Navigator.pop(context, {'accion':"ok", 'nameValue':tfName.text, 'descValue':tfDesc.text}),
              ),
            ],
          ),
        )
      ],
      /*
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
    */
    );
  }
}
