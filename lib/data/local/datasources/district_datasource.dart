import 'package:boilerplate/data/local/constants/db_constants.dart';
import 'package:boilerplate/models/city/city.dart';
import 'package:boilerplate/models/city/city_list.dart';
import 'package:boilerplate/models/district/district.dart';
import 'package:boilerplate/models/district/district_list.dart';

import 'package:sembast/sembast.dart';

class DistrictDataSource {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects converted to Map
  final _districtStore = intMapStoreFactory.store(DBConstants.STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
//  Future<Database> get _db async => await AppDatabase.instance.database;

  // database instance
  final Future<Database> _db;

  // Constructor
  DistrictDataSource(this._db);

  // DB functions:--------------------------------------------------------------
  Future<int> insert(District district) async {
    return await _districtStore.add(await _db, district.toMap());
  }

  Future<int> count() async {
    return await _districtStore.count(await _db);
  }

  Future<List<District>> getAllSortedByFilter({List<Filter> filters}) async {
    //creating finder
    final finder = Finder(
        filter: Filter.and(filters),
        sortOrders: [SortOrder(DBConstants.FIELD_ID)]);

    final recordSnapshots = await _districtStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Post> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final district = District.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      district.id = snapshot.key;
      return district;
    }).toList();
  }

  Future<DistrictList> getPostsFromDb() async {
    // post list
    var postsList;

    // fetching data
    final recordSnapshots = await _districtStore.find(
      await _db,
    );

    // Making a List<Post> out of List<RecordSnapshot>
    if (recordSnapshots.length > 0) {
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

  Future<int> update(District post) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(post.id));
    return await _districtStore.update(
      await _db,
      post.toMap(),
      finder: finder,
    );
  }

  Future<int> delete(District post) async {
    final finder = Finder(filter: Filter.byKey(post.id));
    return await _districtStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future deleteAll() async {
    await _districtStore.drop(
      await _db,
    );
  }
}
