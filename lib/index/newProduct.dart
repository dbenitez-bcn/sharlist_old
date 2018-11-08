import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class AddProduct extends StatelessWidget {
  final String lista;

  AddProduct({this.lista});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, "add_product")),
      ),
      body: BodyAddProduct(
        lista: lista,
      ),
    );
  }
}

class BodyAddProduct extends StatefulWidget {
  final String lista;

  BodyAddProduct({this.lista});

  @override
  BodyAddProductState createState() {
    return new BodyAddProductState();
  }
}

class BodyAddProductState extends State<BodyAddProduct> {
  final tfName = new TextEditingController();
  final tfDesc = new TextEditingController();
  int cantidad = 1;
  bool connecting = false;

  void addProduct() {
    connecting=true;
    setState(() {

    });

    Firestore.instance.collection(widget.lista.toLowerCase()).document().setData({
      "name": tfName.text,
      "quantity": cantidad,
      "description": tfDesc.text == "" ? tfName.text : tfDesc.text,
    }).whenComplete(() {
      Navigator.pop(context);
    });
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
                decoration: InputDecoration(
                  labelText: FlutterI18n.translate(context, "nombre"),
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
                maxLines: null,
                keyboardType: TextInputType.multiline,
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
                      border: Border.all(color: Colors.pink[400], width: 3.0),
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
                      onPressed: tfName.text == "" ? null : addProduct,
                      color: Colors.pink,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          FlutterI18n.translate(context, "add_to_list"),
                          style: TextStyle(fontSize: 32.0, color: Colors.white),
                        ),
                      ),
                    ),
            ),
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
