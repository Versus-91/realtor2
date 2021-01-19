class Report {
  String description;
  int optionId;
  int postId;
  Report({this.description, this.optionId, this.postId});

  factory Report.fromMap(Map<String, dynamic> json) => Report(
        description: json["description"],
        optionId: json["optionId"],
        postId: json["postId"],
      );

  Map<String, dynamic> toMap() => {
        "description": description,
        " optionId": optionId,
        " postId": postId,
      };
}
