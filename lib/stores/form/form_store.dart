import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/authenticate/login.dart';
import 'package:boilerplate/models/user/user.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:mobx/mobx.dart';
import 'package:validators/validators.dart';

part 'form_store.g.dart';

class FormStore = _FormStore with _$FormStore;

abstract class _FormStore with Store {
  // store for handling form errors
  final FormErrorStore formErrorStore = FormErrorStore();
  Repository _repository;
  final ErrorStore errorStore = ErrorStore();

  _FormStore(Repository repository) {
    _repository = repository;
    _setupValidations();
  }

  // disposers:-----------------------------------------------------------------
  List<ReactionDisposer> _disposers;

  void _setupValidations() {
    _disposers = [
      reaction((_) => userName, validateUserName),
      reaction((_) => usernameOrEmail, validateUsernameOrEmail),
      reaction((_) => email, validateEmail),
      reaction((_) => password, validatePassword),
      reaction((_) => name, validateName),
      reaction((_) => family, validateFamily),
      reaction((_) => number, validateNumber),
      // reaction((_) => confirmPassword, validateConfirmPassword)
    ];
  }

  // store variables:-----------------------------------------------------------
  @observable
  String userName = '';
  @observable
  String email;
  @observable
  String name = '';
  @observable
  String family = '';
  @observable
  String usernameOrEmail;
  @observable
  int userType = 0;
  @observable
  int typehome = 0;
  @observable
  String password = '';
  @observable
  String number;
  static ObservableFuture emptyResponse = ObservableFuture.value(null);
  @observable
  ObservableFuture<bool> _usernameCheck = ObservableFuture.value(true);
  @computed
  bool get isUserCheckPending => _usernameCheck.status == FutureStatus.pending;

  @observable
  ObservableFuture<bool> _emailCheck = ObservableFuture.value(true);
  @computed
  bool get isEmailPending => _emailCheck.status == FutureStatus.pending;

  @observable
  ObservableFuture<bool> _numberCheck = ObservableFuture.value(true);
  @computed
  bool get isNumberPending => _numberCheck.status == FutureStatus.pending;
  @observable
  ObservableFuture fetchFuture = ObservableFuture(emptyResponse);

  @observable
  String location = '';
  @observable
  bool success = false;

  @observable
  bool loading = false;

  @computed
  bool get canLogin =>
      !formErrorStore.hasErrorsInLogin &&
      userName.isNotEmpty &&
      password.isNotEmpty;

  @computed
  bool get canRegister =>
      !formErrorStore.hasErrorsInRegister &&
      userName.isNotEmpty &&
      password.isNotEmpty;
  @computed
  bool get canForgetPassword =>
      !formErrorStore.hasErrorInForgotPassword && userName.isNotEmpty;

  // actions:-------------------------------------------------------------------
  @action
  void setUserName(String value) {
    userName = value;
  }

  @action
  void setPassword(String value) {
    password = value;
  }

  @action
  void setEmail(String value) {
    email = value;
  }

  @action
  void setName(String value) {
    name = value;
  }

  @action
  void setUsernameOrEmail(String value) {
    usernameOrEmail = value;
  }

  @action
  void setFamily(String value) {
    family = value;
  }

  @action
  void setNumber(String value) {
    number = value;
  }

  @action
  void setAmlakName(String value) {
    name = value;
  }

  @action
  void setRegisterId(String value) {
    name = value;
  }

  @action
  void setlocation(String value) {
    location = value;
  }

  @action
  void setUserType(int value) {
    userType = value;
  }

  @action
  void setTypeHome(int value) {
    typehome = value;
  }

  @action
  void validateName(String value) {
    if (value.isEmpty) {
      formErrorStore.name = "نام را وارد کنید";
    } else {
      formErrorStore.name = null;
    }
  }

  @action
  void validateFamily(String value) {
    if (value.isEmpty) {
      formErrorStore.family = "نام خانوادگی را وارد کنید";
    } else {
      formErrorStore.family = null;
    }
  }

  @action
  Future validateUserName(String username) async {
    if (isNull(username) || username.isEmpty) {
      formErrorStore.username = 'نام کاربری را وارد کنید';
      return;
    } else if (username.length < 4) {
      formErrorStore.username = 'نام کاربری باید بیشتر از 4 کاراکتر باشد';
      return;
    }
    _usernameCheck = ObservableFuture(_repository.checkUsername(username));
    _usernameCheck.then((result) {
      if (result == true) {
        formErrorStore.username = null;
        return;
      }
      formErrorStore.username = 'حسابی با این نام موجود است.';
    });
  }

  @action
  Future validateEmail(String email) async {
    if (isNull(email) || email.isEmpty || email.length < 6) {
      formErrorStore.email = ' ایمیل را وارد کنید';
      return;
    }
    if (!isEmail(email)) {
      formErrorStore.email = 'ایمیل وارد شده صحیح نمی باشد';
      return;
    }
    _emailCheck = ObservableFuture(_repository.checkEmail(email));
    _emailCheck.then((result) {
      if (result == true) {
        formErrorStore.email = null;
        return;
      }
      formErrorStore.email = 'حسابی با این ایمیل موجود است.';
    });
  }

