import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/data/network/rest_client.dart';
import 'package:boilerplate/models/amenity/amenity_list.dart';
import 'package:boilerplate/models/area/arealist.dart';
import 'package:boilerplate/models/authenticate/login.dart';
import 'package:boilerplate/models/category/categori_list.dart';
import 'package:boilerplate/models/city/city_list.dart';
import 'package:boilerplate/models/district/district_list.dart';
import 'package:boilerplate/models/notification/notification.dart';
import 'package:boilerplate/models/optionreport/option_list.dart';
import 'package:boilerplate/models/post/post.dart';
import 'package:boilerplate/models/post/post_list.dart';
import 'package:boilerplate/models/post/post_request.dart';
import 'package:boilerplate/models/report/report.dart';
import 'package:boilerplate/models/type/type_list.dart';
import 'package:boilerplate/models/user/changepassword.dart';
import 'package:boilerplate/models/user/changuserinfo.dart';
import 'package:boilerplate/models/user/user.dart';
import 'package:dio/dio.dart';

class PostApi {
  // dio instance
  final DioClient _dioClient;
  // rest-client instance
  final RestClient _restClient;
  var plusSign = '+';
  var baseAddress = Endpoints.baseUrl.replaceFirst("https://", "");

  // injecting dio instance
  PostApi(this._dioClient, this._restClient);

  /// Returns list of post in response
  Future<PostList> getPosts({PostRequest request}) async {
    try {
      Uri uri = Uri();
      if (request != null) {
        uri = Uri(
            scheme: 'https',
            host: baseAddress,
            path: '/api/services/app/Post/GetAll',
            queryParameters: request.toJson());
        print(uri);
      } else {
        uri = Uri.http(baseAddress, '/api/services/app/Post/GetAll');
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
            host: baseAddress,
            path: '/api/services/app/Post/GetUserPosts',
            queryParameters: request.toJson());
      } else {
        uri = Uri.http(baseAddress, '/api/services/app/Post/GetUserPosts');
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

  Future<DistrictList> getDistrictsByAreaId(int id) async {
    try {
      final res = await _dioClient
          .get(Endpoints.getDistrictsByAreaId + "?id=" + id.toString());
      return DistrictList.fromJson(res["result"]);
    } catch (e) {
      throw e;
    }
  }

  Future<AreaList> getAreasByCityId(int id) async {
    try {
      final res = await _dioClient
          .get(Endpoints.getAreasByCityId + "?cityid=" + id.toString());
      return AreaList.fromJson(res["result"]["items"]);
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

  Future<String> getNumber(String number) async {
    try {
      final res =
          await _dioClient.post(Endpoints.getUserNumber + "?userId=" + number);
      return res["result"];
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

  Future changeUserInfo(ChangeUserInfo changeUserInfo) async {
    try {
      final res = await _dioClient.put(Endpoints.updateUser,
          data: changeUserInfo.toMap());
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

  Future<AreaList> getAreas() async {
    try {
      final res = await _dioClient.get(Endpoints.getAreas);
      return AreaList.fromJson(res["result"]["items"]);
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
      final res = await _dioClient.post(Endpoints.createPosts,
          data: post.toMap(apiCall: true));
      return res["result"];
    } catch (e) {
      throw e;
    }
  }

  Future updatePost(Post post) async {
    try {
      final res = await _dioClient.put(Endpoints.updatePost,
          data: post.toMap(apiCall: true));
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

  Future addFavoriteInServer(int id) async {
    try {
      final res = await _dioClient.post(Endpoints.addFavorite, data: {
        "PostId": id,
      });
      return res;
    } catch (e) {
      throw e;
    }
  }

  Future removeFavoriteInServer(int id) async {
    try {
      final res = await _dioClient
          .delete(Endpoints.deleteFavorite + "?id=" + id.toString());
      return res;
    } catch (e) {
      throw e;
    }
  }

  Future getFavoriteInServer(int id) async {
    try {
      final res = await _dioClient
          .get(Endpoints.getFavorite + "?postId=" + id.toString());
      return res["result"];
    } catch (e) {
      throw e;
    }
  }

  Future<PostList> getFavorites(int page, {int size = 10}) async {
    try {
      int skipCount = (page - 1) * size;
      String uri =
          Endpoints.getAllFavorite + "?maxResultCount=" + size.toString();
      if (skipCount > 0) {
        uri += "&skipCount=" + skipCount.toString();
      }
      final res = await _dioClient.get(uri);
      return PostList.fromFavoriteJson(
          res["result"]["items"], res["result"]["totalCount"]);
    } catch (e) {
      throw e;
    }
  }

  Future removePostImage(int id) async {
    try {
      final res = await _dioClient
          .post(Endpoints.removePostImages + '/' + id.toString(), data: {
        "?id": id,
      });
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

  Future addEmail(String email) async {
    try {
      final res = await _dioClient
          .post(Endpoints.editeEmail, data: {"EmailAddress": email});
      return res["result"];
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

  Future createReport(Report report) async {
    try {
      final res =
          await _dioClient.post(Endpoints.createReport, data: report.toMap());
      return res["result"];
    } catch (e) {
      throw e;
    }
  }

  Future saveFirebaseId(Notification notification) async {
    try {
      final res = await _dioClient.post(Endpoints.saveFirebaseId,
          data: notification.toMap());
      return res["result"];
    } catch (e) {
      throw e;
    }
  }

  Future<OptionList> getOptionsReport() async {
    try {
      final res = await _dioClient.get(Endpoints.getoptionsReport);
      return OptionList.fromJson(res["result"]["items"]);
    } catch (e) {
      throw e;
    }
  }
}
