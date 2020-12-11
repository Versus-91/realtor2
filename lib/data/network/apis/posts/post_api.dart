import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/data/network/rest_client.dart';
import 'package:boilerplate/models/amenity/amenity_list.dart';
import 'package:boilerplate/models/authenticate/login.dart';
import 'package:boilerplate/models/category/categori_list.dart';
import 'package:boilerplate/models/city/city_list.dart';
import 'package:boilerplate/models/district/district_list.dart';
import 'package:boilerplate/models/post/post.dart';
import 'package:boilerplate/models/post/post_list.dart';
import 'package:boilerplate/models/post/post_request.dart';
import 'package:boilerplate/models/type/type_list.dart';
import 'package:boilerplate/models/user/changepassword.dart';
import 'package:boilerplate/models/user/user.dart';
import 'package:dio/dio.dart';

class PostApi {
  // dio instance
  final DioClient _dioClient;
  static const String baseUrl = 'hmahmudi-001-site2.gtempurl.com';
  // rest-client instance
  final RestClient _restClient;
  var plusSign = '+';
  // injecting dio instance
  PostApi(this._dioClient, this._restClient);

  /// Returns list of post in response
  Future<PostList> getPosts({PostRequest request}) async {
    try {
      Uri uri = Uri();
      if (request != null) {
        uri = Uri(
            scheme: 'http',
            host: baseUrl,
            path: '/api/services/app/Post/GetAll',
            queryParameters: request.toJson());
      } else {
        uri = Uri.http(baseUrl, '/api/services/app/Post/GetAll');
      }
      final res = await _dioClient.get(uri.toString());
      return PostList.fromJson(
          res["result"]["items"], res["result"]["totalCount"]);
    } catch (e) {
      throw e;
    }
  }

  /// Returns list of post in response
  Future<PostList> getUserPosts({PostRequest request}) async {
    try {
      Uri uri = Uri();
      if (request != null) {
        uri = Uri(
            scheme: 'http',
            host: baseUrl,
            path: '/api/services/app/Post/GetAll',
            queryParameters: request.toJson());
      } else {
        uri = Uri.http(baseUrl, '/api/services/app/Post/GetUserPosts');
      }
      final res = await _dioClient.get(uri.toString());

      return PostList.fromJson(
          res["result"]["items"], res["result"]["totalCount"]);
    } catch (e) {
      throw e;
    }
  }

  /// Returns list of post in response
  Future<DistrictList> getDistricts() async {
    try {
      final res = await _dioClient.get(Endpoints.getDistricts);
      return DistrictList.fromJson(res["result"]["items"]);
    } catch (e) {
      throw e;
    }
  }

  Future<DistrictList> getDistrictsByCityId(int id) async {
    try {
      final res = await _dioClient
          .get(Endpoints.getDistrictsById + "?id=" + id.toString());
      return DistrictList.fromJson(res["result"]);
    } catch (e) {
      throw e;
    }
  }

  Future<User> getUser() async {
    try {
      final res = await _dioClient.get(Endpoints.getuser);
      return User.fromJson(res["result"]);
    } catch (e) {
      throw e;
    }
  }

  Future createUser(User user) async {
    try {
      final res =
          await _dioClient.post(Endpoints.createUser, data: user.toMap());
      return res["result"];
    } catch (e) {
      throw e;
    }
  }

  Future updateUser(User user) async {
    try {
      final res =
          await _dioClient.put(Endpoints.updateUser, data: user.toMap());
      return res["result"];
    } catch (e) {
      throw e;
    }
  }

  Future changepassword(ChangePassword changepassword) async {
    try {
      final res = await _dioClient.put(Endpoints.changepassword,
          data: changepassword.toMap());
      return res["result"];
    } catch (e) {
      throw e;
    }
  }

  /// Returns list of post in response
  Future<CategoryList> getCategories() async {
    try {
      final res = await _dioClient.get(Endpoints.getCategories);
      return CategoryList.fromJson(res["result"]["items"]);
    } catch (e) {
      throw e;
    }
  }

  /// Returns list of post in response type
  Future<TypeList> getTypes() async {
    try {
      final res = await _dioClient.get(Endpoints.getTypes);
      return TypeList.fromJson(res["result"]["items"]);
    } catch (e) {
      throw e;
    }
  }

  Future<AmenityList> getAmenities() async {
    try {
      final res = await _dioClient.get(Endpoints.getAmenities);
      return AmenityList.fromJson(res["result"]["items"]);
    } catch (e) {
      throw e;
    }
  }

  /// Returns list of post in response
  Future<CityList> getCities() async {
    try {
      final res = await _dioClient.get(Endpoints.getCities);
      return CityList.fromJson(res["result"]["items"]);
    } catch (e) {
      throw e;
    }
  }

  Future login(Login login) async {
    try {
      final res =
          await _dioClient.post(Endpoints.authenticate, data: login.toJson());
      return res;
    } catch (e) {
      throw e;
    }
  }

  Future createPost(Post post) async {
    try {
      final res =
          await _dioClient.post(Endpoints.createPosts, data: post.toMap());
      return res["result"];
    } catch (e) {
      throw e;
    }
  }

  Future uploadImages(List<MultipartFile> files, String id) async {
    FormData imageFormData = FormData.fromMap({
      "files": files,
    });

    try {
      final res = await _dioClient.post(Endpoints.uploadImages + '/' + id,
          data: imageFormData);
      return res;
    } catch (e) {
      throw e;
    }
  }

/////
  Future uploadAvatarImage(MultipartFile avatarImage) async {
    FormData imageFormData = FormData.fromMap({
      "files": avatarImage,
    });

    try {
      final res = await _dioClient.post(Endpoints.uploadAvatarImage,
          data: imageFormData);
      return res;
    } catch (e) {
      throw e;
    }
  }

  Future addPhoneNumber(String phoneNumber) async {
    try {
      if (phoneNumber[0] != plusSign) {
        phoneNumber = plusSign + phoneNumber;
      }
      final res = await _dioClient
          .post(Endpoints.addphonenumber, data: {"phoneNumber": phoneNumber});
      return res;
    } catch (e) {
      throw e;
    }
  }

  Future verificationCodePhone(String phoneNumber, String code) async {
    try {
      if (phoneNumber[0] != plusSign) {
        phoneNumber = plusSign + phoneNumber;
      }
      final res = await _dioClient.post(Endpoints.verifyphonenumber,
          data: {"phoneNumber": phoneNumber, "code": code});
      return res;
    } catch (e) {
      throw e;
    }
  }

  Future checkPhoneNumber(String phonenumber) async {
    try {
      final res = await _dioClient
          .post(Endpoints.checkPhoneNumber, data: {"phoneNumber": phonenumber});
      return res["result"];
    } catch (e) {
      throw e;
    }
  }
 Future checkEmail(String email) async {
    try {
      final res = await _dioClient
          .post(Endpoints.checkEmail, data: {"emailAddress": email});
      return res["result"];
    } catch (e) {
      throw e;
    }
  }
  Future checkUsername(String username) async {
    try {
      final res = await _dioClient
          .post(Endpoints.checkUsername, data: {"username": username});
      return res["result"];
    } catch (e) {
      throw e;
    }
  }

  /// sample api call with default rest client
//  Future<PostsList> getPosts() {
//
//    return _restClient
//        .get(Endpoints.getPosts)
//        .then((dynamic res) => PostsList.fromJson(res))
//        .catchError((error) => throw NetworkException(message: error));
//  }

}
