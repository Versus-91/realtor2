import 'package:boilerplate/models/area/area.dart';

class District {
  int id;
  String name;
  String lastModificationTime;
  int lastModifierUserId;
  String creationTime;
  int creatorUserId;
  Area area;
  District({
    this.area,
    this.id,
    this.name,
    this.lastModificationTime,
    this.lastModifierUserId,
    this.creationTime,
    this.creatorUserId,
  });

  factory District.fromMap(Map<String, dynamic> json) {
    return District(
      id: json["id"],
      name: json["name"],
      area: json["area"] != null ? Area.fromMap(json["area"]) : null,
      lastModificationTime: json["lastModificationTime"],
      lastModifierUserId: json["lastModifierUserId"],
      creationTime: json["creationTime"],
      creatorUserId: json["creatorUserId"],
    );
  }

  Map<String, dynamic> toMap() => {
        "area": area.toMap(),
        "id": id,
        "name": name,
        "lastModificationTime": lastModificationTime,
        "lastModifierUserId": lastModifierUserId,
        "creationTime": creationTime,
        "creatorUserId": creatorUserId,
      };
}