  @action
  Future validateNumber(String number) async {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (number == null) {
      formErrorStore.number = 'پرکردن شماره تماس الزامی است';
      return;
    } else if (!regExp.hasMatch(number)) {
      formErrorStore.number = ' شماره تماس نامعتبر است';
      return;
    } else {
      formErrorStore.number = null;
    }
    if (isNull(number) || number.isEmpty || number.length < 10) {
      formErrorStore.number = ' شماره همراه را وارد کنید';
      return;
    }
    _numberCheck = ObservableFuture(_repository.checkPhoneNumber(number));
    _numberCheck.then((result) {
      if (result == true) {
        formErrorStore.number = null;
        return;
      }
      formErrorStore.number = 'حسابی با این شماره موجود است.';
    });
  }

  @action
  void validatePassword(String value) {
    if (value.isEmpty) {
      formErrorStore.password = "پسوورد را وارد کنید";
    } else if (value.length < 6) {
      formErrorStore.password = "طول پسورد کمتر از 6 کاراکتر نباشد";
    } else {
      formErrorStore.password = null;
    }
  }

  @action
  void validateUsernameOrEmail(String value) {
    if (value == null || value.isEmpty) {
      formErrorStore.usernameOrEmail = "نام کاربری یا ایمیل باید وارد شود ";
    } else if (value.length < 4) {
      formErrorStore.usernameOrEmail =
          "نام کاربری یا ایمیل کمتر از 4 کاراکتر نباشد";
    } else {
      formErrorStore.usernameOrEmail = null;
    }
  }

  @action
  bool validateRegisterForm() {
    validatePassword(password);
    validateName(name);
    validateFamily(family);

    return formErrorStore.hasErrorsInRegister ? false : true;
  }

  @action
  bool validateLoginForm() {
    validateUsernameOrEmail(usernameOrEmail);
    validatePassword(password);
    return formErrorStore.hasErrorsInLogin ? false : true;
  }

  @action
  Future changePhoneNumber(String phoneNumber) async {
    loading = true;
    return _repository.addPhoneNumber(phoneNumber).then((value) {
      loading = false;
      return true;
    }).catchError((error) {
      loading = false;
      throw error;
    });
  }

  @action
  Future register() async {
    if (validateRegisterForm() == true) {
      var user = User(
          email: email,
          name: name,
          username: userName,
          password: password,
          surname: family,
          phonenumber: number);
      loading = true;
      return _repository.insertUser(user).then((result) {
        loading = false;
        success = true;
        return true;
      }).catchError((e) {
        loading = false;
        success = false;
        errorStore.errorMessage = e.toString();
        return false;
      });
    }
  }

  @action
  Future updeteUser() async {
    var user = User(
        email: email, name: userName, surname: family, phonenumber: number);
    loading = true;
    return _repository.updateUser(user).then((result) {
      loading = false;
      success = true;
      return true;
    }).catchError((e) {
      loading = false;
      success = false;
      errorStore.errorMessage = e.toString();
      return false;
    });
  }

  @action
  Future login() async {
    if (validateLoginForm() == true) {
      loading = true;
      return _repository
          .authenticate(Login(
              password: password,
              userNameOrEmailAddress: usernameOrEmail.trim(),
              rememberClient: true))
          .then((result) {
        loading = false;
        success = true;
        return true;
      }).catchError((e) {
        loading = false;
        success = false;
        if (e?.response != null) {
          if (e.response
              .toString()
              .toLowerCase()
              .contains("invalid user name")) {
            errorStore.errorMessage = "نام کاربری و رمز خود را چک کنید ";
          } else {
            errorStore.errorMessage = "خطا در ورود به حساب";
          }
        } else {
          errorStore.errorMessage = "اتصال اینترنت برقرار نیست مجددا تلاش کنید";
        }
        return false;
      });
    }
  }

  @action
  Future forgotPassword() async {
    loading = true;
  }

  @action
  Future logout() async {
    loading = true;
    return _repository.logOut().then((value) => loading = false);
  }

  // general methods:-----------------------------------------------------------
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}

class FormErrorStore = _FormErrorStore with _$FormErrorStore;

abstract class _FormErrorStore with Store {
  @observable
  String email;
  @observable
  String name;
  @observable
  String family;
  @observable
  String number;
  @observable
  String password;
  @observable
  String usernameOrEmail;

  @observable
  String username;

  @computed
  bool get hasErrorsInLogin => usernameOrEmail != null || password != null;

  @computed
  bool get hasErrorsInRegister {
    return email != null ||
        password != null ||
        name != null ||
        username != null ||
        family != null ||
        number != null;
  }

  @computed
  bool get hasErrorInForgotPassword => username != null;
}
