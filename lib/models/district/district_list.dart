import 'district.dart';

class DistrictList {
  final List<District> districts;

  DistrictList({
    this.districts,
  });

  factory DistrictList.fromJson(List<dynamic> json) {
    List<District> districts = List<District>();
    districts = json.map((item) => District.fromMap(item)).toList();

    return DistrictList(
      districts: districts,
    );
  }
}
