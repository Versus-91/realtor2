import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/city/city_list.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'city_store.g.dart';

class CityStore = _CityStore with _$CityStore;

abstract class _CityStore with Store {
  // repository instance
  Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _CityStore(Repository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<CityList> emptyCityResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<CityList> fetchCitiesFuture =
      ObservableFuture<CityList>(emptyCityResponse);

  @observable
  CityList cityList;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchCitiesFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getCities() async {
    final future = _repository.getCities();
    fetchCitiesFuture = ObservableFuture(future);

    return future.then((item) {
      errorStore.errorMessage = '';
      success = true;
      this.cityList = item;
    }).catchError((error) {
      success = false;
      errorStore.errorMessage = DioErrorUtil.handleError(error);
      throw error;
    });
  }
}
