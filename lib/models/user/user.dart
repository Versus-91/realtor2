import 'dart:io';

class User {
  String name;
  String surname;
  String password;
  String email;
  String avatar;
  String phonenumber;
  User({this.name, this.surname, this.password, this.email, this.phonenumber,this.avatar});
  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json["emailAddress"],
        name: json["name"],
        surname: json["surname"],
        phonenumber: json["phoneNumber"],
          avatar: json["avatar"],
      );
  Map<String, dynamic> toMap() => {
        "emailAddress": email,
        "name": name,
        "userName": email,
        "surname": surname,
        "password": password,
        "phoneNumber": phonenumber,
        "avatar": avatar,
      };
}
