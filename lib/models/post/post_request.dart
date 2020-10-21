class PostRequest {
  int minPrice;
  int maxPrice;
  int minArea;
  int maxArea;
  int district;
  int city;
  int category;
  List<int> types;
  int age;
  PostRequest({
    this.minPrice,
    this.maxPrice,
    this.minArea,
    this.maxArea,
    this.district,
    this.city,
    this.category,
    this.types,
    this.age,
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = new Map();
    result.addAll({"minPrice": minPrice.toString()});
    result.addAll({"maxPrice": minPrice.toString()});
    if (maxArea != null) {
      result.addAll({"maxArea": maxArea.toString()});
      result.addAll({"minArea": minArea.toString()});
    }
    result.addAll({"type": types.map((e) => e.toString()).toList()});

    return result;
  }
}
