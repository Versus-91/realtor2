
import 'package:boilerplate/models/area/area.dart';

class AreaList {
  final List<Area> areas;

  AreaList({
    this.areas,
  });

  factory AreaList.fromJson(List<dynamic> json) {
    List<Area> areas = List<Area>();
    areas = json.map((area) => Area.fromMap(area)).toList();

    return AreaList(
      areas: areas,
    );
  }
}
