

class ChangePassword {
  String oldPassword;
  String newPassword;
  String confirmPassword;

  Map<String, dynamic> toMap() => {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
       
      };
}
