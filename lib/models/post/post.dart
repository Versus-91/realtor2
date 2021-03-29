import 'package:boilerplate/models/amenity/amenity.dart';
import 'package:boilerplate/models/category/category.dart';
import 'package:boilerplate/models/district/district.dart';
import 'package:boilerplate/models/image/image.dart';

class Post {
  int favId;
  int categoryId;
  String description;
  bool isFeatured;
  bool isVerified;
  int area;
  int bedroom;
  int districtId;
  int typeId;
  double latitude;
  int age;
  double longitude;
  String creationTime;
  int id;
  int realEstateId;
  double price;
  District district;
  Category category;
  int creatorUserId;
  List<Image> images;
  List<Amenity> amenities;
  Post(
      {this.age,
      this.favId,
      this.realEstateId,
      this.creatorUserId,
      this.categoryId,
      this.description,
      this.isFeatured,
      this.area,
      this.bedroom,
      this.districtId,
      this.typeId,
      this.latitude,
      this.longitude,
      this.creationTime,
      this.id,
      this.price,
      this.district,
      this.category,
      this.images,
      this.isVerified,
      this.amenities});

  factory Post.fromMap(Map<String, dynamic> json) {
    try {
      return Post(
          age: json["age"],
          creatorUserId: json["creatorUserId"],
          categoryId: json["categoryId"],
          description: json["description"],
          isFeatured: json["isFeatured"],
          isVerified: json["isVerified"],
          realEstateId: json["realEstateId"],
          bedroom: json["bedroom"],
          area: json["area"],
          districtId: json["districtId"],
          typeId: json["typeId"],
          latitude: json["latitude"],
          longitude: json["longitude"],
          creationTime: json["creationTime"],
          id: json["id"],
          price: json["price"],
          district: District.fromMap(json["district"]),
          category: Category.fromMap(json["category"]),
          amenities: Amenity.listFromJson(json["amenities"]),
          images: Image.listFromJson(json["images"]));
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> toMap({bool apiCall = false}) {
    return {
      "title": "title",
      "age": age,
      "categoryId": categoryId,
      "description": description,
      "isFeatured": isFeatured,
      "area": area,
      "bedroom": bedroom,
      "districtId": districtId,
      "typeId": typeId,
      "latitude": latitude,
      "longitude": longitude,
      "id": id,
      if (price != null) ...{
        "price": price,
      },
      if (realEstateId != null) ...{
        "realEstateId": realEstateId,
      },
      if (district != null) ...{"district": district.toMap()},
      if (category != null) ...{
        "category": category.toMap(),
      },
      if (images != null) ...{
        "images": images.map((e) => toMapImage(e)).toList()
      },
      if (amenities != null) ...{
        if (apiCall == true) ...{
          "amenities": amenities.map((amenity) => amenity.id).toList()
        } else ...{
          "amenities": amenities.map((amenity) => amenity.toMap()).toList()
        }
      },
    };
  }

  Map<String, dynamic> toMapImage(Image img) => {"path": img.path};
}
