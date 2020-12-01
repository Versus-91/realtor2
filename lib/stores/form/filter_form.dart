import 'package:boilerplate/models/category/category.dart';
import 'package:boilerplate/models/city/city.dart';
import 'package:boilerplate/models/district/district.dart';
import 'package:boilerplate/models/post/post_request.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/ui/search/model/pop_list.dart';
import 'package:mobx/mobx.dart';
part 'filter_form.g.dart';

class FilterFormStore = _FilterFormStore with _$FilterFormStore;

abstract class _FilterFormStore with Store {
  // store for handling form errors

  // store for handling error messages
  final ErrorStore errorStore = ErrorStore();
  _FilterFormStore() {
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
  double minRentPrice = 0;
  @observable
  double minDepositPrice = 0;
  @observable
  List<SelectedPropertyTypes> selectedPropertyTypes =
      new List<SelectedPropertyTypes>();
  @observable
  double maxPrice = 0;
  @observable
  double maxRentPrice = 0;
  @observable
  double maxDepositPrice = 0;

  @observable
  double area;
  @observable
  Category category = Category();
  @observable
  int bedCount;
  @observable
  District district = District();
  @observable
  City city = City();
  @observable
  List<int> amenities = new List<int>();
  PostRequest prevRequest;
  @action
  void setMinPrice(double value) {
    minPrice = value;
  }

  @action
  void setMinRentPrice(double value) {
    minRentPrice = value;
  }

  @action
  void setMinDepositPrice(double value) {
    minDepositPrice = value;
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
  void setMaxRentPrice(double value) {
    maxRentPrice = value;
  }

  @action
  void setMaxDepositPrice(double value) {
    maxDepositPrice = value;
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
  void setCity(int value, String name) {
    city.name = name;
    city.id = value;
  }

  @action
  void setCategory(int id, String name) {
    category.id = id;
    category.name = name;
  }

  @action
  PostRequest applyFilters({bool paginate = false}) {
    var request = PostRequest(
        maxPrice: maxPrice?.floor(),
        minPrice: minPrice?.floor(),
        maxRentPrice: maxRentPrice?.floor(),
        minRentPrice: minRentPrice?.floor(),
        maxDepositPrice: maxDepositPrice?.floor(),
        minDepositPrice: minDepositPrice?.floor(),
        minArea: 0,
        maxArea: area?.floor(),
        district: district.id,
        districtName: district.name,
        city: city.id,
        cityName: city.name,
        bedCount: bedCount,
        category: category.id,
        categoryName: category.name,
        types: selectedPropertyTypes.map((element) {
          if (element.isSelected == true) {
            return element.id;
          }
        }).toList(),
        amenities: amenities);
    // if (paginate) {
    //   return request;
    // }
    // if (prevRequest == request) {
    //   request = null;
    // } else {
    //   prevRequest = PostRequest(
    //       age: request.age,
    //       amenities: request.amenities.toList(),
    //       types: request.types.toList(),
    //       category: request.category,
    //       city: request.city,
    //       maxArea: request.maxArea,
    //       minArea: request.minArea,
    //       maxPrice: request.maxPrice,
    //       minPrice: request.minPrice,
    //       maxRentPrice: request.maxRentPrice,
    //       minRentPrice: request.minRentPrice,
    //       maxDepositPrice: request.maxDepositPrice,
    //       minDepositPrice: request.minDepositPrice,
    //       district: request.district);
    // }
    return request;
  }

  @action
  void resetForm() {
    category = null;
    city = null;
    district = null;
    bedCount = null;
    amenities = null;
    area = null;
  }

  // general methods:-----------------------------------------------------------
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
