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

  // store for handling error messages
  final ErrorStore errorStore = ErrorStore();

  _FormStore(Repository repository) {
    _repository = repository;
    _setupValidations();
  }

  // disposers:-----------------------------------------------------------------
  List<ReactionDisposer> _disposers;

  void _setupValidations() {
    _disposers = [
      reaction((_) => userEmail, validateUserEmail),
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
  String userEmail = '';
  @observable
  String email;
  @observable
  String name = '';
  @observable
  String family = '';
  @observable
  String username = '';
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
  ObservableFuture<bool> _emailCheck = ObservableFuture.value(true);
  @computed
  bool get isUserCheckPending => _emailCheck.status == FutureStatus.pending;
  @observable
  ObservableFuture fetchFuture = ObservableFuture(emptyResponse);
  @observable
  String confirmPassword = '';

  @observable
  String location = '';
  @observable
  bool success = false;

  @observable
  bool loading = false;

  @computed
  bool get canLogin =>
      !formErrorStore.hasErrorsInLogin &&
      userEmail.isNotEmpty &&
      password.isNotEmpty;

  @computed
  bool get canRegister =>
      !formErrorStore.hasErrorsInRegister &&
      userEmail.isNotEmpty &&
      password.isNotEmpty &&
      confirmPassword.isNotEmpty;

  @computed
  bool get canForgetPassword =>
      !formErrorStore.hasErrorInForgotPassword && userEmail.isNotEmpty;

  // actions:-------------------------------------------------------------------
  @action
  void setUserLogin(String value) {
    userEmail = value;
  }

  @action
  void setPassword(String value) {
    password = value;
  }

  @action
  void setEmail(String value) {
    print(value);
    email = value;
  }

  @action
  void setConfrimPassword(String value) {
    confirmPassword = value;
  }

  @action
  void setName(String value) {
    name = value;
  }

  @action
  void setFamily(String value) {
    family = value;
  }

  @action
  void setUserName(String value) {
    username = value;
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
  void setConfirmPassword(String value) {
    confirmPassword = value;
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
  void validateUserEmail(String value) {
    if (value.isEmpty) {
      formErrorStore.userEmail = "ایمیل  یا نام کاربری را وارد کنید";
    } else {
      formErrorStore.userEmail = null;
    }
  }

  @action
  Future validateEmail(String email) async {
    if (isNull(email) || email.isEmpty || email.length < 5) {
      formErrorStore.email = 'Cannot be blank';
      return;
    }
    _emailCheck = ObservableFuture(_repository.checkUsername(email));
    _emailCheck.then((result) {
      print(result);
      if (result == true) {
        formErrorStore.email = null;
        return;
      }
      formErrorStore.email = 'حسابی با این ایمیل موجود است.';
    });
  }

  @action
  void validateNumber(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value == null) {
      formErrorStore.number = 'پرکردن شماره تماس الزامی است';
    } else if (!regExp.hasMatch(value)) {
      formErrorStore.number = ' شماره تماس نامعتبر است';
    } else {
      formErrorStore.number = null;
    }
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
  bool validateRegisterForm() {
    validateUserEmail(userEmail);
    validatePassword(password);
    validateName(name);
    validateFamily(family);
    validateNumber(number);
    return formErrorStore.hasErrorsInRegister ? false : true;
  }

  @action
  bool validateLoginForm() {
    validateUserEmail(userEmail);
    validatePassword(password);
    return formErrorStore.hasErrorsInLogin ? false : true;
  }
  // @action
  // void validateConfirmPassword(String value) {
  //   if (value.isEmpty) {
  //     formErrorStore.confirmPassword = "این گزینه باید پر شود";
  //   } else if (value != password) {
  //     formErrorStore.confirmPassword = "پسورد مطابقت ندارد";
  //   } else {
  //     formErrorStore.confirmPassword = null;
  //   }
  // }

  @action
  Future changePhoneNumber(String phoneNumber) async {
    final future = _repository.addPhoneNumber(phoneNumber);
    fetchFuture = ObservableFuture(future);

    return future;
  }

  @action
  Future register() async {
    if (validateRegisterForm() == true) {
      var user = User(
          email: email,
          name: name,
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
        email: userEmail, name: name, surname: family, phonenumber: number);
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
              userNameOrEmailAddress: userEmail.trim(),
              rememberClient: true))
          .then((result) {
        loading = false;
        success = true;
        return true;
      }).catchError((e) {
        loading = false;
        success = false;
        if (e != null) {
          if (e.toString().contains("وود ناموفقیت آمیز است"))
            errorStore.errorMessage =
                "نام کاربری و رمز خود را چک کنید خطا در ورود";
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

  void validateAll() {
    validatePassword(password);
    validateUserEmail(userEmail);
  }
}

class FormErrorStore = _FormErrorStore with _$FormErrorStore;

abstract class _FormErrorStore with Store {
  @observable
  String userEmail;
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
  String username;
  @observable
  String confirmPassword;

  @computed
  bool get hasErrorsInLogin => userEmail != null || password != null;

  @computed
  bool get hasErrorsInRegister =>
      userEmail != null ||
      email != null ||
      password != null ||
      name != null ||
      username != null ||
      family != null ||
      number != null ||
      confirmPassword != null;

  @computed
  bool get hasErrorInForgotPassword => userEmail != null;
}
