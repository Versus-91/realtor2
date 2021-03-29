import 'dart:math';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/amenity/amenity.dart';
import 'package:boilerplate/models/post/post.dart';
import 'package:boilerplate/models/postimages/postimages.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'post_form.g.dart';

class PostFormStore = _PostFormStore with _$PostFormStore;

abstract class _PostFormStore with Store {
  // store for handling form errors
  final PostFormErrorStore formErrorStore = PostFormErrorStore();
  Repository _repository;

  // store for handling error messages
  final ErrorStore errorStore = ErrorStore();

  _PostFormStore(Repository repository) {
    _repository = repository;
    _setupValidations();
  }

  // disposers:-----------------------------------------------------------------
  List<ReactionDisposer> _disposers;

  void _setupValidations() {
    _disposers = [
      reaction((_) => area, validateArea),
      // reaction((_) => buyPrice, validatePrice),
      // reaction((_) => rahnPrice, validateRahnPrice),
      reaction((_) => latitude, validateLattitude),
      reaction((_) => longitude, validateLattitude),
      reaction((_) => description, validateDescription),
      reaction((_) => propertyHomeTypeId, validateTypeHome),
      reaction((_) => selectedDistrict, validateDistrict),
      reaction((_) => ageHome, validateAge),
    ];
  }

  // store variables:-----------------------------------------------------------
  @observable
  String title;
  @observable
  bool success = false;
  @observable
  int ageHome;

  @observable
  bool loading = false;
  @observable
  bool loadDataFields = true;
  @observable
  int categoryId;
  @observable
  String categoryName;
  @observable
  int postId;
  @observable
  int propertyHomeTypeId;
  @observable
  double latitude;
  @observable
  double longitude;
  @observable
  Point point;
  @observable
  int selectedCity;

  @observable
  int selectedDistrict;
  @observable
  int selectedLocality;
  @observable
  String description = "";
  @observable
  int area;
  @observable
  double rahnPrice;
  @observable
  double rentPrice;
  @observable
  double buyPrice;
  @observable
  int countbedroom;
  @observable
  int realEstateId;
  @observable
  List<int> amenities = new List<int>();
  @observable
  var postImages = ObservableList<Postimages>();
  // actions:-------------------------------------------------------------------
  @action
  void setLatitude(double value) {
    latitude = value;
  }

  @action
  void setCategoryName(String name) {
    categoryName = name;
  }

  @action
  void setRealEstateId(int id) {
    realEstateId = id;
  }

  @action
  void loadedDataFields() {
    loadDataFields = false;
  }

  @action
  void setLongitude(double value) {
    longitude = value;
  }

  @action
  void setCategory(int value) {
    categoryId = value;
  }

  @action
  void setPropertyHomeType(int value) {
    propertyHomeTypeId = value;
  }

  @action
  void setCity(int value) {
    selectedCity = value;
  }

  @action
  void setDistrict(int value) {
    selectedDistrict = value;
  }

  @action
  void setLocality(int value) {
    selectedLocality = value;
  }

  @action
  void setAmenity(int value) {
    amenities.contains(value) ? amenities.remove(value) : amenities.add(value);
  }

  @action
  void setTitle(String value) {
    title = value;
  }

  @action
  void setDescription(String value) {
    description = value;
  }

  @action
  void setArea(int value) {
    area = value;
  }

  @action
  void setRahnPrice(double value) {
    rahnPrice = value;
  }

  @action
  void setRentPrice(double value) {
    rentPrice = value;
  }

  @action
  void setAge(int value) {
    ageHome = value;
  }

  @action
  void setBuyPrice(double value) {
    buyPrice = value;
  }

  @action
  void setcountbedroom(int value) {
    countbedroom = value;
  }

  @action
  void setPostId(int value) {
    postId = value;
  }

  @action
  void addFile(Postimages image) {
    var foundFile = postImages.where((element) =>
        element.path == image.path &&
        element.isfromNetwork == image.isfromNetwork &&
        element.id == image.id);
    if (foundFile == null || foundFile.isEmpty) {
      postImages.add(image);
    }
  }

  @action
  void removeFile(Postimages image) {
    var foundFile = postImages.where((element) =>
        element.path == image.path &&
        element.isfromNetwork == image.isfromNetwork &&
        element.id == image.id);
    if (foundFile != null) {
      postImages.remove(image);
    }
  }

  @action
  validateCreatePost() {
    validateArea(area);
    validateLattitude(latitude);
    validateLng(longitude);
    validateDistrict(selectedDistrict);
    validateAge(ageHome);
    validateLattitude(latitude);

    validateDescription(description);
    validateTypeHome(propertyHomeTypeId);
  }

  @action
  void resetPrice() {
    buyPrice = null;
    rahnPrice = null;
    rentPrice = null;
  }

  @action
  void resetForm() {
    buyPrice = null;
    rahnPrice = null;
    rentPrice = null;
    ageHome = null;
    categoryId = null;
    postId = null;
    propertyHomeTypeId = null;
    latitude = null;
    longitude = null;
    selectedDistrict = null;
    description = null;
    area = null;
    countbedroom = null;
  }

