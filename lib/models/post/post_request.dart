import 'package:collection/equality.dart';
import 'package:uuid/uuid.dart';

class PostRequest {
  int id;
  int minPrice;
  int maxPrice;
  int minArea;
  int maxArea;
  int district;
  String districtName;
  int city;
  String cityName;
  int category;
  String categoryName;
  List<int> types;
  List<int> amenities;
  int age;
  int bedCount;
  PostRequest(
      {this.id,
      this.districtName,
      this.categoryName,
      this.cityName,
      this.minPrice,
      this.maxPrice,
      this.minArea,
      this.maxArea,
      this.district,
      this.city,
      this.category,
      this.types,
      this.bedCount,
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
    if (bedCount != null) {
      result.addAll({"beds": bedCount.toString()});
    }
    if (city != null) {
      result.addAll({"city": city.toString()});
    }
    if (maxArea != null) {
      result.addAll({"maxArea": maxArea.toString()});
      result.addAll({"minArea": minArea.toString()});
    }
    if (types != null) {
      types?.removeWhere((element) => element == null);
      result.addAll({"type": types.map((e) => e.toString()).toList()});
    }
    if (amenities != null) {
      result.addAll({"amenities": amenities.map((e) => e.toString()).toList()});
    }
    return result;
  }

  Map<String, dynamic> toJsonLocalStore() {
    Map<String, dynamic> result = new Map();
    result.addAll({"id": id});
    result.addAll({"minPrice": minPrice.toString()});
    result.addAll({"maxPrice": minPrice.toString()});
    result.addAll({"category": category.toString()});
    result.addAll({"categoryName": categoryName});
    result.addAll({"cityName": cityName});
    result.addAll({"districtName": districtName});

    if (district != null) {
      result.addAll({"district": district.toString()});
    }
    if (bedCount != null) {
      result.addAll({"beds": bedCount.toString()});
    }
    if (city != null) {
      result.addAll({"city": city.toString()});
    }
    if (maxArea != null) {
      result.addAll({"maxArea": maxArea.toString()});
      result.addAll({"minArea": minArea.toString()});
    }
    if (types != null) {
      types.removeWhere((element) => element == null);
      result.addAll({"type": types.map((e) => e.toString()).toList()});
    }

    if (amenities != null) {
      result.addAll({"amenities": amenities.map((e) => e.toString()).toList()});
    }
    return result;
  }

  factory PostRequest.fromMap(Map<String, dynamic> json) => PostRequest(
        maxArea: int.tryParse(json["maxArea"] ?? ""),
        minArea: int.tryParse(json["minArea"] ?? ""),
        maxPrice: int.tryParse(json["maxPrice" ?? ""]),
        minPrice: int.tryParse(json["minPrice"] ?? ""),
        age: int.tryParse(json["age"] ?? ""),
        category: int.tryParse(json["category"] ?? ""),
        district: int.tryParse(json["district"] ?? ""),
        city: int.tryParse(json["city"] ?? ""),
        bedCount: int.tryParse(json["beds"] ?? ""),
        id: json["id"],
        // amenities: json["amenities"],
      );
  factory PostRequest.fromMapLocalStore(Map<String, dynamic> json) {
    return PostRequest(
      maxArea: int.tryParse(json["maxArea"] ?? ""),
      minArea: int.tryParse(json["minArea"] ?? ""),
      maxPrice: int.tryParse(json["maxPrice" ?? ""]),
      minPrice: int.tryParse(json["minPrice"] ?? ""),
      age: int.tryParse(json["age"] ?? ""),
      category: int.tryParse(json["category"] ?? ""),
      district: int.tryParse(json["district"] ?? ""),
      city: int.tryParse(json["city"] ?? ""),
      bedCount: int.tryParse(json["beds"] ?? ""),
      categoryName: json["categoryName"],
      districtName: json["cityName"],
      cityName: json["districtName"],
      // amenities: json["amenities"],
    );
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
        bedCount == other.bedCount &&
        age == other.age;
  }

  @override
  int get hashCode =>
      minPrice ^
      maxPrice ^
      minArea ^
      maxArea ^
      district ^
      category ^
      bedCount ^
      age;
}
