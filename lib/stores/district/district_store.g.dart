// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'district_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DistrictStore on _DistrictStore, Store {
  Computed<bool> _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: '_DistrictStore.loading'))
      .value;

  final _$fetchDistrictFutureAtom =
      Atom(name: '_DistrictStore.fetchDistrictFuture');

  @override
  ObservableFuture<DistrictList> get fetchDistrictFuture {
    _$fetchDistrictFutureAtom.reportRead();
    return super.fetchDistrictFuture;
  }

  @override
  set fetchDistrictFuture(ObservableFuture<DistrictList> value) {
    _$fetchDistrictFutureAtom.reportWrite(value, super.fetchDistrictFuture, () {
      super.fetchDistrictFuture = value;
    });
  }

  final _$districtListAtom = Atom(name: '_DistrictStore.districtList');

  @override
  DistrictList get districtList {
    _$districtListAtom.reportRead();
    return super.districtList;
  }

  @override
  set districtList(DistrictList value) {
    _$districtListAtom.reportWrite(value, super.districtList, () {
      super.districtList = value;
    });
  }

  final _$successAtom = Atom(name: '_DistrictStore.success');

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

  final _$getDistrictsAsyncAction = AsyncAction('_DistrictStore.getDistricts');

  @override
  Future<dynamic> getDistricts() {
    return _$getDistrictsAsyncAction.run(() => super.getDistricts());
  }

  final _$getDistrictsByAreaidAsyncAction =
      AsyncAction('_DistrictStore.getDistrictsByAreaid');

  @override
  Future<dynamic> getDistrictsByAreaid(int id) {
    return _$getDistrictsByAreaidAsyncAction
        .run(() => super.getDistrictsByAreaid(id));
  }

  @override
  String toString() {
    return '''
fetchDistrictFuture: ${fetchDistrictFuture},
districtList: ${districtList},
success: ${success},
loading: ${loading}
    ''';
  }
}
