import 'dart:async';

import 'package:boilerplate/data/local/datasources/post/post_datasource.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
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
import 'package:sembast/sembast.dart';

import 'local/constants/db_constants.dart';
import 'local/datasources/city_datasource.dart';
import 'local/datasources/post/favorite_datasource.dart';
import 'local/datasources/search_datasource.dart';
import 'network/apis/posts/post_api.dart';

class Repository {
  // data source object
  final PostDataSource _postDataSource;

  final CityDataSource _cityDataSource;
  final FavoriteDataSource _favoriteDataSource;
  final SearchDataSource _searchDataSource;

  // api objects
  final PostApi _postApi;

  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;

  // constructor
  Repository(this._postApi, this._sharedPrefsHelper, this._postDataSource,
      this._favoriteDataSource, this._searchDataSource, this._cityDataSource);

  // Post: ---------------------------------------------------------------------
  Future<PostList> getPosts({PostRequest request}) async {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    return await _postApi.getPosts(request: request).then((postsList) {
      postsList.posts.forEach((post) {
        // _postDataSource.insert(post);
      });

      return postsList;
    }).catchError((error) => throw error);
  }

  Future<PostList> getUserPosts({PostRequest request}) async {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    return _postApi.getUserPosts(request: request).then((postsList) {
      return postsList;
    }).catchError((error) => throw error);
  }

  // city: ---------------------------------------------------------------------
  Future<CityList> getCities() async {
    return await _postApi.getCities().then((citiesList) {
      return citiesList;
    }).catchError((error) => throw error);
  }

  Future<AreaList> getAreas() async {
    return await _postApi.getAreas().then((areaList) {
      return areaList;
    }).catchError((error) => throw error);
  }

  // amenity: ---------------------------------------------------------------------
  Future<AmenityList> getAmenities() async {
    return await _postApi.getAmenities().then((amenitiesList) {
      return amenitiesList;
    }).catchError((error) => throw error);
  }

  Future<User> getUser() async {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    return await _postApi.getUser().then((user) {
      return user;
    }).catchError((error) => throw error);
  }

  Future<String> getNumber(String number) async {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    return await _postApi.getNumber(number).then((number) {
      return number;
    }).catchError((error) => throw error);
  }

//category------------------------------------------------------------------------
  Future<CategoryList> getCategories() async {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    return await _postApi.getCategories().then((categoryList) {
      return categoryList;
    }).catchError((error) => throw error);
  }

  Future<TypeList> getTypes() async {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    return await _postApi.getTypes().then((typesList) {
      return typesList;
    }).catchError((error) => throw error);
  }

  // submit login request: ---------------------------------------------------------------------
  Future authenticate(Login login) async {
    return await _postApi.login(login).then((result) async {
      await _sharedPrefsHelper.setAuthData(result);
      return result;
    }).catchError((error) {
      throw error;
    });
  }

  Future<bool> logOut() async {
    return await _sharedPrefsHelper.logOut();
  }

  Future getFavoritesList(int page, int size) async {
    return _postApi
        .getFavorites(page, size: size)
        .then((res) => res.posts)
        .catchError((err) => throw err);
  }

  Future getSearchesList() async {
    return await _searchDataSource.getSearchesFromDb();
  }

  Future saveSearch(PostRequest request) async {
    return await _searchDataSource.insert(request);
  }

  Future removeSearch(int id) async {
    await _searchDataSource.delete(id);
  }

  Future findFavoriteById(int id) async {
    return await _favoriteDataSource.findById(id);
  }

  Future addFavoriteInServer(int id) async {
    return _postApi.addFavoriteInServer(id).then((result) {
      return result;
    }).catchError((error) => throw error);
  }

  Future removeFavoriteInServer(int favoriteId) async {
    return _postApi.removeFavoriteInServer(favoriteId).then((result) {
      return result;
    }).catchError((error) => throw error);
  }

  Future getFavoriteInStatus(int postId) async {
    return _postApi.getFavoriteInServer(postId).then((result) {
      return result;
    }).catchError((error) => throw error);
  }

  Future<List<Post>> findPostById(int id) {
    //creating filter
    List<Filter> filters = List();

    //check to see if dataLogsType is not null
    if (id != null) {
      Filter dataLogTypeFilter = Filter.equals(DBConstants.FIELD_ID, id);
      filters.add(dataLogTypeFilter);
    }

    //making db call
    return _postDataSource
        .getAllSortedByFilter(filters: filters)
        .then((posts) => posts)
        .catchError((error) => throw error);
  }

