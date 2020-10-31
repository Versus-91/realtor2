import 'package:boilerplate/models/amenity/amenity.dart';

class AmenityList {
  final List<Amenity> amenities;

  AmenityList({
    this.amenities,
  });

  factory AmenityList.fromJson(List<dynamic> json) {
    List<Amenity> amenities = List<Amenity>();
    amenities = json.map((Amenity) => Amenity.fromMap(Amenity)).toList();

    return AmenityList(
      amenities: amenities,
    );
  }
}
