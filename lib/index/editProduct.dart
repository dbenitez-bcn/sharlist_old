import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:on_list/index/list.dart';
import 'package:on_list/utils/admob.dart';

class EditProduct extends StatelessWidget {
  final Record record;

  EditProduct({this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, "edit_product")),
      ),
      body: BodyEditProduct(
        record: record,
        cantidad: record.quantity,
        nameValue: record.name,
        descValue: record.description,
      ),
    );
  }
}

class BodyEditProduct extends StatefulWidget {
  final Record record;
  final int cantidad;
  final String nameValue;
  final String descValue;

  BodyEditProduct({this.record, this.cantidad, this.nameValue, this.descValue});

  @override
  BodyEditProductState createState() {
    return new BodyEditProductState();
  }
}

class BodyEditProductState extends State<BodyEditProduct> {
  final tfName = new TextEditingController();
  final tfDesc = new TextEditingController();
  int cantidad;
  bool connecting = false;

  @override
  void initState() {
    cantidad=widget.cantidad;
    tfName.text = widget.nameValue;
    tfDesc.text = widget.descValue;
    super.initState();
  }

  void editProduct() {
    connecting=true;
    setState(() {

    });

    widget.record.reference.updateData({"name": tfName.text, "description": tfDesc.text, "quantity": cantidad});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 24.0, bottom: 8.0),
              child: TextField(
                onChanged: (_) {
                  setState(() {});
                },
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
                  hintText:
                  FlutterI18n.translate(context, "descripcion_opcional"),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      if (cantidad > 1) cantidad--;
                      setState(() {});
                    },
                    child: Circle(icono: Icons.remove)),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor, width: 3.0),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        cantidad.toString(),
                        style: TextStyle(fontSize: 32.0),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      cantidad++;
                      setState(() {});
                    },
                    child: Circle(icono: Icons.add)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: connecting
                  ? CircularProgressIndicator()
                  : RaisedButton(
                onPressed: tfName.text == "" ? null : editProduct,
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    FlutterI18n.translate(context, "update_record"),
                    style: TextStyle(fontSize: 32.0, color: Colors.white),
                  ),
                ),
              ),
            ),
            bannerSeparator(context),
          ],
        ),
      ),
    );
  }
}

class Circle extends StatelessWidget {
  final icono;

  Circle({this.icono});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.10,
      height: MediaQuery.of(context).size.width * 0.10,
      decoration: BoxDecoration(
        color: Colors.blueGrey[300],
        shape: BoxShape.circle,
      ),
      child: Icon(
        icono,
        color: Colors.white,
        size: 32.0,
      ),
    );
  }
}
