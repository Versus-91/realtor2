import 'package:boilerplate/models/city/city.dart';

class District {
  int id;
  String name;
  int cityId;
  String lastModificationTime;
  int lastModifierUserId;
  String creationTime;
  int creatorUserId;
  City city;
  District({
    this.id,
    this.name,
    this.cityId,
    this.lastModificationTime,
    this.lastModifierUserId,
    this.creationTime,
    this.creatorUserId,
    this.city,
  });

  factory District.fromMap(Map<String, dynamic> json) {
    return District(
      id: json["id"],
      name: json["name"],
      cityId: json["area"] != null ? json["area"]["cityId"] : null,
      lastModificationTime: json["lastModificationTime"],
      lastModifierUserId: json["lastModifierUserId"],
      creationTime: json["creationTime"],
      creatorUserId: json["creatorUserId"],
      city: (json["area"] != null && json["area"]["city"] != null)
          ? City.fromMap(json["area"]["city"])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        "city": city.toMap(),
        "id": id,
        "name": name,
        "cityId": cityId,
        "lastModificationTime": lastModificationTime,
        "lastModifierUserId": lastModifierUserId,
        "creationTime": creationTime,
        "creatorUserId": creatorUserId,
      };
}
