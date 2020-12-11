class User {
  String username;

  String name;
  String surname;
  String password;
  String email;
  String avatar;
  String phonenumber;
  User(
      {this.name,
      this.surname,
      this.password,
      this.email,
      this.username,
      this.phonenumber,
      this.avatar});
  factory User.fromJson(Map<String, dynamic> json) => User(
      email: json["emailAddress"],
      name: json["name"],
      surname: json["surname"],
      phonenumber: json["phoneNumber"],
      avatar: json["avatar"],
      username: json["userName"]);
  Map<String, dynamic> toMap() => {
        "emailAddress": email,
        "name": name,
        "userName": username,
        "surname": surname,
        "password": password,
        "phoneNumber": phonenumber,
        "avatar": avatar,
      };
}
