import 'package:boilerplate/data/local/constants/db_constants.dart';
import 'package:boilerplate/models/post/post.dart';
import 'package:boilerplate/models/post/post_request.dart';
import 'package:sembast/sembast.dart';

class SearchDataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  final _searchesStore = intMapStoreFactory.store(DBConstants.Search);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
//  Future<Database> get _db async => await AppDatabase.instance.database;

  // database instance
  final Future<Database> _db;

  // Constructor
  SearchDataSource(this._db);

  // DB functions:--------------------------------------------------------------
  Future<int> insert(PostRequest request) async {
    try {
      return await _searchesStore.add(await _db, request.toJsonLocalStore());
    } catch (e) {
      throw e;
    }
  }

  Future<PostRequest> findById(int id) async {
    var db = await _searchesStore.find(await _db);
    var searches = db.map((e) {
      final post = PostRequest.fromMapLocalStore(e.value);
      return post;
    }).toList();

    return searches.firstWhere((element) => id == element.id,
        orElse: () => null);
  }

  Future<int> count() async {
    return await _searchesStore.count(await _db);
  }

  Future<List<Post>> getAllSortedByFilter({List<Filter> filters}) async {
    //creating finder
    final finder = Finder(
        filter: Filter.and(filters),
        sortOrders: [SortOrder(DBConstants.FIELD_ID)]);

    final recordSnapshots = await _searchesStore.find(
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

  Future<List<PostRequest>> getSearchesFromDb() async {
    // fetching data
    final recordSnapshots = await _searchesStore.find(await _db);
    List<PostRequest> requests;
    // Making a List<Post> out of List<RecordSnapshot>
    if (recordSnapshots.length > 0) {
      try {
        requests = recordSnapshots.map((snapshot) {
          final post = PostRequest.fromMapLocalStore(snapshot.value);
          post.id = snapshot.key;
          return post;
        }).toList();
      } catch (e) {
        throw e;
      }
    }
    return requests;
  }

  Future<int> update(Post post) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(post.id));
    return await _searchesStore.update(
      await _db,
      post.toMap(),
      finder: finder,
    );
  }

  Future<int> delete(int id) async {
    final finder = Finder(filter: Filter.byKey(id));
    return await _searchesStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future deleteAll() async {
    await _searchesStore.drop(
      await _db,
    );
  }
}
