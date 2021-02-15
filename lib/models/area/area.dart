class Area {
  String name;
  int id;
  Area({this.name, this.id});
  factory Area.fromMap(Map<String, dynamic> jason) => Area(
        name: jason["name"],
        id: jason["id"],
      );
  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}
