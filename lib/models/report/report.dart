class Report {
  String description;
  int reportOptionId;
  int postId;
  Report({this.description, this.reportOptionId, this.postId});

  factory Report.fromMap(Map<String, dynamic> json) => Report(
        description: json["description"],
        reportOptionId: json["reportOptionId"],
        postId: json["postId"],
      );

  Map<String, dynamic> toMap() => {
        "description": description,
        "reportOptionId": reportOptionId,
        "postId": postId,
      };
}
