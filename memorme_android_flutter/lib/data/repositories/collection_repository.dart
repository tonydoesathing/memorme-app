import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/search_result.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';

abstract class CollectionRepository {
  /// returns a list of collections with size [pageSize] after [lastCollection] (exclusive)
  /// and sorts it by date last edited and optional [ascending] bool; defaults to false
  Future<List<Collection>> fetchCollections(
      int pageSize, Collection lastCollection,
      {bool ascending = false});

  /// fetches a [Collection] by its [id]
  Future<Collection> fetch(int id);

  /// saves the [collection]
  Future<Collection> saveCollection(Collection collection);

  /// removes the [collection] and its associated [MCRelation]s
  Future<Collection> removeCollection(Collection collection);

  /// saves the [mcRelation]
  Future<MCRelation> saveMCRelation(MCRelation mcRelation);

  /// removes the [mcRelation]
  Future<MCRelation> removeMCRelation(MCRelation mcRelation);

  /// fetches a list of [MCRelation] of size [pageSize] in a [collection] after [lastMCRelation]
  /// and sorts it by date last edited according to optional [ascending] bool (defaults to false)
  Future<List<MCRelation>> fetchMCRelations(
      Collection collection, int pageSize, MCRelation lastMCRelation,
      {bool ascending = false});

  /// searches for [collection] that match the [query]
  /// returns a list of [searchResults] sorted by points decending
  Future<List<SearchResult>> searchCollections(String query);
}
