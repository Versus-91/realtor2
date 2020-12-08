import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/post/post.dart';
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
      reaction((_) => title, validateString),
      reaction((_) => categoryId, validateCategoryId),
      reaction((_) => area, validateArea),
      reaction((_) => buyPrice, validatePrice),
      reaction((_) => rahnPrice, validateRahnPrice),
      reaction((_) => rentPrice, validateRentPrice),
      reaction((_) => description, validateDescription),
    ];
  }

  // store variables:-----------------------------------------------------------
  @observable
  String title = '';
  @observable
  bool success = false;

  @observable
  bool loading = false;

  @observable
  int categoryId = 0;
  @observable
  int postId;
  @observable
  int propertyHomeTypeId = 0;
  @observable
  double latitude;
  @observable
  double longitude;
  @observable
  int selectedCity = 0;
  @observable
  int selectedDistrict = 0;
  @observable
  String description = "";
  @observable
  int area = 0;
  @observable
  double rahnPrice = 0;
  @observable
  double rentPrice = 0;
  @observable
  double buyPrice = 0;
  @observable
  int countbedroom = 0;
  @observable
  List<int> amenities = new List<int>();
  // actions:-------------------------------------------------------------------
  @action
  void setLatitude(double value) {
    latitude = value;
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
    print(rentPrice);
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
  validateCreatePost() {
    validateString(title);
    validateCategoryId(categoryId);
    validateArea(area);
    validatePrice(buyPrice);
    validateRahnPrice(rahnPrice);
    validateRentPrice(rentPrice);
    validateDescription(description);
  }

  @action
  void resetPrice() {
    buyPrice = null;
    rahnPrice = null;
    rentPrice = null;
  }

  @action
  Future insertPost() async {
    validateCreatePost();
    var post = Post(
      title: this.title,
      longitude: this.latitude,
      latitude: this.latitude,
      description: this.description,
      typeId: this.propertyHomeTypeId,
      rent: this.rentPrice,
      deopsit: this.rahnPrice,
      price: this.buyPrice,
      area: this.area,
      bedroom: this.countbedroom,
      categoryId: this.categoryId,
      districtId: this.selectedDistrict,
    );
    loading = true;
    return Future.delayed(Duration(seconds: 1), () {
      print(post.toMap());
      loading = false;
    });
    // _repository.insert(post).then((result) {
    //   loading = false;
    //   postId = result["id"];
    // }).catchError((error) {
    //   print(error);
    //   loading = false;
    // });
  }

  @action
  Future uploadImages(List<MultipartFile> files, String id) async {
    loading = true;
    _repository.uploadImages(files, id).then((result) {
      loading = false;
      success = true;
    }).catchError((error) {
      loading = false;
    });
  }

  @action
  void validateString(String value) {
    if (value.isEmpty) {
      formErrorStore.titel = "فیلد را وارد کنید";
    } else {
      formErrorStore.titel = null;
    }
  }

  @action
  void validateCategoryId(int value) {
    if (value != null) {
      formErrorStore.category = "یک گزینه را انتخاب کنید";
    } else {
      formErrorStore.category = null;
    }
  }

  @action
  void validateArea(int value) {
    if (value < 0 && value != null) {
      formErrorStore.area = "فیلد را وارد کنید";
    } else {
      formErrorStore.area = null;
    }
  }

  @action
  void validatePrice(double value) {
    if (value < 0 && value != null) {
      formErrorStore.buyPrice = "فیلد قیمت را وارد کنید";
    } else {
      formErrorStore.buyPrice = null;
    }
  }

  @action
  void validateRentPrice(double value) {
    if (value < 0 && value != null) {
      formErrorStore.rentPrice = "فیلد را وارد کنید";
    } else {
      formErrorStore.rentPrice = null;
    }
  }

  @action
  void validateRahnPrice(double value) {
    if (value < 0 && value != null) {
      formErrorStore.rahnPrice = "فیلد را وارد کنید";
    } else {
      formErrorStore.rahnPrice = null;
    }
  }

  @action
  void validateDescription(String value) {
    if (value.isEmpty) {
      formErrorStore.description = "فیلد را وارد کنید";
    } else {
      formErrorStore.description = null;
    }
  }

  // general methods:-----------------------------------------------------------
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}

class PostFormErrorStore = _PostFormErrorStore with _$PostFormErrorStore;

abstract class _PostFormErrorStore with Store {
  @observable
  String titel;
  String category;
  String area;
  String buyPrice;
  String rentPrice;
  String rahnPrice;
  String description;
  @computed
  bool get hasErrorInForgotPassword => titel != null;
  @computed
  bool get isValid =>
      titel == null ||
      category == null ||
      area == null ||
      buyPrice == null ||
      rentPrice == null ||
      rahnPrice == null ||
      description == null;
}
