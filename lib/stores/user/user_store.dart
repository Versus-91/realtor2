import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/user/changepassword.dart';
import 'package:boilerplate/models/user/user.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:dio/dio.dart';
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
  static ObservableFuture emptyResponse = ObservableFuture.value(null);

  @observable
  ObservableFuture fetchFuture = ObservableFuture(emptyResponse);

  @observable
  User user;

  @observable
  bool success = false;
  @observable
  String newPassword = " ";
  @observable
  String confirmPassword = " ";
  @observable
  String oldPassword = " ";
  @observable
  bool avatarloading = false;
  @observable
  bool isLoggedIn = false;
  @computed
  bool get loading => fetchFuture.status == FutureStatus.pending;
  @action
  void setLoginState(bool val) {
    isLoggedIn = val;
    if (val == false) {
      user = null;
    }
  }

  @action
  void setNewPassword(String val) {
    newPassword = val;
  }

  @action
  void setConfirmPassword(String val) {
    confirmPassword = val;
  }

  @action
  void setOldPassword(String val) {
    oldPassword = val;
  }

  // actions:-------------------------------------------------------------------
  @action
  Future getUser() async {
    final future = _repository.getUser();
    fetchFuture = ObservableFuture(future);

    future.then((item) {
      this.user = item;
      // print(item.avatar);
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  Future changePhoneNumber(String phoneNumber) async {
    final future = _repository.addPhoneNumber(phoneNumber);
    fetchFuture = ObservableFuture(future);

    return future;
  }

  @action
  Future changePass(ChangePassword passwords) async {
    final future = _repository.changepassword(passwords);
    fetchFuture = ObservableFuture(future);

    return future;
  }



  @action
  Future uploadAvatarImage(MultipartFile imageAvatar) async {
    avatarloading = true;
    _repository.uploadAvatarImage(imageAvatar).then((result) {
      avatarloading = false;
      success = true;
      return true;
    }).catchError((error) {
      avatarloading = false;
      return false;
    });
  }

  Future<bool> changePassword(ChangePassword passwords) async {
    return _repository.changepassword(passwords).then((result) {
      return true;
    }).catchError((error) {
      return false;
    });
  }
}
/////
