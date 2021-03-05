import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/type/type_list.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';

import 'package:mobx/mobx.dart';
part 'type_store.g.dart';

class TypeStore = _TypeStore with _$TypeStore;

abstract class _TypeStore with Store {
  // repository instance
  Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _TypeStore(Repository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<TypeList> emptyTypeResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<TypeList> fetchTypeFuture =
      ObservableFuture<TypeList>(emptyTypeResponse);

  @observable
  TypeList typeList;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchTypeFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getTypes() async {
    final future = _repository.getTypes();
    fetchTypeFuture = ObservableFuture(future);

    return future.then((item) {
      this.typeList = item;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
      throw error;
    });
  }
}
