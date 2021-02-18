import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/district/district_list.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'district_store.g.dart';

class DistrictStore = _DistrictStore with _$DistrictStore;

abstract class _DistrictStore with Store {
  // repository instance
  Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _DistrictStore(Repository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<DistrictList> emptyDistrictResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<DistrictList> fetchDistrictFuture =
      ObservableFuture<DistrictList>(emptyDistrictResponse);

  @observable
  DistrictList districtList;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchDistrictFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getDistricts() async {
    final future = _repository.getDistricts();
    fetchDistrictFuture = ObservableFuture(future);

    future.then((item) {
      this.districtList = item;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  Future getDistrictsByAreaid(int id) async {
    final future = _repository.getDistrictsByAreaId(id);
    fetchDistrictFuture = ObservableFuture(future);

    future.then((item) {
      this.districtList = item;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }
}
