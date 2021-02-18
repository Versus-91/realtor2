class Area {
  String name;
  int id;
  Area({this.name, this.id});
  factory Area.fromMap(Map<String, dynamic> json) => Area(
        name: json["name"],
        id: json["id"],
      );
  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}
