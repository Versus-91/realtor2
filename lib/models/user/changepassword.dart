class ChangePassword {
  String oldPassword;
  String newPassword;
  String confirmPassword;

  ChangePassword({this.oldPassword, this.newPassword, this.confirmPassword});
  Map<String, dynamic> toMap() => {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      };
}
