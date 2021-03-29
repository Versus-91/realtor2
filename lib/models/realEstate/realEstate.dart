class RealEstate {
  String name;
  int id;
  RealEstate({this.name, this.id});

  factory RealEstate.fromMap(Map<String, dynamic> json) => RealEstate(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}
