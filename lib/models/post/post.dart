import 'package:boilerplate/models/district/district.dart';
import 'package:boilerplate/models/image/image.dart';
import 'package:boilerplate/models/category/category.dart';

class Post {
  String title;
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
  double deopsit;
  double rent;
  double price;
  District district;
  Category category;
  List<Image> images;

  Post(
      {this.title,
      this.age,
      this.categoryId,
      this.description,
      this.isFeatured,
      this.area,
      this.bedroom,
      this.districtId,
      this.typeId,
      this.latitude = 34.5553,
      this.longitude = 69.2075,
      this.creationTime,
      this.id,
      this.deopsit,
      this.rent,
      this.price,
      this.district,
      this.category,
      this.images,
      this.isVerified});

  factory Post.fromMap(Map<String, dynamic> json) => Post(
      title: json["title"],
      age: json["age"],
      categoryId: json["categoryId"],
      description: json["description"],
      isFeatured: json["isFeatured"],
      isVerified: json["isVerified"],
      area: json["area"],
      bedroom: json["bedroom"],
      districtId: json["districtId"],
      typeId: json["typeId"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      creationTime: json["creationTime"],
      id: json["id"],
      deopsit: json["deopsit"],
      rent: json["rent"],
      price: json["price"],
      district: District.fromMap(json["district"]),
      category: Category.fromMap(json["category"]),
      images: Image.listFromJson(json["images"]));

  Map<String, dynamic> toMap() => {
        "title": 'title',
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
        "creationTime": creationTime,
        "id": id,
        "deopsit": deopsit,
        "rent": rent,
        "price": price,
        "district": district.toMap(),
        "category": category.toMap(),
        "images": images.map((e) => toMapImage(e)).toList()
      };
  Map<String, dynamic> toMapImage(Image img) => {"path": img.path};
}
