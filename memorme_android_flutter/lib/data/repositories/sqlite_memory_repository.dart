import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/search_result.dart';
import 'package:memorme_android_flutter/data/models/sql_constants.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/data/providers/database_provider.dart';
import 'package:memorme_android_flutter/data/providers/file_provider.dart';
import 'package:memorme_android_flutter/data/providers/sqlite_db_provider.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteMemoryRepository extends MemoryRepository {

  final DBProvider _dbProvider;

  SQLiteMemoryRepository(this._dbProvider);

  @override
  Future<Memory> fetch(int id) async {
    try{
      Database db = await _dbProvider.getDatabase(pathToDb: inMemoryDatabasePath);
      List<Map<String, dynamic>> retrievedStoryMap = await db.query("$story_table",
          where: "$memory_fk = $id");
      List<Story> retrievedStories = [];
      for(int i = 0; i < retrievedStoryMap.length; i++){
        retrievedStories.add(Story.fromMap(retrievedStoryMap.elementAt(i)));
      }
      List<Map> retrievedMemories = await db.query("$memory_table", where: "id = $id");
      Map retrievedMemoryMap = retrievedMemories.first;
      Memory memory = Memory.fromMap(retrievedMemoryMap, retrievedStories);
      return memory;
      
    } catch (_) {
      print(_.toString());
      return null;
    }
  }

  @override
  Future<List<Memory>> fetchMemories(int pageSize, Memory lastMemory,
      {bool ascending = false}) async {
    try{
      Database db = await _dbProvider.getDatabase();
      final List<Map<String, dynamic>> memories = lastMemory == null
          // lastMemory is null; go from beginning
          ? await db.query("$memory_table",
              orderBy: "$date_last_edited DESC,$row_id",
              limit: pageSize)
          // lastMemory is not null; go from there
          : await db.query("$memory_table",
              where: "($date_last_edited, $row_id) < (?,?)",
              whereArgs: [lastMemory.dateLastEdited.millisecondsSinceEpoch, lastMemory.id],
              orderBy: "$date_last_edited DESC,$row_id",
              limit: pageSize);
      final List<Memory> memoriesList = [];
      // for each memory:
      for (Map<String, dynamic> memory in memories) {
        // fetch all stories associated with the memory
        List<Map<String, dynamic>> stories = await db.query("$story_table",
            where: "$memory_fk = ?", whereArgs: [memory["$row_id"]]);
        final List<Story> storiesList = [];
        // for each story:
        for (Map<String, dynamic> story in stories) {
          // create a new Story object
          final Story s = Story.fromMap(story);
          // add story object to list of stories
          storiesList.add(s);
        }
        // create memory object with list of stories and queried data
        final Memory m = Memory.fromMap(memory, storiesList);
        // add memory object to list of memories
        memoriesList.add(m);
      }
      return memoriesList;

    } catch(_){
      print(_.toString());
      return null;
    }
  }

  @override
  Future<Memory> removeMemory(Memory memory) async {
    try{
      Database db = await _dbProvider.getDatabase(pathToDb: inMemoryDatabasePath);
      int memoryID = memory.id;
      Memory m = await fetch(memoryID);
      db.rawDelete('DELETE FROM $memory_table WHERE $row_id = $memoryID');
      memory.stories.forEach((story) {
        if (story.type != StoryType.TEXT_STORY) {
          FileProvider().removeFileFromPath(story.data);
        }
      });
      return m;

    } catch (_) {
      print(_.toString());
      return null;
    }
  }

  @override
  Future<Memory> saveMemory (Memory memory) async {
    try{
      Database db = await _dbProvider.getDatabase(pathToDb: inMemoryDatabasePath);

      // try update, if nothing there insert
      int memoryID;
      if(memory.id == null){
        memoryID = await db.insert("$memory_table", memory.toMap());
      } else {
        Map m = memory.toMap();
        memoryID = await db.rawUpdate('UPDATE $memory_table SET $row_title = ?, $preview_story_id = ?, $date_created = ?, $date_last_edited = ?, $location = ? WHERE $row_id = ?', 
          [m['$row_title']?.toString(), m["$preview_story_id"]?.toString(), m["$date_created"]?.toString(), m["$date_last_edited"]?.toString(), m["$location"]?.toString(), memory.id.toString()]
        );
      }
      
      memory = Memory.editMemory(memory, id: memoryID);
      final List<Story> stories = [];
      for(int i = 0; i < memory.stories.length; i++){
        Story story = memory.stories.elementAt(i);
        String data = story.data;
        if (story.type != StoryType.TEXT_STORY) {
          data = await FileProvider().mediaToDocumentsDirectory(data);
        }
        Story temp = Story(
          id: story.id,
          dateCreated: story.dateCreated,
          dateLastEdited: story.dateLastEdited,
          data: data,
          type: story.type,
          position: story.position
        );
        int storyID = await db.insert("$story_table", temp.toMap(memory), conflictAlgorithm: ConflictAlgorithm.replace);
        stories.add(Story.editStory(temp, id: storyID));
      }
      memory = Memory.editMemory(memory, stories: stories);
      return memory;

    } catch (_){
      print(_.toString());
      return null;
    }
  }

  @override
  Future<Story> removeStory(Story story) async {
    try{
      Database db = await _dbProvider.getDatabase(pathToDb: inMemoryDatabasePath);
      int storyID = story.id;
      List<Map> retrievedStoryMap = await db.query("$story_table", where: "id = $storyID");
      await db.rawDelete('DELETE FROM $story_table WHERE $row_id = $storyID');
      return Story.fromMap(retrievedStoryMap.first);

    } catch (_) {
      print(_.toString());
      return null;
    }
  }

  @override
  Future<List<SearchResult>> searchMemories(String query) async {
    try{
      Database db = await _dbProvider.getDatabase(pathToDb: inMemoryDatabasePath);
      query = query.toLowerCase();
      
      // Add two points if title matches query, add one point if a story matches query
      List<Map> allMemoryIDs = await db.query("$memory_table", columns: [row_id, row_title]);
      List<int> memoryPoints = [];
      for(int i = 0; i < allMemoryIDs.length; i++){
        int memoryID = allMemoryIDs[i]["$row_id"];
        String memoryTitle = allMemoryIDs[i]["$row_title"];
        int textStoryType = StoryType.TEXT_STORY;
        List<Map> stories = await db.query("$story_table", where: "$memory_fk = $memoryID AND $row_type = $textStoryType", columns: [row_data]);
        int totalPoints = 0;
        if(memoryTitle != null && memoryTitle.toLowerCase().contains(query)){
          totalPoints += 2;
        }
        for(int j = 0; j < stories.length; j++){
          String text = stories[j]["$row_data"];
          if(text.toLowerCase().contains(query)){
            totalPoints += 1;
          }
        }
        memoryPoints.add(totalPoints);
      }

      // Create search results
      List<SearchResult> searchResults = [];
      for(int i = 0; i < allMemoryIDs.length; i++){
        // Add memory if has at least one point
        int points = memoryPoints[i];
        if(points > 0){
          Memory m = await fetch(allMemoryIDs[i]["$row_id"]);
          searchResults.add(SearchResult(m, points));
        }
      }
      searchResults.sort((a, b) => -1 * a.points.compareTo(b.points));
      return searchResults;

    } catch (_) {
      print(_.toString());
      return null;
    }
  }
}

/// Allows for persistent [Memory] storage via SQLite
///
/// Takes an [SQLiteDBProvider]; for defaults, pass in ```SQLiteDBProvider.memorMeSQLiteDBProvider()```
/*class SQLiteMemoryRepository extends MemoryRepository {
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
*/
