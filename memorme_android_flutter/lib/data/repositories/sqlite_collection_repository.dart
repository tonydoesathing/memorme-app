import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/search_result.dart';
import 'package:memorme_android_flutter/data/models/sql_constants.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/providers/database_provider.dart';
import 'package:memorme_android_flutter/data/repositories/sqlite_memory_repository.dart';
import 'package:sqflite/sqflite.dart';

import 'collection_repository.dart';

class SQLiteCollectionRepository extends CollectionRepository {

  final DBProvider _dbProvider;
  SQLiteCollectionRepository(this._dbProvider);

  @override
  Future<Collection> fetch(int id) async {
    try{
      Database db = await _dbProvider.getDatabase(pathToDb: inMemoryDatabasePath);
      Collection collection = Collection.fromMap((await db.query("$collection_table", where: "id = $id")).first);
      return collection;

    } catch (_) {
      print(_.toString());
      return null;
    }
  }

  @override
  Future<List<Collection>> fetchCollections(
      int pageSize, Collection lastCollection,
      {bool ascending = false}) async {
    try{
      Database db = await _dbProvider.getDatabase();
      final List<Map<String, dynamic>> collections = lastCollection == null
          // lastCollection is null; go from beginning
          ? await db.query("$collection_table",
              orderBy: "$date_last_edited DESC,$row_id",
              limit: pageSize)
          // lastCollection is not null; go from there
          : await db.query("$collection_table",
              where: "($date_last_edited, $row_id) < (?,?)",
              whereArgs: [lastCollection.dateLastEdited.millisecondsSinceEpoch, lastCollection.id],
              orderBy: "$date_last_edited DESC,$row_id",
              limit: pageSize);
      final List<Collection> collectionsList = [];
      for(int i = 0; i < collections.length; i++){
        collectionsList.add(Collection.fromMap(collections[i]));
      }
      return collectionsList;

    } catch(_){
      print(_.toString());
      return null;
    }
  }

  @override
  Future<Collection> removeCollection(Collection collection) async {
    try{
      Database db = await _dbProvider.getDatabase(pathToDb: inMemoryDatabasePath);
      int collectionID = collection.id;
      db.rawDelete('DELETE FROM $collection_table WHERE id = $collectionID');
      return collection;

    } catch (_) {
      print(_.toString());
      return null;
    }
  }

  @override
  Future<Collection> saveCollection(Collection collection) async {
    try{
      Database db = await _dbProvider.getDatabase(pathToDb: inMemoryDatabasePath);
      int collectionID = await db.insert("$collection_table", collection.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      return Collection.editCollection(collection, id: collectionID);

    } catch (_){
      print(_.toString());
      return null;
    }
  }

  @override
  Future<List<MCRelation>> fetchMCRelations(
      Collection collection, int pageSize, MCRelation lastMCRelation,
      {bool ascending = false}) async {
    try{
      Database db = await _dbProvider.getDatabase();
      int collectionID = collection.id;
      final List<Map<String, dynamic>> mcRelations = lastMCRelation == null
          // lastMCRelation is null; go from beginning
          ? await db.query("$memory_collection_relationship_table",
              where: "$collection_fk = $collectionID",
              orderBy: "$date_last_edited DESC,$row_id",
              limit: pageSize)
          // lastMCRelation is not null; go from there
          : await db.query("$memory_collection_relationship_table",
              where: "$collection_fk = $collectionID AND ($date_last_edited, $row_id) < (?,?)",
              whereArgs: [lastMCRelation.dateLastEdited.millisecondsSinceEpoch, lastMCRelation.id],
              orderBy: "$date_last_edited DESC,$row_id",
              limit: pageSize);
      final List<MCRelation> mcRelationsList = [];
      for(int i = 0; i < mcRelations.length; i++){
        mcRelationsList.add(MCRelation.fromMap(mcRelations[i]));
      }
      return mcRelationsList;

    } catch(_){
      print(_.toString());
      return null;
    }
  }

  @override
  Future<MCRelation> removeMCRelation(MCRelation mcRelation) async {
    try{
      Database db = await _dbProvider.getDatabase(pathToDb: inMemoryDatabasePath);
      int mcRelationID = mcRelation.id;
      db.rawDelete('DELETE FROM $memory_collection_relationship_table WHERE id = $mcRelationID');
      return mcRelation;

    } catch (_) {
      print(_.toString());
      return null;
    }
  }

  @override
  Future<MCRelation> saveMCRelation(MCRelation mcRelation) async {
    try{
      Database db = await _dbProvider.getDatabase(pathToDb: inMemoryDatabasePath);
      int mcID = await db.insert("$memory_collection_relationship_table", mcRelation.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      return MCRelation.editMCRelation(mcRelation, id: mcID);

    } catch (_){
      print(_.toString());
      return null;
    }
  }

  @override
  Future<List<SearchResult>> searchCollections(String query) async {
    try{
      Database db = await _dbProvider.getDatabase(pathToDb: inMemoryDatabasePath);
      query = query.toLowerCase();

      // Add collection to results if title matches query
      List<Map> allCollections = await db.query("$collection_table", columns: [row_id, row_title]);
      List<SearchResult> results = [];
      for(int i = 0; i < allCollections.length; i++){
        String title = allCollections[i]["$row_title"];
        if(title != null && title.toLowerCase().contains(query)){
          results.add(SearchResult(await fetch(allCollections[i]["$row_id"]), 1));
        }
      }
      return results;

    } catch(_) {
      print(_.toString());
      return null;
    }
  }
}
