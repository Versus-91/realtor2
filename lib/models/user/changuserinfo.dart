class ChangeUserInfo {
  String newName;
  String newUserName;

  ChangeUserInfo({this.newName, this.newUserName});
  Map<String, dynamic> toMap() => {
        "newName": newName,
        "newUserName": newUserName,
      };
}
