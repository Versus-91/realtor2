import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/category/categori_list.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'category_store.g.dart';

class CategoryStore = _CategoryStore with _$CategoryStore;

abstract class _CategoryStore with Store {
  // repository instance
  Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _CategoryStore(Repository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<CategoryList> emptyCategoryResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<CategoryList> fetchcategoriesFuture =
      ObservableFuture<CategoryList>(emptyCategoryResponse);

  @observable
  CategoryList categoryList;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchcategoriesFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getCategories() async {
    final future = _repository.getCategories();
    fetchcategoriesFuture = ObservableFuture(future);

    return future.then((item) {
      this.categoryList = item;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
      throw error;
    });
  }
}
