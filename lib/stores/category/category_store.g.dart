// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CategoryStore on _CategoryStore, Store {
  Computed<bool> _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: '_CategoryStore.loading'))
      .value;

  final _$fetchcategoriesFutureAtom =
      Atom(name: '_CategoryStore.fetchcategoriesFuture');

  @override
  ObservableFuture<CategoryList> get fetchcategoriesFuture {
    _$fetchcategoriesFutureAtom.reportRead();
    return super.fetchcategoriesFuture;
  }

  @override
  set fetchcategoriesFuture(ObservableFuture<CategoryList> value) {
    _$fetchcategoriesFutureAtom.reportWrite(value, super.fetchcategoriesFuture,
        () {
      super.fetchcategoriesFuture = value;
    });
  }

  final _$categoryListAtom = Atom(name: '_CategoryStore.categoryList');

  @override
  CategoryList get categoryList {
    _$categoryListAtom.reportRead();
    return super.categoryList;
  }

  @override
  set categoryList(CategoryList value) {
    _$categoryListAtom.reportWrite(value, super.categoryList, () {
      super.categoryList = value;
    });
  }

  final _$successAtom = Atom(name: '_CategoryStore.success');

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

  final _$getCategoriesAsyncAction =
      AsyncAction('_CategoryStore.getCategories');

  @override
  Future<dynamic> getCategories() {
    return _$getCategoriesAsyncAction.run(() => super.getCategories());
  }

  @override
  String toString() {
    return '''
fetchcategoriesFuture: ${fetchcategoriesFuture},
categoryList: ${categoryList},
success: ${success},
loading: ${loading}
    ''';
  }
}
