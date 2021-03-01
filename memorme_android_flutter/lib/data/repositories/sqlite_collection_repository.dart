import 'package:memorme_android_flutter/data/models/collections/collection.dart';

import 'collection_repository.dart';

class SQLiteCollectionRepository extends CollectionRepository {
  @override
  Future<Collection> fetch(int id) {
    // TODO: implement fetch
    throw UnimplementedError();
  }

  @override
  Future<List<Collection>> fetchCollections(
      int pageSize, Collection lastCollection,
      {bool ascending = false}) {
    // TODO: implement fetchCollections
    throw UnimplementedError();
  }

  @override
  Future<Collection> removeCollection(Collection collection) {
    // TODO: implement removeCollection
    throw UnimplementedError();
  }

  @override
  Future<Collection> saveCollection(Collection collection) {
    // TODO: implement saveCollection
    throw UnimplementedError();
  }
}
