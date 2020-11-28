import 'dart:io';

import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/user/user.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';
part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  // repository instance
  Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _UserStore(Repository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<User> emptyUserResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<User> fetchUserFuture =
      ObservableFuture<User>(emptyUserResponse);

  @observable
  User user;
  @observable
  File avatarImage;
  @observable
  bool success = false;
   @observable
  bool avatarloading = false;
  @observable
  bool isLoggedIn = false;
  @computed
  bool get loading => fetchUserFuture.status == FutureStatus.pending;
  @action
  void setLoginState(bool val) {
    isLoggedIn = val;
    if (val == false) {
      user = null;
    }
  }

  @action
  void setAvatarImage(File img) {
    avatarImage = img;
  }

  // actions:-------------------------------------------------------------------
  @action
  Future getUser() async {
    final future = _repository.getUser();
    fetchUserFuture = ObservableFuture(future);

    future.then((item) {
      this.user = item;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }
   @action
  Future uploadAvatarImage(File imageAvatar) async {
    avatarloading = true;
    _repository.uploadAvatarImage(avatarImage).then((result) {
      avatarloading = false;
      success = true;
    }).catchError((error) {
      avatarloading = false;
    });
  } 
}
