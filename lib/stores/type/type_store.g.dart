// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'type_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TypeStore on _TypeStore, Store {
  Computed<bool> _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: '_TypeStore.loading'))
      .value;

  final _$fetchTypeFutureAtom = Atom(name: '_TypeStore.fetchTypeFuture');

  @override
  ObservableFuture<TypeList> get fetchTypeFuture {
    _$fetchTypeFutureAtom.reportRead();
    return super.fetchTypeFuture;
  }

  @override
  set fetchTypeFuture(ObservableFuture<TypeList> value) {
    _$fetchTypeFutureAtom.reportWrite(value, super.fetchTypeFuture, () {
      super.fetchTypeFuture = value;
    });
  }

  final _$typeListAtom = Atom(name: '_TypeStore.typeList');

  @override
  TypeList get typeList {
    _$typeListAtom.reportRead();
    return super.typeList;
  }

  @override
  set typeList(TypeList value) {
    _$typeListAtom.reportWrite(value, super.typeList, () {
      super.typeList = value;
    });
  }

  final _$successAtom = Atom(name: '_TypeStore.success');

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

  final _$getTypesAsyncAction = AsyncAction('_TypeStore.getTypes');

  @override
  Future<dynamic> getTypes() {
    return _$getTypesAsyncAction.run(() => super.getTypes());
  }

  @override
  String toString() {
    return '''
fetchTypeFuture: ${fetchTypeFuture},
typeList: ${typeList},
success: ${success},
loading: ${loading}
    ''';
  }
}
