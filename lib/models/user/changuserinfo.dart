class ChangeUserInfo {
  String name;
  String surname;
  String emailAddress;
  int id;

  ChangeUserInfo({this.name, this.emailAddress, this.id, this.surname});
  Map<String, dynamic> toMap() => {
        "name": name,
        "emailAddress": "userexample@gmail.com",
        "id": id,
        "surname": surname,
      };
}
