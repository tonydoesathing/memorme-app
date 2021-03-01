import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';

abstract class CollectionRepository {
  /// returns a list of collections with size [pageSize] after [offset] (inclusive)
  /// and sorts it by date last edited and optional [ascending] bool; defaults to false
  Future<List<Collection>> fetchCollections(
      int pageSize, Collection lastCollection,
      {bool ascending = false});

  /// fetches a [Collection] by its [id]
  Future<Collection> fetch(int id);

  /// saves the [collection]
  Future<Collection> saveCollection(Collection collection);

  /// removes the [collection]
  Future<Collection> removeCollection(Collection collection);
}
