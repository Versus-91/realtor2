import 'package:boilerplate/models/area/area.dart';
import 'package:boilerplate/models/category/category.dart';
import 'package:boilerplate/models/city/city.dart';
import 'package:boilerplate/models/district/district.dart';
import 'package:boilerplate/models/post/post_request.dart';
import 'package:boilerplate/stores/error/error_store.dart';
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
  double minPrice;
  @observable
  double minRentPrice;
  @observable
  double minDepositPrice;
  @observable
  ObservableList<int> propertyTypes = new ObservableList<int>();

  @observable
  double maxPrice;
  @observable
  double maxRentPrice;
  @observable
  double maxDepositPrice;

  @observable
  double minArea;
  @observable
  double maxArea;
  @observable
  Category category = Category();
  @observable
  int bedCount;
  @observable
  District district = District();
  @observable
  City city = City();
  @observable
  Area area = Area();
  @observable
  ObservableList<int> amenities = new ObservableList<int>();
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
  void setLowArea(double value) {
    minArea = value;
  }

  @action
  void setHightArea(double value) {
    maxArea = value;
  }

  @action
  void setAmenity(int value) {
    amenities.contains(value) ? amenities.remove(value) : amenities.add(value);
  }

  @action
  void setPropertyType(int value) {
    propertyTypes.contains(value)
        ? propertyTypes.remove(value)
        : propertyTypes.add(value);
  }

  @action
  void setDistrict(int value, String name) {
    district.name = name;
    district.id = value;
  }

  @action
  void setArea(int value, String name) {
    area.name = name;
    area.id = value;
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
        minArea: minArea?.floor(),
        maxArea: maxArea?.floor(),
        district: district.id,
        districtName: district.name,
        area: area.id,
        areaName: area.name,
        city: city.id,
        cityName: city.name,
        bedCount: bedCount,
        category: category.id,
        categoryName: category.name,
        types: propertyTypes,
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
  void mapFilters(PostRequest request) {
    maxPrice = request.maxPrice?.toDouble();
    minPrice = request.minPrice?.toDouble();
    maxRentPrice = request.maxRentPrice?.toDouble();
    minRentPrice = request.minRentPrice?.toDouble();
    maxDepositPrice = request.maxDepositPrice?.toDouble();
    minDepositPrice = request.minDepositPrice?.toDouble();
    minArea = request.minArea?.toDouble();
    maxArea = request.maxArea?.toDouble();
    bedCount = request.bedCount;
    category = Category(id: request.category, name: request.categoryName);
    district = District(id: request.district, name: request.districtName);
    area = Area(id: request.area, name: request.areaName);
    city = City(id: request.city, name: request.cityName);
    if (request.types != null) {
      propertyTypes = ObservableList.of(request.types);
    }
    if (request.amenities != null) {
      amenities = ObservableList.of(request.amenities);
    }
  }

  @action
  void resetForm() {
    category = null;
    city = null;
    district = null;
    bedCount = null;
    amenities = null;
    minArea = null;
    maxArea = null;
  }

  @action
  void resetPrice() {
    maxPrice = null;
    minPrice = null;
    maxRentPrice = null;
    minRentPrice = null;
    maxDepositPrice = null;
    minDepositPrice = null;
  }

  // general methods:-----------------------------------------------------------
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
