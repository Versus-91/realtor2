class ChangeUserInfo {
  String newName;
  String newFamily;
  String email;

  ChangeUserInfo({this.newName, this.newFamily, this.email});
  Map<String, dynamic> toMap() => {
        "newName": newName,
        "newFamily": newFamily,
        "email": email,
      };
}
