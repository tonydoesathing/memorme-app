import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/data/providers/file_provider.dart';
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
  Future<List<Memory>> fetchMemories(int pageSize, Memory lastMemory) async {
    // get the database
    Database db = await _memormeDBProvider.getDatabase();
    // fetch the page of memories

    // TODO: make descending
    final List<Map<String, dynamic>> memories = lastMemory == null
        // lastMemory is null; go from beginning
        ? await db.query(memoriesTable,
            orderBy: "$memoryDateLastEditedColumn DESC,$memoryIdColumn",
            limit: pageSize)
        // lastMemory is not null; go from there
        : await db.query(memoriesTable,
            where: "($memoryDateLastEditedColumn,$memoryIdColumn) < (?,?)",
            whereArgs: [lastMemory.dateLastEdited, lastMemory.id],
            orderBy: "$memoryDateLastEditedColumn DESC,$memoryIdColumn",
            limit: pageSize);
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

  /// Saves a [memory] to the DB and media to filesystem
  @override
  Future<Memory> saveMemory(Memory memory) async {
    Database db = await _memormeDBProvider.getDatabase();
    // save the memory into the db
    int memoryId = await db.insert(memoriesTable, memory.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    // save the stories into the db
    final List<Story> stories = [];
    // TODO: batch this
    // TODO: properly save storyPreviewId
    for (Story story in memory.stories) {
      // save media to documents directory
      String data = story.data;
      if (story.type == StoryType.PICTURE_STORY) {
        data = await FileProvider().mediaToDocumentsDirectory(data);
      }
      Story temp = Story(
          id: story.id,
          dateCreated: story.dateCreated,
          dateLastEdited: story.dateLastEdited,
          data: data,
          type: story.type);
      // save the story into the db
      int storyId = await db.insert(
          storiesTable, temp.toMapWithMemoryId(memoryId),
          conflictAlgorithm: ConflictAlgorithm.replace);
      // create a new Story with the ID and add it to the stories list
      stories.add(Story(
          id: storyId,
          dateCreated: temp.dateCreated,
          dateLastEdited: temp.dateLastEdited,
          data: temp.data,
          type: temp.type));
    }
    final Memory m = Memory(
        id: memoryId,
        dateCreated: memory.dateCreated,
        dateLastEdited: memory.dateLastEdited,
        storyPreviewId: memory.storyPreviewId,
        stories: stories);
    // return the new memory
    return m;
  }

  /// Removes a [memory] from the DB and media from the filesystem
  @override
  Future<Memory> removeMemory(Memory memory) async {
    // if memory has an id, try to remove it
    if (memory.id != null) {
      try {
        //remove media from filesystem
        // memory.stories.forEach((story) {
        //   if (story.type == StoryType.PICTURE_STORY) {
        //     // remove it
        //     FileProvider().removeFileFromPath(story.data);
        //   }
        // });
        //remove memory
        Database db = await _memormeDBProvider.getDatabase();
        int rowsDeleted = await db.delete(memoriesTable,
            where: "$memoryIdColumn = ?", whereArgs: [memory.id]);
      } catch (_) {
        print(_.toString());
      }
    }
    return memory;
  }
}
