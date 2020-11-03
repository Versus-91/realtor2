import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/district/district.dart';
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
  int bedCount;
  @observable
  District district = District();
  @observable
  List<int> amenities = new List<int>();
  @observable
  bool loading = false;
  PostRequest prevRequest;
  @action
  void setMinPrice(double value) {
    minPrice = value;
  }

  @action
  void setBedCount(int number) {
    bedCount = number;
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
  void setAmenity(int value) {
    amenities.contains(value) ? amenities.remove(value) : amenities.add(value);
  }

  @action
  void setPropertyTypeList(List<SelectedPropertyTypes> items) {
    selectedPropertyTypes = items;
  }

  @action
  void setDistrict(int value, String name) {
    district.name = name;
    district.id = value;
  }

  @action
  void setCategory(int value) {
    category = value;
  }

  @action
  PostRequest applyFilters() {
    var request = PostRequest(
        maxPrice: maxPrice?.floor(),
        minPrice: minPrice?.floor(),
        minArea: 0,
        maxArea: area?.floor(),
        district: district.id,
        category: category,
        types: propertyTypes,
        amenities: amenities);
    if (prevRequest == request) {
      request = null;
    } else {
      prevRequest = PostRequest(
          age: request.age,
          amenities: request.amenities.toList(),
          types: request.types.toList(),
          category: request.category,
          city: request.city,
          maxArea: request.maxArea,
          minArea: request.minArea,
          maxPrice: request.maxPrice,
          minPrice: request.minPrice,
          district: request.district);
    }
    return request;
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
