//city class
class Amenity {
  int id;
  String name;

  Amenity({this.id, this.name});

  factory Amenity.fromMap(Map<String, dynamic> json) => Amenity(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}
