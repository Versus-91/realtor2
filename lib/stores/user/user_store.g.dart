// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserStore on _UserStore, Store {
  Computed<bool> _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: '_UserStore.loading'))
      .value;

  final _$fetchFutureAtom = Atom(name: '_UserStore.fetchFuture');

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

  final _$userAtom = Atom(name: '_UserStore.user');

  @override
  User get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  final _$successAtom = Atom(name: '_UserStore.success');

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

  final _$newPasswordAtom = Atom(name: '_UserStore.newPassword');

  @override
  String get newPassword {
    _$newPasswordAtom.reportRead();
    return super.newPassword;
  }

  @override
  set newPassword(String value) {
    _$newPasswordAtom.reportWrite(value, super.newPassword, () {
      super.newPassword = value;
    });
  }

  final _$confirmPasswordAtom = Atom(name: '_UserStore.confirmPassword');

  @override
  String get confirmPassword {
    _$confirmPasswordAtom.reportRead();
    return super.confirmPassword;
  }

  @override
  set confirmPassword(String value) {
    _$confirmPasswordAtom.reportWrite(value, super.confirmPassword, () {
      super.confirmPassword = value;
    });
  }

  final _$oldPasswordAtom = Atom(name: '_UserStore.oldPassword');

  @override
  String get oldPassword {
    _$oldPasswordAtom.reportRead();
    return super.oldPassword;
  }

  @override
  set oldPassword(String value) {
    _$oldPasswordAtom.reportWrite(value, super.oldPassword, () {
      super.oldPassword = value;
    });
  }

  final _$avatarloadingAtom = Atom(name: '_UserStore.avatarloading');

  @override
  bool get avatarloading {
    _$avatarloadingAtom.reportRead();
    return super.avatarloading;
  }

  @override
  set avatarloading(bool value) {
    _$avatarloadingAtom.reportWrite(value, super.avatarloading, () {
      super.avatarloading = value;
    });
  }

  final _$isLoggedInAtom = Atom(name: '_UserStore.isLoggedIn');

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  final _$getUserAsyncAction = AsyncAction('_UserStore.getUser');

  @override
  Future<dynamic> getUser() {
    return _$getUserAsyncAction.run(() => super.getUser());
  }

  final _$changePhoneNumberAsyncAction =
      AsyncAction('_UserStore.changePhoneNumber');

  @override
  Future<dynamic> changePhoneNumber(String phoneNumber) {
    return _$changePhoneNumberAsyncAction
        .run(() => super.changePhoneNumber(phoneNumber));
  }

  final _$changeEmailAdderssAsyncAction =
      AsyncAction('_UserStore.changeEmailAdderss');

  @override
  Future<dynamic> changeEmailAdderss(String email) {
    return _$changeEmailAdderssAsyncAction
        .run(() => super.changeEmailAdderss(email));
  }

  final _$changePassAsyncAction = AsyncAction('_UserStore.changePass');

  @override
  Future<dynamic> changePass(ChangePassword passwords) {
    return _$changePassAsyncAction.run(() => super.changePass(passwords));
  }

  final _$changeUserInfoAsyncAction = AsyncAction('_UserStore.changeUserInfo');

  @override
  Future<dynamic> changeUserInfo(ChangeUserInfo userInfo) {
    return _$changeUserInfoAsyncAction
        .run(() => super.changeUserInfo(userInfo));
  }

  final _$uploadAvatarImageAsyncAction =
      AsyncAction('_UserStore.uploadAvatarImage');

  @override
  Future<dynamic> uploadAvatarImage(MultipartFile imageAvatar) {
    return _$uploadAvatarImageAsyncAction
        .run(() => super.uploadAvatarImage(imageAvatar));
  }

  final _$_UserStoreActionController = ActionController(name: '_UserStore');

  @override
  void setLoginState(bool val) {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.setLoginState');
    try {
      return super.setLoginState(val);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNewPassword(String val) {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.setNewPassword');
    try {
      return super.setNewPassword(val);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setConfirmPassword(String val) {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.setConfirmPassword');
    try {
      return super.setConfirmPassword(val);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setOldPassword(String val) {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.setOldPassword');
    try {
      return super.setOldPassword(val);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validateNewPassword(String value) {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.validateNewPassword');
    try {
      return super.validateNewPassword(value);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validateConfrimPassword(String value) {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.validateConfrimPassword');
    try {
      return super.validateConfrimPassword(value);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchFuture: ${fetchFuture},
user: ${user},
success: ${success},
newPassword: ${newPassword},
confirmPassword: ${confirmPassword},
oldPassword: ${oldPassword},
avatarloading: ${avatarloading},
isLoggedIn: ${isLoggedIn},
loading: ${loading}
    ''';
  }
}

mixin _$UserErrorStore on _UserErrorStore, Store {
  Computed<bool> _$hasErrorsChangeInfoComputed;

  @override
  bool get hasErrorsChangeInfo => (_$hasErrorsChangeInfoComputed ??=
          Computed<bool>(() => super.hasErrorsChangeInfo,
              name: '_UserErrorStore.hasErrorsChangeInfo'))
      .value;

  final _$oldPasswordAtom = Atom(name: '_UserErrorStore.oldPassword');

  @override
  String get oldPassword {
    _$oldPasswordAtom.reportRead();
    return super.oldPassword;
  }

  @override
  set oldPassword(String value) {
    _$oldPasswordAtom.reportWrite(value, super.oldPassword, () {
      super.oldPassword = value;
    });
  }

  final _$newPasswordAtom = Atom(name: '_UserErrorStore.newPassword');

  @override
  String get newPassword {
    _$newPasswordAtom.reportRead();
    return super.newPassword;
  }

  @override
  set newPassword(String value) {
    _$newPasswordAtom.reportWrite(value, super.newPassword, () {
      super.newPassword = value;
    });
  }

  final _$confrimPasswordAtom = Atom(name: '_UserErrorStore.confrimPassword');

  @override
  String get confrimPassword {
    _$confrimPasswordAtom.reportRead();
    return super.confrimPassword;
  }

  @override
  set confrimPassword(String value) {
    _$confrimPasswordAtom.reportWrite(value, super.confrimPassword, () {
      super.confrimPassword = value;
    });
  }

  final _$nameAtom = Atom(name: '_UserErrorStore.name');

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

  @override
  String toString() {
    return '''
oldPassword: ${oldPassword},
newPassword: ${newPassword},
confrimPassword: ${confrimPassword},
name: ${name},
hasErrorsChangeInfo: ${hasErrorsChangeInfo}
    ''';
  }
}
