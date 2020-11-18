//serarch suggestion data model to serialize JSON data
class SearchSuggestion {
  String id, name;
  SearchSuggestion({this.id, this.name});

  factory SearchSuggestion.fromJSON(Map<String, dynamic> json) {
    return SearchSuggestion(
      id: json["id"],
      name: json["name"],
    );
  }
}
