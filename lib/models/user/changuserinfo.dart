class ChangeUserInfo {
  String name;
  String surname;
  String emailAddress;
  String phonenumber;
  int id;

  ChangeUserInfo(
      {this.name, this.emailAddress, this.id, this.surname, this.phonenumber});
  Map<String, dynamic> toMap() => {
        "name": name,
        "emailAddress": "userexample@gmail.com",
        "id": id,
        "surname": surname,
        "phonenumber": phonenumber,
      };
}
