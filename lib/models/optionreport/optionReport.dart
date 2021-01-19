class OptionReport {
  String name;
  int id;
  OptionReport({this.id, this.name});
  factory OptionReport.fromMap(Map<String, dynamic> json) => OptionReport(
        name: json["name"],
        id: json["id"],
      );
}
