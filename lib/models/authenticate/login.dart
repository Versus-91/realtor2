class Login {
  String userNameOrEmailAddress;
  String password;
  bool rememberClient;
  Login({this.userNameOrEmailAddress, this.password, this.rememberClient});

  Map<String, dynamic> toJson() {
    return {
      "password": this.password,
      "userNameOrEmailAddress": userNameOrEmailAddress,
      "rememberClient": rememberClient
    };
  }
}
