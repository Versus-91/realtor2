import 'package:boilerplate/models/city/city.dart';

class CityList {
  final List<City> cities;

  CityList({
    this.cities,
  });

  factory CityList.fromJson(List<dynamic> json) {
    List<City> cities = List<City>();
    cities = json.map((city) => City.fromMap(city)).toList();

    return CityList(
      cities: cities,
    );
  }
}
