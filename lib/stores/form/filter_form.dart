import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/post/post_request.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/ui/customlist/model/pop_list.dart';
import 'package:mobx/mobx.dart';
part 'filter_form.g.dart';

class FilterFormStore = _FilterFormStore with _$FilterFormStore;

abstract class _FilterFormStore with Store {
  // store for handling form errors

  // store for handling error messages
  final ErrorStore errorStore = ErrorStore();
  Repository _repository;
  _FilterFormStore(Repository repository) {
    _repository = repository;
    _setupValidations();
  }

  // disposers:-----------------------------------------------------------------
  List<ReactionDisposer> _disposers;

  void _setupValidations() {
    _disposers = [
      // reaction((_) => title, validateString),
    ];
  }

  // store variables:-----------------------------------------------------------
  @observable
  double minPrice = 0;
  @observable
  List<SelectedPropertyTypes> selectedPropertyTypes =
      new List<SelectedPropertyTypes>();
  @observable
  double maxPrice = 0;
  @observable
  List<int> propertyTypes = [];
  @observable
  double area;
  @observable
  int category;
  @observable
  int district;
  @observable
  List<int> types = new List<int>();
  @observable
  bool loading = false;

  @action
  void setMinPrice(double value) {
    minPrice = value;
  }

  @action
  void setMaxPrice(double value) {
    maxPrice = value;
  }

  @action
  void setArea(double value) {
    area = value;
  }

  @action
  void setPropertyType(int value) {
    if (!types.contains(value)) {
      types.add(value);
    }
  }

  @action
  void setPropertyTypeList(List<SelectedPropertyTypes> items) {
    selectedPropertyTypes = items;
  }

  @action
  void setDistrict(int value) {
    district = value;
  }

  @action
  PostRequest applyFilters() {
    return PostRequest(
        maxPrice: maxPrice?.floor(),
        minPrice: minPrice?.floor(),
        minArea: 0,
        maxArea: area?.floor(),
        district: district,
        category: category,
        types: types);
  }

  @action
  void setpropertyTypes(int value) {
    propertyTypes.contains(value)
        ? propertyTypes.remove(value)
        : propertyTypes.add(value);
  }

  // general methods:-----------------------------------------------------------
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
