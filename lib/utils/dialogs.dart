import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class NotAbleShareDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(FlutterI18n.translate(context, "share_list")),
      content: Text(FlutterI18n.translate(context, "not_able_share")),
      actions: <Widget>[
        FlatButton(
          child: Text(
            FlutterI18n.translate(context, "accept"),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class ShareListDialog extends StatefulWidget {
  String code;

  ShareListDialog({this.code});

  @override
  ShareListDialogState createState() {
    return new ShareListDialogState();
  }
}

class ShareListDialogState extends State<ShareListDialog> {
  String helpStr = "";

  void copyCode(){
    setState(() {
      helpStr = FlutterI18n.translate(context, "copy_code");
      Clipboard.setData(new ClipboardData(text: widget.code));
    });
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(FlutterI18n.translate(context, "share_list")),
      content: _buildContent(context),
      actions: <Widget>[
        FlatButton(
          child: Text(
            FlutterI18n.translate(context, "share"),
          ),
          onPressed: () => Navigator.pop(context,"share"),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          FlutterI18n.translate(context, "list_code"),
          style: TextStyle(color: Colors.grey, fontSize: 20.0),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                widget.code,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              InkWell(
                splashColor: Theme.of(context).splashColor,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.content_copy,
                    color: Colors.grey,
                  ),
                ),
                onTap: copyCode,
              ),
            ],
          ),
        ),
        Container(
          height: 1.0,
          color: Theme.of(context).primaryColor,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                helpStr,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
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

  void setValues() {
    tfName.text = nameValue;
    tfDesc.text = descValue;
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
                  onPressed: () =>
                      Navigator.pop(context, {'accion': "cancel"})),
              FlatButton(
                child: Text(
                  FlutterI18n.translate(context, "ok"),
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () => Navigator.pop(context, {
                      'accion': "ok",
                      'nameValue': tfName.text,
                      'descValue': tfDesc.text
                    }),
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
