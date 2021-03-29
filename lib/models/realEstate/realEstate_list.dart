import 'package:boilerplate/models/realEstate/realEstate.dart';

class RealstateList {
  final List<RealEstate> realStates;

  RealstateList({
    this.realStates,
  });

  factory RealstateList.fromJson(List<dynamic> json) {
    List<RealEstate> realStates = List<RealEstate>();
    realStates =
        json.map((realEstate) => RealEstate.fromMap(realEstate)).toList();

    return RealstateList(
      realStates: realStates,
    );
  }
}
