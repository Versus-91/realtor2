class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "http://www.kamyabhouse.com";
  static const int receiveTimeout = 5000;
  static const int connectionTimeout = 3000;
  static const String getAmenities =
      baseUrl + "/api/services/app/Amenity/GetAll";
  static const String getPosts = baseUrl + "/api/services/app/Post/GetAll";

  static const String createPosts = baseUrl + "/api/services/app/Post/create";
  static const String saveFirebaseId =
      baseUrl + "/api/services/app/notification/create";
  static const String getCities = baseUrl + "/api/services/app/City/GetAll";
  static const String getDistricts =
      baseUrl + "/api/services/app/District/GetAll";
  static const String getDistrictsById =
      baseUrl + "/api/services/app/District/GetByCityId";
  static const String authenticate = baseUrl + "/api/TokenAuth/Authenticate";
  static const String getCategories =
      baseUrl + "/api/services/app/category/GetAll";
  static const String getuser = baseUrl + "/api/services/app/account/user";
  static const String createUser =
      baseUrl + "/api/services/app/account/register";
  static const String updateUser = baseUrl + "/api/services/app/account/update";
  static const String getTypes = baseUrl + "/api/services/app/type/GetAll";
  static const String uploadImages = baseUrl + "/upload";
  static const String uploadAvatarImage = baseUrl + "/upload/avatar";
  static const String changepassword =
      baseUrl + "/api/services/app/account/changePassword";
  static const String addphonenumber = baseUrl + "/api/account/addphonenumber";
  static const String verifyphonenumber =
      baseUrl + "/api/account/verifyphonenumber";
  static const String checkUsername =
      baseUrl + "/api/services/app/account/checkUsername";
  static const String createReport =
      baseUrl + "/api/services/app/report/create";
  static const String getoptionsReport =
      baseUrl + "/api/services/app/reportoption/GetAll";
  static const String checkPhoneNumber =
      baseUrl + "/api/services/app/account/checkPhoneNumber";
  static const String checkEmail =
      baseUrl + "/api/services/app/account/checkEmail";
  static const String editeEmail =
      baseUrl + "/api/services/app/account/checkEmail";
  static const String updatePost = baseUrl + "/api/services/app/Post/update";
}
