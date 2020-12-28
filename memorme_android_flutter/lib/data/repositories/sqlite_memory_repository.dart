import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/providers/sqlite_db_provider.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';
import 'package:sqflite/sqflite.dart';

/// Allows for persistent [Memory] storage via SQLite
///
/// Takes an [SQLiteDBProvider]; for defaults, pass in ```SQLiteDBProvider.memorMeSQLiteDBProvider()```
class SQLiteMemoryRepository extends MemoryRepository {
  /// the DB provider
  final SQLiteDBProvider _memormeDBProvider;
  // TODO: add cache
  /// an internal cache for Memories
  // var _memoriesCache = Map();

  SQLiteMemoryRepository(this._memormeDBProvider);

  /// Bulk method to get all memories in DB
  @override
  Future<List<Memory>> fetchMemories() async {
    // get the database
    Database db = await _memormeDBProvider.getDatabase();
    // fetch all the memories
    List<Map<String, dynamic>> memories = await db.query(memoriesTable);
    final List<Memory> memoriesList = [];
    // for each memory:
    for (Map<String, dynamic> memory in memories) {
      // fetch all stories associated with the memory
      List<Map<String, dynamic>> stories = await db.query(storiesTable,
          where: "$memoryIdColumn = ?", whereArgs: [memory[memoryIdColumn]]);
      final List<Story> storiesList = [];

      // for each story:
      for (Map<String, dynamic> story in stories) {
        // create a new Story object
        final Story s = Story.fromMap(story);
        // add story object to list of stories
        storiesList.add(s);
      }
      // create memory object with list of stories and queried data
      final Memory m = Memory.fromMapAndList(memory, storiesList);
      // add memory object to list of memories
      memoriesList.add(m);
    }
    return memoriesList;
  }

  /// Saves a [memory] to the DB
  @override
  Future<Memory> saveMemory(Memory memory) async {
    Database db = await _memormeDBProvider.getDatabase();
    // save the memory into the db
    int memoryId = await db.insert(memoriesTable, memory.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    // save the stories into the db
    final List<Story> stories = [];
    // TODO: batch this
    for (Story story in memory.stories) {
      // save the story into the db
      int storyId = await db.insert(
          storiesTable, story.toMapWithMemoryId(memoryId),
          conflictAlgorithm: ConflictAlgorithm.replace);
      // create a new Story with the ID and add it to the stories list
      stories.add(Story(storyId, story.dateCreated, story.dateLastEdited,
          story.data, story.type));
    }
    final Memory m = Memory(memoryId, memory.dateCreated, memory.dateLastEdited,
        memory.storyPreviewId, stories);
    // return the new memory
    return m;
  }

  /// Removes a [memory] from the DB
  @override
  Future<Memory> removeMemory(Memory memory) async {
    Database db = await _memormeDBProvider.getDatabase();
    int rowsDeleted = await db.delete(memoriesTable,
        where: "$memoryIdColumn = ?", whereArgs: [memory.id]);
    return memory;
  }
}
