class Notification {
  String firebaseId;
  int userId;
  Notification({this.firebaseId, this.userId});

  Map<String, dynamic> toMap() => {"userId": userId, "firebaseId": firebaseId};
}
