import 'package:boilerplate/models/type/type.dart';

class TypeList {
  final List<Type> types;

  TypeList({
    this.types,
  });

  factory TypeList.fromJson(List<dynamic> json) {
    List<Type> types = List<Type>();
    types = json.map((type) => Type.fromMap(type)).toList();

    return TypeList(
      types: types,
    );
  }
}
