// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PostStore on _PostStore, Store {
  Computed<bool> _$hasNextPageComputed;

  @override
  bool get hasNextPage =>
      (_$hasNextPageComputed ??= Computed<bool>(() => super.hasNextPage,
              name: '_PostStore.hasNextPage'))
          .value;
  Computed<bool> _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: '_PostStore.loading'))
      .value;
  Computed<bool> _$loadingUserPostsComputed;

  @override
  bool get loadingUserPosts => (_$loadingUserPostsComputed ??= Computed<bool>(
          () => super.loadingUserPosts,
          name: '_PostStore.loadingUserPosts'))
      .value;
  Computed<bool> _$loadingNextPageComputed;

  @override
  bool get loadingNextPage =>
      (_$loadingNextPageComputed ??= Computed<bool>(() => super.loadingNextPage,
              name: '_PostStore.loadingNextPage'))
          .value;

  final _$fetchPostsFutureAtom = Atom(name: '_PostStore.fetchPostsFuture');

  @override
  ObservableFuture<PostList> get fetchPostsFuture {
    _$fetchPostsFutureAtom.reportRead();
    return super.fetchPostsFuture;
  }

  @override
  set fetchPostsFuture(ObservableFuture<PostList> value) {
    _$fetchPostsFutureAtom.reportWrite(value, super.fetchPostsFuture, () {
      super.fetchPostsFuture = value;
    });
  }

  final _$fetchUserPostsFutureAtom =
      Atom(name: '_PostStore.fetchUserPostsFuture');

  @override
  ObservableFuture<PostList> get fetchUserPostsFuture {
    _$fetchUserPostsFutureAtom.reportRead();
    return super.fetchUserPostsFuture;
  }

  @override
  set fetchUserPostsFuture(ObservableFuture<PostList> value) {
    _$fetchUserPostsFutureAtom.reportWrite(value, super.fetchUserPostsFuture,
        () {
      super.fetchUserPostsFuture = value;
    });
  }

  final _$fetchNextPostsFutureAtom =
      Atom(name: '_PostStore.fetchNextPostsFuture');

  @override
  ObservableFuture<PostList> get fetchNextPostsFuture {
    _$fetchNextPostsFutureAtom.reportRead();
    return super.fetchNextPostsFuture;
  }

  @override
  set fetchNextPostsFuture(ObservableFuture<PostList> value) {
    _$fetchNextPostsFutureAtom.reportWrite(value, super.fetchNextPostsFuture,
        () {
      super.fetchNextPostsFuture = value;
    });
  }

  final _$postListAtom = Atom(name: '_PostStore.postList');

  @override
  PostList get postList {
    _$postListAtom.reportRead();
    return super.postList;
  }

  @override
  set postList(PostList value) {
    _$postListAtom.reportWrite(value, super.postList, () {
      super.postList = value;
    });
  }

  final _$userPostListAtom = Atom(name: '_PostStore.userPostList');

  @override
  PostList get userPostList {
    _$userPostListAtom.reportRead();
    return super.userPostList;
  }

  @override
  set userPostList(PostList value) {
    _$userPostListAtom.reportWrite(value, super.userPostList, () {
      super.userPostList = value;
    });
  }

  final _$successAtom = Atom(name: '_PostStore.success');

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

  final _$pageAtom = Atom(name: '_PostStore.page');

  @override
  int get page {
    _$pageAtom.reportRead();
    return super.page;
  }

  @override
  set page(int value) {
    _$pageAtom.reportWrite(value, super.page, () {
      super.page = value;
    });
  }

  final _$userPageAtom = Atom(name: '_PostStore.userPage');

  @override
  int get userPage {
    _$userPageAtom.reportRead();
    return super.userPage;
  }

  @override
  set userPage(int value) {
    _$userPageAtom.reportWrite(value, super.userPage, () {
      super.userPage = value;
    });
  }

  final _$pageSizeAtom = Atom(name: '_PostStore.pageSize');

  @override
  int get pageSize {
    _$pageSizeAtom.reportRead();
    return super.pageSize;
  }

  @override
  set pageSize(int value) {
    _$pageSizeAtom.reportWrite(value, super.pageSize, () {
      super.pageSize = value;
    });
  }

  final _$loadNextPageAsyncAction = AsyncAction('_PostStore.loadNextPage');

  @override
  Future<dynamic> loadNextPage({PostRequest request}) {
    return _$loadNextPageAsyncAction
        .run(() => super.loadNextPage(request: request));
  }

  final _$loadUserNextPageAsyncAction =
      AsyncAction('_PostStore.loadUserNextPage');

  @override
  Future<dynamic> loadUserNextPage({PostRequest request}) {
    return _$loadUserNextPageAsyncAction
        .run(() => super.loadUserNextPage(request: request));
  }

  final _$getPostsAsyncAction = AsyncAction('_PostStore.getPosts');

  @override
  Future<dynamic> getPosts({PostRequest request, bool paging = false}) {
    return _$getPostsAsyncAction
        .run(() => super.getPosts(request: request, paging: paging));
  }

  final _$removeUserPostsAsyncAction =
      AsyncAction('_PostStore.removeUserPosts');

  @override
  Future<dynamic> removeUserPosts() {
    return _$removeUserPostsAsyncAction.run(() => super.removeUserPosts());
  }

  final _$getUserPostsAsyncAction = AsyncAction('_PostStore.getUserPosts');

  @override
  Future<dynamic> getUserPosts({PostRequest request}) {
    return _$getUserPostsAsyncAction
        .run(() => super.getUserPosts(request: request));
  }

  @override
  String toString() {
    return '''
fetchPostsFuture: ${fetchPostsFuture},
fetchUserPostsFuture: ${fetchUserPostsFuture},
fetchNextPostsFuture: ${fetchNextPostsFuture},
postList: ${postList},
userPostList: ${userPostList},
success: ${success},
page: ${page},
userPage: ${userPage},
pageSize: ${pageSize},
hasNextPage: ${hasNextPage},
loading: ${loading},
loadingUserPosts: ${loadingUserPosts},
loadingNextPage: ${loadingNextPage}
    ''';
  }
}
