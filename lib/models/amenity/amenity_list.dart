import 'package:boilerplate/models/amenity/amenity.dart';

class AmenityList {
  final List<Amenity> amenities;

  AmenityList({
    this.amenities,
  });

  factory AmenityList.fromJson(List<dynamic> json) {
    List<Amenity> amenities = List<Amenity>();
    amenities = json.map((item) => Amenity.fromMap(item)).toList();

    return AmenityList(
      amenities: amenities,
    );
  }
}
