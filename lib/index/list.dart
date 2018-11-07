import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ListProducts extends StatefulWidget {
  final String list;
  ListProducts({this.list});
  @override
  _ListProductsState createState() => new _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
      Firestore.instance.collection(widget.list.toLowerCase()).orderBy("name").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Container(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: CircularProgressIndicator(),
              ));
        if (snapshot.data.documents.length == 0) return NoProducts();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children:
      snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Dismissible(
      key: ValueKey(record.name),
      onDismissed: (direction) {
        if(direction ==DismissDirection.endToStart){
          if(record.reference.delete() != null)
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text(record.name.toUpperCase() + " comprado!")));
        }
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
              if (record.quantity > 1)
                record.reference.updateData({'quantity': record.quantity - 1});
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
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['quantity'] != null),
        assert(map['description'] != null),
        name = map['name'],
        quantity = map['quantity'],
        description = map['description'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name: $quantity>";
}

class NoProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Lista vacía",
            style: TextStyle(color: Colors.grey[700], fontSize: 32.0),
          ),
          Text(
            "Añade productos con el botón inferior",
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
    );
  }
}
