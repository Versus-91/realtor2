// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amenity_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AmenityStore on _AmenityStore, Store {
  Computed<bool> _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: '_AmenityStore.loading'))
      .value;

  final _$fetchAmenitiesFutureAtom =
      Atom(name: '_AmenityStore.fetchAmenitiesFuture');

  @override
  ObservableFuture<AmenityList> get fetchAmenitiesFuture {
    _$fetchAmenitiesFutureAtom.reportRead();
    return super.fetchAmenitiesFuture;
  }

  @override
  set fetchAmenitiesFuture(ObservableFuture<AmenityList> value) {
    _$fetchAmenitiesFutureAtom.reportWrite(value, super.fetchAmenitiesFuture,
        () {
      super.fetchAmenitiesFuture = value;
    });
  }

  final _$amenityListAtom = Atom(name: '_AmenityStore.amenityList');

  @override
  AmenityList get amenityList {
    _$amenityListAtom.reportRead();
    return super.amenityList;
  }

  @override
  set amenityList(AmenityList value) {
    _$amenityListAtom.reportWrite(value, super.amenityList, () {
      super.amenityList = value;
    });
  }

  final _$successAtom = Atom(name: '_AmenityStore.success');

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

  final _$getAmenitiesAsyncAction = AsyncAction('_AmenityStore.getAmenities');

  @override
  Future<dynamic> getAmenities() {
    return _$getAmenitiesAsyncAction.run(() => super.getAmenities());
  }

  @override
  String toString() {
    return '''
fetchAmenitiesFuture: ${fetchAmenitiesFuture},
amenityList: ${amenityList},
success: ${success},
loading: ${loading}
    ''';
  }
}
