// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AreaStore on _AreaStore, Store {
  Computed<bool> _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: '_AreaStore.loading'))
      .value;

  final _$fetchAreasFutureAtom = Atom(name: '_AreaStore.fetchAreasFuture');

  @override
  ObservableFuture<AreaList> get fetchAreasFuture {
    _$fetchAreasFutureAtom.reportRead();
    return super.fetchAreasFuture;
  }

  @override
  set fetchAreasFuture(ObservableFuture<AreaList> value) {
    _$fetchAreasFutureAtom.reportWrite(value, super.fetchAreasFuture, () {
      super.fetchAreasFuture = value;
    });
  }

  final _$areaListAtom = Atom(name: '_AreaStore.areaList');

  @override
  AreaList get areaList {
    _$areaListAtom.reportRead();
    return super.areaList;
  }

  @override
  set areaList(AreaList value) {
    _$areaListAtom.reportWrite(value, super.areaList, () {
      super.areaList = value;
    });
  }

  final _$successAtom = Atom(name: '_AreaStore.success');

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

  final _$getAreasAsyncAction = AsyncAction('_AreaStore.getAreas');

  @override
  Future<dynamic> getAreas() {
    return _$getAreasAsyncAction.run(() => super.getAreas());
  }

  final _$getAreasByCityidAsyncAction =
      AsyncAction('_AreaStore.getAreasByCityid');

  @override
  Future<dynamic> getAreasByCityid(int id) {
    return _$getAreasByCityidAsyncAction.run(() => super.getAreasByCityid(id));
  }

  @override
  String toString() {
    return '''
fetchAreasFuture: ${fetchAreasFuture},
areaList: ${areaList},
success: ${success},
loading: ${loading}
    ''';
  }
}
