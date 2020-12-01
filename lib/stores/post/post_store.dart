import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/post/post_list.dart';
import 'package:boilerplate/models/post/post_request.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'post_store.g.dart';

class PostStore = _PostStore with _$PostStore;

abstract class _PostStore with Store {
  // repository instance
  Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _PostStore(Repository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<PostList> emptyPostResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<PostList> fetchPostsFuture =
      ObservableFuture<PostList>(emptyPostResponse);
  @observable
  ObservableFuture<PostList> fetchNextPostsFuture =
      ObservableFuture<PostList>(emptyPostResponse);
  @observable
  PostList postList;
  @observable
  PostList userPostList;
  @observable
  bool success = false;
  @observable
  int page = 1;
  @observable
  int pageSize = 15;
  @computed
  bool get hasNextPage {
    return postList.posts.length < postList.totalCount;
  }

  @action
  Future loadNextPage({PostRequest request}) async {
    if (!loadingNextPage && hasNextPage) {
      request.page = page + 1;
      request.pageSize = pageSize;
      final future = _repository.getPosts(request: request);
      fetchNextPostsFuture = ObservableFuture(future);
      return future.then((postList) {
        this.postList.posts.addAll(postList.posts);
        page = page + 1;
      }).catchError((error) {
        print(error);
        errorStore.errorMessage = DioErrorUtil.handleError(error);
      });
    }
  }

  @computed
  bool get loading {
    return fetchPostsFuture.status == FutureStatus.pending;
  }

  @computed
  bool get loadingNextPage {
    return fetchPostsFuture.status == FutureStatus.pending;
  }

  // actions:-------------------------------------------------------------------
  @action
  Future getPosts({PostRequest request, bool paging = false}) async {
    // request.page = page;
    // request.pageSize = pageSize;
    if (page != 1) page = 1;
    final future = _repository.getPosts(request: request);
    fetchPostsFuture = ObservableFuture(future);

    future.then((postList) {
      this.postList = postList;
    }).catchError((error) {
      print(error);
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  Future removeUserPosts() async {
    this.postList = null;
  }

  @action
  Future getUserPosts({PostRequest request}) async {
    final future = _repository.getUserPosts(request: request);
    fetchPostsFuture = ObservableFuture(future);

    future.then((postList) {
      this.userPostList = postList;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }
}
