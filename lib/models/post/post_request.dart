import 'package:collection/equality.dart';
import 'package:uuid/uuid.dart';

class PostRequest {
  int id;
  int page;
  int pageSize;
  int minPrice;
  int maxPrice;
  int minRentPrice;
  int maxRentPrice;
  int minDepositPrice;
  int maxDepositPrice;
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
      this.page = 1,
      this.pageSize = 10,
      this.districtName,
      this.categoryName,
      this.cityName,
      this.minPrice,
      this.maxPrice,
      this.minRentPrice,
      this.maxRentPrice,
      this.minDepositPrice,
      this.maxDepositPrice,
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
    result.addAll({"maxPrice": maxPrice.toString()});

    result.addAll({"minRentPrice": minRentPrice.toString()});
    result.addAll({"maxRentPrice": maxRentPrice.toString()});

    result.addAll({"minDepositPrice": minDepositPrice.toString()});
    result.addAll({"maxDepositPrice": maxDepositPrice.toString()});
    result.addAll({"category": category.toString()});
    result.addAll({"maxResultCount": pageSize.toString()});
    result.addAll({"skipCount": ((page - 1) * pageSize).toString()});

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
    result.addAll({"maxPrice": maxPrice.toString()});
    result.addAll({"minRentPrice": minRentPrice.toString()});
    result.addAll({"maxRentPrice": maxRentPrice.toString()});
    result.addAll({"minDepositPrice": minDepositPrice.toString()});
    result.addAll({"maxDepositPrice": maxDepositPrice.toString()});
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
        maxRentPrice: int.tryParse(json["maxRentPrice" ?? ""]),
        minRentPrice: int.tryParse(json["minRentPrice"] ?? ""),
        maxDepositPrice: int.tryParse(json["maxDepositPrice" ?? ""]),
        minDepositPrice: int.tryParse(json["minDepositPrice"] ?? ""),
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
      maxRentPrice: int.tryParse(json["maxRentPrice" ?? ""]),
      minRentPrice: int.tryParse(json["minRentPrice"] ?? ""),
      maxDepositPrice: int.tryParse(json["maxDepositPrice" ?? ""]),
      minDepositPrice: int.tryParse(json["minDepositPrice"] ?? ""),
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
        minRentPrice == other.minRentPrice &&
        maxRentPrice == other.maxRentPrice &&
        minDepositPrice == other.minDepositPrice &&
        maxDepositPrice == other.maxDepositPrice &&
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
      minRentPrice ^
      maxRentPrice ^
      minDepositPrice ^
      maxDepositPrice ^
      minArea ^
      maxArea ^
      district ^
      category ^
      bedCount ^
      age;
}
