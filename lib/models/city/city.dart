//city class
class City {
  int id;
  String name;

  City({this.id, this.name});

  factory City.fromMap(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}
