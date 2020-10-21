class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "http://hmahmudi-001-site2.gtempurl.com";

  // receiveTimeout
  static const int receiveTimeout = 50000;

  // connectTimeout
  static const int connectionTimeout = 30000;

  // post endpoints
  static const String getPosts = baseUrl + "/api/services/app/Post/GetAll";
  static const String createPosts = baseUrl + "/api/services/app/Post/create";
  //city endpoints
  static const String getCities = baseUrl + "/api/services/app/City/GetAll";
  //district endpoints
  static const String getDistricts =
      baseUrl + "/api/services/app/District/GetAll";
  static const String authenticate = baseUrl + "/api/TokenAuth/Authenticate";
  //Category endpoints
  static const String getCategories =
      baseUrl + "/api/services/app/category/GetAll";
  static const String getuser = baseUrl + "/api/services/app/account/user";
  static const String createUser =
      baseUrl + "/api/services/app/account/register";

  //Category endpoints
  static const String getTypes = baseUrl + "/api/services/app/type/GetAll";
  static const String uploadImages = baseUrl + "/stream/upload";
}
