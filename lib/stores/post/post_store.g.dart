// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PostStore on _PostStore, Store {
  Computed<bool> _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: '_PostStore.loading'))
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

  final _$getPostsAsyncAction = AsyncAction('_PostStore.getPosts');

  @override
  Future<dynamic> getPosts({PostRequest request}) {
    return _$getPostsAsyncAction.run(() => super.getPosts(request: request));
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

  final _$_PostStoreActionController = ActionController(name: '_PostStore');

  @override
  Future<dynamic> loadNextPage({PostRequest request}) {
    final _$actionInfo = _$_PostStoreActionController.startAction(
        name: '_PostStore.loadNextPage');
    try {
      return super.loadNextPage(request: request);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchPostsFuture: ${fetchPostsFuture},
fetchNextPostsFuture: ${fetchNextPostsFuture},
postList: ${postList},
userPostList: ${userPostList},
success: ${success},
page: ${page},
pageSize: ${pageSize},
loading: ${loading}
    ''';
  }
}
