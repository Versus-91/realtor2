//city class
class Amenity {
  int id;
  String name;
  String icon;
  Amenity({this.id, this.name, this.icon});

  factory Amenity.fromMap(Map<String, dynamic> json) => Amenity(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "icon": icon,
      };
}
