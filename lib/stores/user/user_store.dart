import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/user/changepassword.dart';
import 'package:boilerplate/models/user/changuserinfo.dart';
import 'package:boilerplate/models/user/user.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  final UserErrorStore userErrorStore = UserErrorStore();

  // repository instance
  Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _UserStore(Repository repository) {
    this._repository = repository;
    _setupValidations();
  }

  List<ReactionDisposer> _disposers;

  void _setupValidations() {
    _disposers = [
      reaction((_) => newPassword, validateNewPassword),
      reaction((_) => confirmPassword, validateConfrimPassword),

      // reaction((_) => confirmPassword, validateConfirmPassword)
    ];
  }

  // store variables:-----------------------------------------------------------
  static ObservableFuture emptyResponse = ObservableFuture.value(null);

  @observable
  ObservableFuture fetchFuture = ObservableFuture(emptyResponse);

  @observable
  User user;

  @observable
  bool success = false;
  @observable
  String newPassword = "";
  @observable
  String confirmPassword = "";
  @observable
  String oldPassword = "";
  @observable
  bool avatarloading = false;
  @observable
  bool isLoggedIn;
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
  void validateNewPassword(String value) {
    bool hasUppercase = value.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = value.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = value.contains(new RegExp(r'[a-z]'));
    if (value.isEmpty) {
      userErrorStore.newPassword = "پسوورد را وارد کنید";
    } else if (value.length < 8) {
      userErrorStore.newPassword = "طول پسورد کمتر از 8 کاراکتر نباشد";
    } else if (hasUppercase == false ||
        hasDigits == false ||
        hasLowercase == false) {
      userErrorStore.newPassword =
          "رمز باید شامل حداقل یک حرف کوچک و یک حرف بزرگ انگلیسی و عدد باشد";
    } else {
      userErrorStore.newPassword = null;
    }
  }

  @action
  void validateConfrimPassword(String value) {
    if (confirmPassword.length >= 8) {
      if (newPassword != confirmPassword) {
        userErrorStore.confrimPassword = "رمز و تکرار رمز یکسان نیست";
      } else {
        userErrorStore.confrimPassword = null;
      }
    } else {
      userErrorStore.confrimPassword = null;
    }
  }

  @action
  Future getUser() async {
    final future = _repository.getUser();
    fetchFuture = ObservableFuture(future);
    future.then((item) {
      this.user = item;
    }).catchError((error) {
      errorStore.statusCode = error?.response?.statusCode;
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
  Future changeEmailAdderss(String email) async {
    final future = _repository.addEmailAddress(email);
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
  Future changeUserInfo(ChangeUserInfo userInfo) async {
    final future = _repository.changeUserInfo(userInfo);
    fetchFuture = ObservableFuture(future);

    return future;
  }

  @action
  Future uploadAvatarImage(MultipartFile imageAvatar) async {
    avatarloading = true;
    return _repository.uploadAvatarImage(imageAvatar).then((result) {
      avatarloading = false;
      success = true;
      return true;
    }).catchError((error) {
      avatarloading = false;
      throw error;
    });
  }

  Future<bool> changePassword(ChangePassword passwords) async {
    return _repository.changepassword(passwords).then((result) {
      return true;
    }).catchError((error) {
      return false;
    });
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}

class UserErrorStore = _UserErrorStore with _$UserErrorStore;

abstract class _UserErrorStore with Store {
  @observable
  String oldPassword;
  @observable
  String newPassword;
  @observable
  String confrimPassword;
  @observable
  String name;

  @computed
  bool get hasErrorsChangeInfo =>
      name != null ||
      oldPassword != null ||
      newPassword != null ||
      confrimPassword != null;
}