  @action
  void setFormValues(Post post) {
    ageHome = post.age;
    categoryId = post.categoryId;
    categoryName = post.category.name;
    postId = post.id;
    propertyHomeTypeId = post.typeId;
    latitude = post.latitude;
    longitude = post.longitude;
    selectedDistrict = post.districtId;
    description = post.description;
    area = post.area;
    buyPrice = post.price;
    countbedroom = post.bedroom;

    var images = post.images
        .map((e) => Postimages(
            id: e.id,
            path: Endpoints.baseUrl + "/" + e.path,
            isfromNetwork: true))
        .toList();
    for (var image in images) {
      addFile(image);
    }
  }

  @action
  Future insertPost() async {
    validateCreatePost();
    if (formErrorStore.isValid == true) {
      var post = Post(
        longitude: this.longitude,
        latitude: this.latitude,
        description: this.description,
        typeId: this.propertyHomeTypeId,
        price: this.buyPrice,
        realEstateId: this.realEstateId,
        area: this.area,
        age: this.ageHome,
        bedroom: this.countbedroom,
        categoryId: this.categoryId,
        districtId: this.selectedDistrict,
        amenities: amenities.map((e) => Amenity(id: e)).toList(),
      );
      loading = true;
      return _repository.insert(post).then((result) {
        loading = false;
        postId = result["id"];
        return result["id"];
      }).catchError((error) {
        loading = false;
        throw error;
      });
    }
    throw "invalid form";
  }

  @action
  Future updatePost(int id) async {
    validateCreatePost();
    if (formErrorStore.isValid == true) {
      var post = Post(
        id: id,
        longitude: this.longitude,
        latitude: this.latitude,
        description: this.description,
        typeId: this.propertyHomeTypeId,
        price: this.buyPrice,
        area: this.area,
        age: this.ageHome,
        bedroom: this.countbedroom,
        categoryId: this.categoryId,
        districtId: this.selectedDistrict,
        amenities: amenities.map((e) => Amenity(id: e)).toList(),
      );

      return _repository.updatePost(post).then((result) {
        loading = false;
        postId = result["id"];
        return true;
      }).catchError((error) {
        loading = false;
        throw error;
      });
    }
    throw "فرم نامعتبر است";
  }

  @action
  Future uploadImages(List<MultipartFile> files, String id) async {
    loading = true;
    return _repository.uploadImages(files, id).then((result) {
      loading = false;
      success = true;
    }).catchError((error) {
      loading = false;
    });
  }

  @action
  void validateArea(int value) {
    if (value == null || value <= 0) {
      formErrorStore.area = "مساحت را وارد کنید";
    } else {
      formErrorStore.area = null;
    }
  }

  @action
  void validateTypeHome(int value) {
    if (value == null) {
      formErrorStore.typeHome = "نوع ملک را مشخص کنید";
    } else {
      formErrorStore.typeHome = null;
    }
  }

  @action
  void validatePrice(double value) {
    if (value == null) {
      formErrorStore.buyPrice = "قیمت را وارد کنید";
    } else {
      formErrorStore.buyPrice = null;
    }
  }

  @action
  void validateRentPrice(double value) {
    if (value == null) {
      formErrorStore.rentPrice = "قیمت کرای را وارد کنید";
    } else {
      formErrorStore.rentPrice = null;
    }
  }

  @action
  void validateRahnPrice(double value) {
    if (value == null || value <= 0) {
      formErrorStore.rahnPrice = "قیمت گروی را وارد کنید";
    } else {
      formErrorStore.rahnPrice = null;
    }
  }

  @action
  void validateDescription(String value) {
    if (value == null || value.isEmpty) {
      formErrorStore.description = "توضیحات را وارد کنید";
    } else {
      formErrorStore.description = null;
    }
  }

  @action
  void validateDistrict(int districtId) {
    if (districtId == null) {
      formErrorStore.district = "محله انتخاب نشده است";
    } else {
      formErrorStore.district = null;
    }
  }

  // general methods:-----------------------------------------------------------
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }

  void validateAge(int ageHome) {
    if (ageHome == null) {
      formErrorStore.age = "عمر بنا باید پر شود";
    } else {
      formErrorStore.age = null;
    }
  }

  void validateLattitude(double latitude) {
    if (latitude == null && latitude != 0 ||
        longitude == null && latitude != 0) {
      formErrorStore.map = "نقشه را انتخاب کنید";
    } else {
      formErrorStore.map = null;
    }
  }

  void validateLng(double longitude) {
    if (latitude == null && latitude != 0 ||
        longitude == null && latitude != 0) {
      formErrorStore.map = "نقشه را انتخاب کنید";
    } else {
      formErrorStore.map = null;
    }
  }
}

class PostFormErrorStore = _PostFormErrorStore with _$PostFormErrorStore;

abstract class _PostFormErrorStore with Store {
  @observable
  String titel;

  @observable
  String area;
  @observable
  String buyPrice;
  @observable
  String rentPrice;
  @observable
  String rahnPrice;
  @observable
  String district;

  @observable
  String age;
  @observable
  String map;
  @observable
  String description;
  @observable
  String typeHome;
  @computed
  bool get isValid =>
      titel == null &&
      district == null &&
      typeHome == null &&
      area == null &&
      buyPrice == null &&
      rentPrice == null &&
      age == null &&
      map == null &&
      rahnPrice == null &&
      description == null;
}
