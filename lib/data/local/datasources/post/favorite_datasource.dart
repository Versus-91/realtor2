import 'package:boilerplate/data/local/constants/db_constants.dart';
import 'package:boilerplate/models/post/post.dart';
import 'package:sembast/sembast.dart';

class FavoriteDataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  final _citiesStore = intMapStoreFactory.store(DBConstants.Favorite);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
//  Future<Database> get _db async => await AppDatabase.instance.database;

  // database instance
  final Future<Database> _db;

  // Constructor
  FavoriteDataSource(this._db);

  // DB functions:--------------------------------------------------------------
  Future<int> insert(Post post) async {
    try {
      var item = post.toMap();
      return await _citiesStore.record(post.id).add(await _db, item);
    } catch (e) {
      throw e;
    }
  }

  Future<Post> findById(int id) async {
    var posts = await _citiesStore.find(await _db);
    var favorites = posts.map((e) {
      final post = Post.fromMap(e.value);
      return post;
    }).toList();

    return favorites.firstWhere((element) => element.id == id,
        orElse: () => null);
  }

  Future<int> count() async {
    return await _citiesStore.count(await _db);
  }

  Future<List<Post>> getAllSortedByFilter({List<Filter> filters}) async {
    //creating finder
    final finder = Finder(
        filter: Filter.and(filters),
        sortOrders: [SortOrder(DBConstants.FIELD_ID)]);

    final recordSnapshots = await _citiesStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Post> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final city = Post.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      city.id = snapshot.key;
      return city;
    }).toList();
  }

  Future<List<Post>> getPostsFromDb() async {
    // fetching data
    //await deleteAll();
    final recordSnapshots = await _citiesStore.find(await _db);
    List<Post> posts;
    // Making a List<Post> out of List<RecordSnapshot>
    if (recordSnapshots.length > 0) {
      posts = recordSnapshots.map((snapshot) {
        final post = Post.fromMap(snapshot.value);
        return post;
      }).toList();
    }

    return posts;
  }

  Future<int> update(Post post) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(post.id));
    return await _citiesStore.update(
      await _db,
      post.toMap(),
      finder: finder,
    );
  }

  Future<int> delete(Post post) async {
    final finder = Finder(filter: Filter.byKey(post.id));
    return await _citiesStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future deleteAll() async {
    await _citiesStore.drop(
      await _db,
    );
  }
}
