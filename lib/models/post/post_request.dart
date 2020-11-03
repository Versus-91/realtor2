import 'package:collection/equality.dart';

class PostRequest {
  int minPrice;
  int maxPrice;
  int minArea;
  int maxArea;
  int district;
  int city;
  int category;
  List<int> types;
  List<int> amenities;
  int age;
  PostRequest(
      {this.minPrice,
      this.maxPrice,
      this.minArea,
      this.maxArea,
      this.district,
      this.city,
      this.category,
      this.types,
      this.age,
      this.amenities});
  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = new Map();
    result.addAll({"minPrice": minPrice.toString()});
    result.addAll({"maxPrice": minPrice.toString()});
    result.addAll({"category": category.toString()});
    if (district != null) {
      result.addAll({"district": district.toString()});
    }
    if (maxArea != null) {
      result.addAll({"maxArea": maxArea.toString()});
      result.addAll({"minArea": minArea.toString()});
    }
    result.addAll({"type": types.map((e) => e.toString()).toList()});
    result.addAll({"amenities": amenities.map((e) => e.toString()).toList()});
    return result;
  }

  Function eq = const ListEquality().equals;

  @override
  bool operator ==(other) {
    return (other is PostRequest) &&
        minPrice == other.minPrice &&
        maxPrice == other.maxPrice &&
        minArea == other.minArea &&
        maxArea == other.maxArea &&
        district == other.district &&
        city == other.city &&
        category == other.category &&
        eq(types, other.types) &&
        eq(amenities, other.amenities) &&
        age == other.age;
  }
}
