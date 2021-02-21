class Image {
  int id;
  String path;
  Image({this.path, this.id});
  factory Image.fromJson(Map<String, dynamic> json) =>
      Image(path: json["path"], id: json["id"]);
  Map<String, dynamic> toMap() => {"path": path, "id": id};

  static List<Image> listFromJson(List<dynamic> json) {
    return json != null
        ? json.map((item) => Image.fromJson(item)).toList()
        : null;
  }
}
