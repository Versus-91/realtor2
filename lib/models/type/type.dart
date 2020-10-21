class Type {
  String name;
  int creatorUserId;
  int id;
  Type({this.name, this.creatorUserId, this.id});

  factory Type.fromMap(Map<String, dynamic> json) => Type(
        name: json["name"],
        creatorUserId: json["creatorUserId"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "creatorUserId": creatorUserId,
        " id": id,
      };
}