  Future insert(Post post) {
    return _postApi.createPost(post).then((result) {
      return result;
    }).catchError((error) => throw error);
  }

  Future insertUser(User user) {
    return _postApi.createUser(user).then((result) {
      return result;
    }).catchError((error) => throw error);
  }

  Future updateUser(User user) {
    return _postApi.updateUser(user).then((result) {
      return result;
    }).catchError((error) => throw error);
  }

  Future updatePost(Post post) {
    return _postApi.updatePost(post).then((result) {
      return result;
    }).catchError((error) => throw error);
  }

  Future<int> update(Post post) => _postDataSource
      .update(post)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> delete(Post post) => _postDataSource
      .update(post)
      .then((id) => id)
      .catchError((error) => throw error);

  // Theme: --------------------------------------------------------------------
  Future<void> changeBrightnessToDark(bool value) =>
      _sharedPrefsHelper.changeBrightnessToDark(value);

  Future<bool> get isDarkMode => _sharedPrefsHelper.isDarkMode;
  Future<bool> get isLoggedIn => _sharedPrefsHelper.isLoggedIn;
  Future<int> get userId => _sharedPrefsHelper.userId;

  // Language: -----------------------------------------------------------------
  Future<void> changeLanguage(String value) =>
      _sharedPrefsHelper.changeLanguage(value);

  Future<String> get currentLanguage => _sharedPrefsHelper.currentLanguage;
  Future<DistrictList> getDistricts() async {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    return await _postApi.getDistricts().then((districtList) {
      return districtList;
    }).catchError((error) => error);
  }

  Future<DistrictList> getDistrictsByAreaId(int id) async {
    return await _postApi.getDistrictsByAreaId(id).then((districtList) {
      return districtList;
    }).catchError((error) => error);
  }

  Future<AreaList> getAreasByCityId(int id) async {
    return await _postApi.getAreasByCityId(id).then((areasList) {
      return areasList;
    }).catchError((error) => error);
  }

  Future<void> uploadImages(List<MultipartFile> files, String id) {
    return _postApi.uploadImages(files, id);
  }

  Future uploadAvatarImage(MultipartFile avatarImage) {
    return _postApi.uploadAvatarImage(avatarImage);
  }

  Future removePostImage(int id) {
    return _postApi.removePostImage(id);
  }

  Future<void> changepassword(ChangePassword passwords) {
    return _postApi.changepassword(passwords);
  }

  Future<void> changeUserInfo(ChangeUserInfo userInfo) {
    return _postApi.changeUserInfo(userInfo);
  }

  Future addPhoneNumber(String phonenumber) {
    return _postApi.addPhoneNumber(phonenumber);
  }

  Future addEmailAddress(String email) {
    return _postApi.addEmail(email);
  }

  Future verificationCodePhone(String phonenumber, String code) {
    return _postApi.verificationCodePhone(phonenumber, code);
  }

  Future checkPhoneNumber(String phonenumber) {
    return _postApi.checkPhoneNumber(phonenumber).then((result) {
      if (result == "available") {
        return true;
      }
      return false;
    }).catchError((err) => throw err);
    ;
  }

  Future checkEmail(String email) {
    return _postApi.checkEmail(email).then((result) {
      if (result == "available") {
        return true;
      }
      return false;
    }).catchError((err) => throw err);
    ;
  }

  Future checkUsername(String username) {
    return _postApi.checkUsername(username).then((result) {
      if (result == "available") {
        return true;
      }
      return false;
    }).catchError((err) => throw err);
  }

  Future insertReport(Report report) {
    return _postApi.createReport(report).then((result) {
      return result;
    }).catchError((error) => throw error);
  }

  Future<OptionList> getOptionsReport() async {
    return await _postApi.getOptionsReport().then((optionsList) {
      return optionsList;
    }).catchError((error) => throw error);
  }

  Future saveNotification(String token) async {
    int id = await this.userId;
    Notification notification = Notification(firebaseId: token, userId: id);
    return _postApi.saveFirebaseId(notification).then((result) {
      return result;
    }).catchError((error) => throw error);
  }
}
