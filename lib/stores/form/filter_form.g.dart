// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_form.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FilterFormStore on _FilterFormStore, Store {
  final _$minPriceAtom = Atom(name: '_FilterFormStore.minPrice');

  @override
  double get minPrice {
    _$minPriceAtom.reportRead();
    return super.minPrice;
  }

  @override
  set minPrice(double value) {
    _$minPriceAtom.reportWrite(value, super.minPrice, () {
      super.minPrice = value;
    });
  }

  final _$selectedPropertyTypesAtom =
      Atom(name: '_FilterFormStore.selectedPropertyTypes');

  @override
  List<SelectedPropertyTypes> get selectedPropertyTypes {
    _$selectedPropertyTypesAtom.reportRead();
    return super.selectedPropertyTypes;
  }

  @override
  set selectedPropertyTypes(List<SelectedPropertyTypes> value) {
    _$selectedPropertyTypesAtom.reportWrite(value, super.selectedPropertyTypes,
        () {
      super.selectedPropertyTypes = value;
    });
  }

  final _$maxPriceAtom = Atom(name: '_FilterFormStore.maxPrice');

  @override
  double get maxPrice {
    _$maxPriceAtom.reportRead();
    return super.maxPrice;
  }

  @override
  set maxPrice(double value) {
    _$maxPriceAtom.reportWrite(value, super.maxPrice, () {
      super.maxPrice = value;
    });
  }

  final _$propertyTypesAtom = Atom(name: '_FilterFormStore.propertyTypes');

  @override
  List<int> get propertyTypes {
    _$propertyTypesAtom.reportRead();
    return super.propertyTypes;
  }

  @override
  set propertyTypes(List<int> value) {
    _$propertyTypesAtom.reportWrite(value, super.propertyTypes, () {
      super.propertyTypes = value;
    });
  }

  final _$areaAtom = Atom(name: '_FilterFormStore.area');

  @override
  double get area {
    _$areaAtom.reportRead();
    return super.area;
  }

  @override
  set area(double value) {
    _$areaAtom.reportWrite(value, super.area, () {
      super.area = value;
    });
  }

  final _$categoryAtom = Atom(name: '_FilterFormStore.category');

  @override
  Category get category {
    _$categoryAtom.reportRead();
    return super.category;
  }

  @override
  set category(Category value) {
    _$categoryAtom.reportWrite(value, super.category, () {
      super.category = value;
    });
  }

  final _$bedCountAtom = Atom(name: '_FilterFormStore.bedCount');

  @override
  int get bedCount {
    _$bedCountAtom.reportRead();
    return super.bedCount;
  }

  @override
  set bedCount(int value) {
    _$bedCountAtom.reportWrite(value, super.bedCount, () {
      super.bedCount = value;
    });
  }

  final _$districtAtom = Atom(name: '_FilterFormStore.district');

  @override
  District get district {
    _$districtAtom.reportRead();
    return super.district;
  }

  @override
  set district(District value) {
    _$districtAtom.reportWrite(value, super.district, () {
      super.district = value;
    });
  }

  final _$amenitiesAtom = Atom(name: '_FilterFormStore.amenities');

  @override
  List<int> get amenities {
    _$amenitiesAtom.reportRead();
    return super.amenities;
  }

  @override
  set amenities(List<int> value) {
    _$amenitiesAtom.reportWrite(value, super.amenities, () {
      super.amenities = value;
    });
  }

  final _$loadingAtom = Atom(name: '_FilterFormStore.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$_FilterFormStoreActionController =
      ActionController(name: '_FilterFormStore');

  @override
  void setMinPrice(double value) {
    final _$actionInfo = _$_FilterFormStoreActionController.startAction(
        name: '_FilterFormStore.setMinPrice');
    try {
      return super.setMinPrice(value);
    } finally {
      _$_FilterFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBedCount(int number) {
    final _$actionInfo = _$_FilterFormStoreActionController.startAction(
        name: '_FilterFormStore.setBedCount');
    try {
      return super.setBedCount(number);
    } finally {
      _$_FilterFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMaxPrice(double value) {
    final _$actionInfo = _$_FilterFormStoreActionController.startAction(
        name: '_FilterFormStore.setMaxPrice');
    try {
      return super.setMaxPrice(value);
    } finally {
      _$_FilterFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setArea(double value) {
    final _$actionInfo = _$_FilterFormStoreActionController.startAction(
        name: '_FilterFormStore.setArea');
    try {
      return super.setArea(value);
    } finally {
      _$_FilterFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAmenity(int value) {
    final _$actionInfo = _$_FilterFormStoreActionController.startAction(
        name: '_FilterFormStore.setAmenity');
    try {
      return super.setAmenity(value);
    } finally {
      _$_FilterFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPropertyTypeList(List<SelectedPropertyTypes> items) {
    final _$actionInfo = _$_FilterFormStoreActionController.startAction(
        name: '_FilterFormStore.setPropertyTypeList');
    try {
      return super.setPropertyTypeList(items);
    } finally {
      _$_FilterFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDistrict(int value, String name) {
    final _$actionInfo = _$_FilterFormStoreActionController.startAction(
        name: '_FilterFormStore.setDistrict');
    try {
      return super.setDistrict(value, name);
    } finally {
      _$_FilterFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCategory(int id, String name) {
    final _$actionInfo = _$_FilterFormStoreActionController.startAction(
        name: '_FilterFormStore.setCategory');
    try {
      return super.setCategory(id, name);
    } finally {
      _$_FilterFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  PostRequest applyFilters() {
    final _$actionInfo = _$_FilterFormStoreActionController.startAction(
        name: '_FilterFormStore.applyFilters');
    try {
      return super.applyFilters();
    } finally {
      _$_FilterFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setpropertyTypes(int value) {
    final _$actionInfo = _$_FilterFormStoreActionController.startAction(
        name: '_FilterFormStore.setpropertyTypes');
    try {
      return super.setpropertyTypes(value);
    } finally {
      _$_FilterFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
minPrice: ${minPrice},
selectedPropertyTypes: ${selectedPropertyTypes},
maxPrice: ${maxPrice},
propertyTypes: ${propertyTypes},
area: ${area},
category: ${category},
bedCount: ${bedCount},
district: ${district},
amenities: ${amenities},
loading: ${loading}
    ''';
  }
}
