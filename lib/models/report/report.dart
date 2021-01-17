class Report {
  String description;
  int id;
  Report({this.description, this.id});

  factory Report.fromMap(Map<String, dynamic> json) => Report(
        description: json["description"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "description": description,
        " id": id,
      };
}
