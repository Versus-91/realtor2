class Image {
  String path;
  Image({this.path});
  factory Image.fromJson(Map<String, dynamic> json) =>
      Image(path: json["path"]);
  Map<String, dynamic> toMap() => {"path": path};

  static List<Image> listFromJson(List<dynamic> json) {
    return json.map((item) => Image.fromJson(item)).toList();
  }
}
