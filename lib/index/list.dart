import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:on_list/index/editProduct.dart';
import 'package:on_list/utils/dialogs.dart';

class ListProducts extends StatefulWidget {
  final String list;
  final Function setCanShow;

  ListProducts({this.list, this.setCanShow});

  @override
  _ListProductsState createState() => new _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(listener);
    super.initState();
  }

  void listener() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward)
      widget.setCanShow(true);
    else
      widget.setCanShow(false);
  }

  @override
  void dispose() {
    scrollController.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection(widget.list)
          .orderBy("name")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Container(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: CircularProgressIndicator(),
            ),
          );
        if (snapshot.data.documents.length == 0) return NoProducts();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    Map<dynamic, String> updateRecord(data) {
      if (data['accion'] == "ok") {
        record.reference.updateData(
            {"name": data['nameValue'], "description": data['descValue']});
      }
    }

    return Dismissible(
      key: ValueKey(record.name),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        if (record.reference.delete() != null)
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(record.name.toUpperCase() +
                " ${FlutterI18n.translate(context, "bought")}!"),
            action: SnackBarAction(
                label: FlutterI18n.translate(context, "undo"),
                onPressed: () {
                  Firestore.instance
                      .collection(widget.list)
                      .document()
                      .setData({
                    "name": record.name,
                    "quantity": record.quantity,
                    "description": record.description,
                    "ts_date": record.ts_date
                  });
                }),
          ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            onTap: () =>
                record.reference.updateData({'quantity': record.quantity + 1}),
            onLongPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProduct(
                            record: record,
                          )));
            },
            title: Text(record.name),
            subtitle: Text(record.description),
            trailing: Text("x" + record.quantity.toString()),
          ),
        ),
      ),
    );
  }
}

class Record {
  final String name;
  int quantity;
  final String description;
  final DateTime ts_date;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['quantity'] != null),
        assert(map['description'] != null),
        assert(map['ts_date'] != null),
        name = map['name'],
        quantity = map['quantity'],
        description = map['description'],
        ts_date = map['ts_date'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record: $name x$quantity <$ts_date>";
}

class NoProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              FlutterI18n.translate(context, "empty_list"),
              style: TextStyle(color: Colors.grey[700], fontSize: 32.0),
            ),
            Text(
              FlutterI18n.translate(context, "add_press_button"),
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 24.0,
              ),
              textAlign: TextAlign.center,
            ),
            Icon(
              Icons.shopping_basket,
              color: Colors.grey[800],
              size: 150.0,
            )
          ],
        ),
      ),
    );
  }
}
