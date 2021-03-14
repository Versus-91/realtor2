import 'package:boilerplate/models/post/post.dart';

class PostList {
  final List<Post> posts;
  int totalCount = 0;
  PostList({this.posts, this.totalCount});

  factory PostList.fromJson(List<dynamic> json, dynamic totalCount) {
    List<Post> posts = List<Post>();
    posts = json.map((post) => Post.fromMap(post)).toList();
    var total = totalCount;
    return PostList(
      totalCount: total,
      posts: posts,
    );
  }
  factory PostList.fromFavoriteJson(List<dynamic> json, dynamic totalCount) {
    List<Post> posts = List<Post>();
    posts = json.map((favorite) => Post.fromMap(favorite["post"])).toList();
    var total = totalCount;
    return PostList(
      totalCount: total,
      posts: posts,
    );
  }
}
