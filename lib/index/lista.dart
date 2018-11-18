class Lista {
  final String name;
  final int id;
  final String reference;

  Lista.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null),
        assert(map['id'] != null),
        assert(map['reference'] != null),
        name = map['name'],
        id = map['id'],
        reference = map['reference'];

  Lista({this.name,this.id, this.reference});

  @override
  String toString() => "Lista: $name($id) - $reference";
}