import 'package:boilerplate/models/city/city.dart';

class Area {
  String name;
  int id;
  City city;
  Area({this.name, this.id, this.city});
  factory Area.fromMap(Map<String, dynamic> json) => Area(
      name: json["name"],
      id: json["id"],
      city: json["city"] != null ? City.fromMap(json["city"]) : null);
  Map<String, dynamic> toMap() =>
      {"id": id, "name": name, "city": city.toMap()};
}
