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
  bool success = false;
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
}
