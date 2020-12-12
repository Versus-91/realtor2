// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FormStore on _FormStore, Store {
  Computed<bool> _$isUserCheckPendingComputed;

  @override
  bool get isUserCheckPending => (_$isUserCheckPendingComputed ??=
          Computed<bool>(() => super.isUserCheckPending,
              name: '_FormStore.isUserCheckPending'))
      .value;
  Computed<bool> _$isEmailPendingComputed;

  @override
  bool get isEmailPending =>
      (_$isEmailPendingComputed ??= Computed<bool>(() => super.isEmailPending,
              name: '_FormStore.isEmailPending'))
          .value;
  Computed<bool> _$isNumberPendingComputed;

  @override
  bool get isNumberPending =>
      (_$isNumberPendingComputed ??= Computed<bool>(() => super.isNumberPending,
              name: '_FormStore.isNumberPending'))
          .value;
  Computed<bool> _$canLoginComputed;

  @override
  bool get canLogin => (_$canLoginComputed ??=
          Computed<bool>(() => super.canLogin, name: '_FormStore.canLogin'))
      .value;
  Computed<bool> _$canRegisterComputed;

  @override
  bool get canRegister =>
      (_$canRegisterComputed ??= Computed<bool>(() => super.canRegister,
              name: '_FormStore.canRegister'))
          .value;
  Computed<bool> _$canForgetPasswordComputed;

  @override
  bool get canForgetPassword => (_$canForgetPasswordComputed ??= Computed<bool>(
          () => super.canForgetPassword,
          name: '_FormStore.canForgetPassword'))
      .value;

  final _$userNameAtom = Atom(name: '_FormStore.userName');

  @override
  String get userName {
    _$userNameAtom.reportRead();
    return super.userName;
  }

  @override
  set userName(String value) {
    _$userNameAtom.reportWrite(value, super.userName, () {
      super.userName = value;
    });
  }

  final _$emailAtom = Atom(name: '_FormStore.email');

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  final _$nameAtom = Atom(name: '_FormStore.name');

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  final _$familyAtom = Atom(name: '_FormStore.family');

  @override
  String get family {
    _$familyAtom.reportRead();
    return super.family;
  }

  @override
  set family(String value) {
    _$familyAtom.reportWrite(value, super.family, () {
      super.family = value;
    });
  }

  final _$usernameOrEmailAtom = Atom(name: '_FormStore.usernameOrEmail');

  @override
  String get usernameOrEmail {
    _$usernameOrEmailAtom.reportRead();
    return super.usernameOrEmail;
  }

  @override
  set usernameOrEmail(String value) {
    _$usernameOrEmailAtom.reportWrite(value, super.usernameOrEmail, () {
      super.usernameOrEmail = value;
    });
  }

  final _$userTypeAtom = Atom(name: '_FormStore.userType');

  @override
  int get userType {
    _$userTypeAtom.reportRead();
    return super.userType;
  }

  @override
  set userType(int value) {
    _$userTypeAtom.reportWrite(value, super.userType, () {
      super.userType = value;
    });
  }

  final _$typehomeAtom = Atom(name: '_FormStore.typehome');

  @override
  int get typehome {
    _$typehomeAtom.reportRead();
    return super.typehome;
  }

  @override
  set typehome(int value) {
    _$typehomeAtom.reportWrite(value, super.typehome, () {
      super.typehome = value;
    });
  }

  final _$passwordAtom = Atom(name: '_FormStore.password');

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  final _$numberAtom = Atom(name: '_FormStore.number');

  @override
  String get number {
    _$numberAtom.reportRead();
    return super.number;
  }

  @override
  set number(String value) {
    _$numberAtom.reportWrite(value, super.number, () {
      super.number = value;
    });
  }

  final _$_usernameCheckAtom = Atom(name: '_FormStore._usernameCheck');

  @override
  ObservableFuture<bool> get _usernameCheck {
    _$_usernameCheckAtom.reportRead();
    return super._usernameCheck;
  }

  @override
  set _usernameCheck(ObservableFuture<bool> value) {
    _$_usernameCheckAtom.reportWrite(value, super._usernameCheck, () {
      super._usernameCheck = value;
    });
  }

  final _$_emailCheckAtom = Atom(name: '_FormStore._emailCheck');

  @override
  ObservableFuture<bool> get _emailCheck {
    _$_emailCheckAtom.reportRead();
    return super._emailCheck;
  }

  @override
  set _emailCheck(ObservableFuture<bool> value) {
    _$_emailCheckAtom.reportWrite(value, super._emailCheck, () {
      super._emailCheck = value;
    });
  }

  final _$_numberCheckAtom = Atom(name: '_FormStore._numberCheck');

  @override
  ObservableFuture<bool> get _numberCheck {
    _$_numberCheckAtom.reportRead();
    return super._numberCheck;
  }

  @override
  set _numberCheck(ObservableFuture<bool> value) {
    _$_numberCheckAtom.reportWrite(value, super._numberCheck, () {
      super._numberCheck = value;
    });
  }

  final _$fetchFutureAtom = Atom(name: '_FormStore.fetchFuture');

  @override
  ObservableFuture<dynamic> get fetchFuture {
    _$fetchFutureAtom.reportRead();
    return super.fetchFuture;
  }

  @override
  set fetchFuture(ObservableFuture<dynamic> value) {
    _$fetchFutureAtom.reportWrite(value, super.fetchFuture, () {
      super.fetchFuture = value;
    });
  }

  final _$locationAtom = Atom(name: '_FormStore.location');

  @override
  String get location {
    _$locationAtom.reportRead();
    return super.location;
  }

  @override
  set location(String value) {
    _$locationAtom.reportWrite(value, super.location, () {
      super.location = value;
    });
  }

  final _$successAtom = Atom(name: '_FormStore.success');

  @override
  bool get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  final _$loadingAtom = Atom(name: '_FormStore.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$validateUserNameAsyncAction =
      AsyncAction('_FormStore.validateUserName');

  @override
  Future<dynamic> validateUserName(String username) {
    return _$validateUserNameAsyncAction
        .run(() => super.validateUserName(username));
  }

  final _$validateEmailAsyncAction = AsyncAction('_FormStore.validateEmail');

  @override
  Future<dynamic> validateEmail(String email) {
    return _$validateEmailAsyncAction.run(() => super.validateEmail(email));
  }

  final _$validateNumberAsyncAction = AsyncAction('_FormStore.validateNumber');

  @override
  Future<dynamic> validateNumber(String number) {
    return _$validateNumberAsyncAction.run(() => super.validateNumber(number));
  }

  final _$changePhoneNumberAsyncAction =
      AsyncAction('_FormStore.changePhoneNumber');

  @override
  Future<dynamic> changePhoneNumber(String phoneNumber) {
    return _$changePhoneNumberAsyncAction
        .run(() => super.changePhoneNumber(phoneNumber));
  }

  final _$registerAsyncAction = AsyncAction('_FormStore.register');

  @override
  Future<dynamic> register() {
    return _$registerAsyncAction.run(() => super.register());
  }

  final _$updeteUserAsyncAction = AsyncAction('_FormStore.updeteUser');

  @override
  Future<dynamic> updeteUser() {
    return _$updeteUserAsyncAction.run(() => super.updeteUser());
  }

  final _$loginAsyncAction = AsyncAction('_FormStore.login');

  @override
  Future<dynamic> login() {
    return _$loginAsyncAction.run(() => super.login());
  }

  final _$forgotPasswordAsyncAction = AsyncAction('_FormStore.forgotPassword');

  @override
  Future<dynamic> forgotPassword() {
    return _$forgotPasswordAsyncAction.run(() => super.forgotPassword());
  }

  final _$logoutAsyncAction = AsyncAction('_FormStore.logout');

  @override
  Future<dynamic> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  final _$_FormStoreActionController = ActionController(name: '_FormStore');

  @override
  void setUserName(String value) {
    final _$actionInfo = _$_FormStoreActionController.startAction(
        name: '_FormStore.setUserName');
    try {
      return super.setUserName(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassword(String value) {
    final _$actionInfo = _$_FormStoreActionController.startAction(
        name: '_FormStore.setPassword');
    try {
      return super.setPassword(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(String value) {
    final _$actionInfo =
        _$_FormStoreActionController.startAction(name: '_FormStore.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setName(String value) {
    final _$actionInfo =
        _$_FormStoreActionController.startAction(name: '_FormStore.setName');
    try {
      return super.setName(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUsernameOrEmail(String value) {
    final _$actionInfo = _$_FormStoreActionController.startAction(
        name: '_FormStore.setUsernameOrEmail');
    try {
      return super.setUsernameOrEmail(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFamily(String value) {
    final _$actionInfo =
        _$_FormStoreActionController.startAction(name: '_FormStore.setFamily');
    try {
      return super.setFamily(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNumber(String value) {
    final _$actionInfo =
        _$_FormStoreActionController.startAction(name: '_FormStore.setNumber');
    try {
      return super.setNumber(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAmlakName(String value) {
    final _$actionInfo = _$_FormStoreActionController.startAction(
        name: '_FormStore.setAmlakName');
    try {
      return super.setAmlakName(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRegisterId(String value) {
    final _$actionInfo = _$_FormStoreActionController.startAction(
        name: '_FormStore.setRegisterId');
    try {
      return super.setRegisterId(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setlocation(String value) {
    final _$actionInfo = _$_FormStoreActionController.startAction(
        name: '_FormStore.setlocation');
    try {
      return super.setlocation(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserType(int value) {
    final _$actionInfo = _$_FormStoreActionController.startAction(
        name: '_FormStore.setUserType');
    try {
      return super.setUserType(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTypeHome(int value) {
    final _$actionInfo = _$_FormStoreActionController.startAction(
        name: '_FormStore.setTypeHome');
    try {
      return super.setTypeHome(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validateName(String value) {
    final _$actionInfo = _$_FormStoreActionController.startAction(
        name: '_FormStore.validateName');
    try {
      return super.validateName(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validateFamily(String value) {
    final _$actionInfo = _$_FormStoreActionController.startAction(
        name: '_FormStore.validateFamily');
    try {
      return super.validateFamily(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validatePassword(String value) {
    final _$actionInfo = _$_FormStoreActionController.startAction(
        name: '_FormStore.validatePassword');
    try {
      return super.validatePassword(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validateUsernameOrEmail(String value) {
    final _$actionInfo = _$_FormStoreActionController.startAction(
        name: '_FormStore.validateUsernameOrEmail');
    try {
      return super.validateUsernameOrEmail(value);
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool validateRegisterForm() {
    final _$actionInfo = _$_FormStoreActionController.startAction(
        name: '_FormStore.validateRegisterForm');
    try {
      return super.validateRegisterForm();
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool validateLoginForm() {
    final _$actionInfo = _$_FormStoreActionController.startAction(
        name: '_FormStore.validateLoginForm');
    try {
      return super.validateLoginForm();
    } finally {
      _$_FormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
userName: ${userName},
email: ${email},
name: ${name},
family: ${family},
usernameOrEmail: ${usernameOrEmail},
userType: ${userType},
typehome: ${typehome},
password: ${password},
number: ${number},
fetchFuture: ${fetchFuture},
location: ${location},
success: ${success},
loading: ${loading},
isUserCheckPending: ${isUserCheckPending},
isEmailPending: ${isEmailPending},
isNumberPending: ${isNumberPending},
canLogin: ${canLogin},
canRegister: ${canRegister},
canForgetPassword: ${canForgetPassword}
    ''';
  }
}

mixin _$FormErrorStore on _FormErrorStore, Store {
  Computed<bool> _$hasErrorsInLoginComputed;

  @override
  bool get hasErrorsInLogin => (_$hasErrorsInLoginComputed ??= Computed<bool>(
          () => super.hasErrorsInLogin,
          name: '_FormErrorStore.hasErrorsInLogin'))
      .value;
  Computed<bool> _$hasErrorsInRegisterComputed;

  @override
  bool get hasErrorsInRegister => (_$hasErrorsInRegisterComputed ??=
          Computed<bool>(() => super.hasErrorsInRegister,
              name: '_FormErrorStore.hasErrorsInRegister'))
      .value;
  Computed<bool> _$hasErrorInForgotPasswordComputed;

  @override
  bool get hasErrorInForgotPassword => (_$hasErrorInForgotPasswordComputed ??=
          Computed<bool>(() => super.hasErrorInForgotPassword,
              name: '_FormErrorStore.hasErrorInForgotPassword'))
      .value;

  final _$emailAtom = Atom(name: '_FormErrorStore.email');

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  final _$nameAtom = Atom(name: '_FormErrorStore.name');

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  final _$familyAtom = Atom(name: '_FormErrorStore.family');

  @override
  String get family {
    _$familyAtom.reportRead();
    return super.family;
  }

  @override
  set family(String value) {
    _$familyAtom.reportWrite(value, super.family, () {
      super.family = value;
    });
  }

  final _$numberAtom = Atom(name: '_FormErrorStore.number');

  @override
  String get number {
    _$numberAtom.reportRead();
    return super.number;
  }

  @override
  set number(String value) {
    _$numberAtom.reportWrite(value, super.number, () {
      super.number = value;
    });
  }

  final _$passwordAtom = Atom(name: '_FormErrorStore.password');

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  final _$usernameOrEmailAtom = Atom(name: '_FormErrorStore.usernameOrEmail');

  @override
  String get usernameOrEmail {
    _$usernameOrEmailAtom.reportRead();
    return super.usernameOrEmail;
  }

  @override
  set usernameOrEmail(String value) {
    _$usernameOrEmailAtom.reportWrite(value, super.usernameOrEmail, () {
      super.usernameOrEmail = value;
    });
  }

  final _$usernameAtom = Atom(name: '_FormErrorStore.username');

  @override
  String get username {
    _$usernameAtom.reportRead();
    return super.username;
  }

  @override
  set username(String value) {
    _$usernameAtom.reportWrite(value, super.username, () {
      super.username = value;
    });
  }

  @override
  String toString() {
    return '''
email: ${email},
name: ${name},
family: ${family},
number: ${number},
password: ${password},
usernameOrEmail: ${usernameOrEmail},
username: ${username},
hasErrorsInLogin: ${hasErrorsInLogin},
hasErrorsInRegister: ${hasErrorsInRegister},
hasErrorInForgotPassword: ${hasErrorInForgotPassword}
    ''';
  }
}
