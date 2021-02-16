import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/area/arealist.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'area_store.g.dart';

class AreaStore = _AreaStore with _$AreaStore;

abstract class _AreaStore with Store {
  // repository instance
  Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _AreaStore(Repository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<AreaList> emptyAreaResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<AreaList> fetchAreasFuture =
      ObservableFuture<AreaList>(emptyAreaResponse);

  @observable
  AreaList areaList;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchAreasFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getAreas() async {
    final future = _repository.getAreas();
    fetchAreasFuture = ObservableFuture(future);

    future.then((item) {
      errorStore.errorMessage = '';
      success = true;
      this.areaList = item;
    }).catchError((error) {
      success = false;
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  Future getAreasByCityid(int id) async {
    final future = _repository.getAreasByCityId(id);
    fetchAreasFuture = ObservableFuture(future);

    future.then((item) {
      this.areaList = item;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }
}
