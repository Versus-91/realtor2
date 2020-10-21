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

  final _$fetchUserFutureAtom = Atom(name: '_UserStore.fetchUserFuture');

  @override
  ObservableFuture<User> get fetchUserFuture {
    _$fetchUserFutureAtom.reportRead();
    return super.fetchUserFuture;
  }

  @override
  set fetchUserFuture(ObservableFuture<User> value) {
    _$fetchUserFutureAtom.reportWrite(value, super.fetchUserFuture, () {
      super.fetchUserFuture = value;
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
  String toString() {
    return '''
fetchUserFuture: ${fetchUserFuture},
user: ${user},
success: ${success},
isLoggedIn: ${isLoggedIn},
loading: ${loading}
    ''';
  }
}
