import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/amenity/amenity_list.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'amenity_store.g.dart';

class AmenityStore = _AmenityStore with _$AmenityStore;

abstract class _AmenityStore with Store {
  // repository instance
  Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _AmenityStore(Repository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<AmenityList> emptyAmenityResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<AmenityList> fetchAmenitiesFuture =
      ObservableFuture<AmenityList>(emptyAmenityResponse);

  @observable
  AmenityList amenityList;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchAmenitiesFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getAmenities() async {
    final future = _repository.getAmenities();
    fetchAmenitiesFuture = ObservableFuture(future);

    return future.then((item) {
      this.amenityList = item;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
      throw error;
    });
  }
}
