import 'package:boilerplate/data/local/constants/db_constants.dart';
import 'package:boilerplate/models/city/city.dart';
import 'package:boilerplate/models/city/city_list.dart';
import 'package:sembast/sembast.dart';

class CityDataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  final _citiesStore = intMapStoreFactory.store(DBConstants.STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
//  Future<Database> get _db async => await AppDatabase.instance.database;

  // database instance
  final Future<Database> _db;

  // Constructor
  CityDataSource(this._db);

  // DB functions:--------------------------------------------------------------
  Future<int> insert(City city) async {
    return await _citiesStore.add(await _db, city.toMap());
  }

  Future<int> count() async {
    return await _citiesStore.count(await _db);
  }

  Future<List<City>> getAllSortedByFilter({List<Filter> filters}) async {
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
      final city = City.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      city.id = snapshot.key;
      return city;
    }).toList();
  }

  Future<CityList> getPostsFromDb() async {


    // post list
    var postsList;

    // fetching data
    final recordSnapshots = await _citiesStore.find(
      await _db,
    );

    // Making a List<Post> out of List<RecordSnapshot>
    if(recordSnapshots.length > 0) {
      postsList = CityList(
         cities: recordSnapshots.map((snapshot) {
            final post = City.fromMap(snapshot.value);
            // An ID is a key of a record from the database.
            post.id = snapshot.key;
            return post;
          }).toList());
    }

    return postsList;
  }

  Future<int> update(City post) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(post.id));
    return await _citiesStore.update(
      await _db,
      post.toMap(),
      finder: finder,
    );
  }

  Future<int> delete(City post) async {
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

