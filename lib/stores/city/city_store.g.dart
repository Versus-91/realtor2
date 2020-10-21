// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CityStore on _CityStore, Store {
  Computed<bool> _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: '_CityStore.loading'))
      .value;

  final _$fetchCitiesFutureAtom = Atom(name: '_CityStore.fetchCitiesFuture');

  @override
  ObservableFuture<CityList> get fetchCitiesFuture {
    _$fetchCitiesFutureAtom.reportRead();
    return super.fetchCitiesFuture;
  }

  @override
  set fetchCitiesFuture(ObservableFuture<CityList> value) {
    _$fetchCitiesFutureAtom.reportWrite(value, super.fetchCitiesFuture, () {
      super.fetchCitiesFuture = value;
    });
  }

  final _$cityListAtom = Atom(name: '_CityStore.cityList');

  @override
  CityList get cityList {
    _$cityListAtom.reportRead();
    return super.cityList;
  }

  @override
  set cityList(CityList value) {
    _$cityListAtom.reportWrite(value, super.cityList, () {
      super.cityList = value;
    });
  }

  final _$successAtom = Atom(name: '_CityStore.success');

  @override
  bool get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  final _$getCitiesAsyncAction = AsyncAction('_CityStore.getCities');

  @override
  Future<dynamic> getCities() {
    return _$getCitiesAsyncAction.run(() => super.getCities());
  }

  @override
  String toString() {
    return '''
fetchCitiesFuture: ${fetchCitiesFuture},
cityList: ${cityList},
success: ${success},
loading: ${loading}
    ''';
  }
}
