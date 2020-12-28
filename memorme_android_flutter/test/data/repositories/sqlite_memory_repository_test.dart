import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/data/providers/sqlite_db_provider.dart';
import 'package:memorme_android_flutter/data/repositories/sqlite_memory_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

// TODO: make each test independent
main() {
  //switch sqflite to be in FFI mode
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  //SQLite repository and provider
  SQLiteMemoryRepository repository;
  SQLiteDBProvider dbProvider;

  //have a standard 'now' time
  int now = DateTime.now().millisecondsSinceEpoch;

  group("Local Memory Data Repository Test >", () {
    setUp(() async {
      //initialize the provider and repository
      dbProvider =
          SQLiteDBProvider.memorMeSQLiteDBProvider(path: inMemoryDatabasePath);
      repository = SQLiteMemoryRepository(dbProvider);
    });

    tearDown(() async {
      //clean up the provider and repository
      await dbProvider.closeDatabase();
      dbProvider = null;
      repository = null;
    });
    test("On creations of repository should create Memories and Stories tables",
        () async {
      await repository.fetchMemories();
      Database db = await dbProvider.getDatabase();
      // get all the tables in the database
      final tables = await db.rawQuery('SELECT name FROM sqlite_master');
      expect(tables, [
        {'name': "$memoriesTable"},
        {'name': "$storiesTable"}
      ]);
    });
    test("Should return empty initial memories list", () async {
      List<Memory> memories = await repository.fetchMemories();
      expect(memories, []);
    });
    test("Should be able to save new memories", () async {
      List<Memory> memories = await repository.fetchMemories();
      expect(memories, []);
      // by leaving id null, SQLite will assign an id
      Memory memory1 = Memory(null, now, now, 1,
          [Story(null, now, now, "Story 1!", StoryType.TEXT_STORY)]);
      // save memory1
      Memory savedMem1 = await repository.saveMemory(memory1);
      // fetch the memories
      memories = await repository.fetchMemories();
      // the only memory in the db should be memory1 (primary keys start at 1 in SQLite)
      expect(memories[0], savedMem1);

      Memory memory2 = Memory(null, now, now, 2, [
        Story(null, now, now, "Story 2!", StoryType.TEXT_STORY),
        Story(null, now, now, "Story 3!", StoryType.TEXT_STORY)
      ]);
      Memory savedMem2 = await repository.saveMemory(memory2);
      memories = await repository.fetchMemories();
      expect(memories[1], savedMem2);
    });

    test("Should be able to update old memories with new stories", () async {
      // There should be 2 memories in the DB
      List<Memory> memories = await repository.fetchMemories();
      Memory memory1 = Memory(1, now, now, 1,
          [Story(1, now, now, "Story 1!", StoryType.TEXT_STORY)]);
      Memory memory2 = Memory(2, now, now, 2, [
        Story(2, now, now, "Story 2!", StoryType.TEXT_STORY),
        Story(3, now, now, "Story 3!", StoryType.TEXT_STORY)
      ]);
      expect(memories, [memory1, memory2]);
      // update memory 1
      final List<Story> stories = [
        ...memory1.stories,
        Story(null, now + 5, now + 5, "Story 4!", StoryType.TEXT_STORY)
      ];
      Memory updatedMemory1 = Memory(memory1.id, memory1.dateCreated,
          memory1.dateLastEdited + 5, memory1.storyPreviewId, stories);
      Memory savedMem1 = await repository.saveMemory(updatedMemory1);
      memories = await repository.fetchMemories();
      expect(memories[0], savedMem1);
    });

    test("Should be able to update old memories by removing stories", () async {
      // There should be 2 memories in the DB with 4 stories
      List<Memory> memories = await repository.fetchMemories();
      Memory memory1 = Memory(1, now, now + 5, 1, [
        Story(1, now, now, "Story 1!", StoryType.TEXT_STORY),
        Story(4, now + 5, now + 5, "Story 4!", StoryType.TEXT_STORY)
      ]);
      Memory memory2 = Memory(2, now, now, 2, [
        Story(2, now, now, "Story 2!", StoryType.TEXT_STORY),
        Story(3, now, now, "Story 3!", StoryType.TEXT_STORY)
      ]);
      expect(memories, [memory1, memory2]);

      // there should be 1 story with the id of 1
      Database db = await dbProvider.getDatabase();
      List<Map<String, dynamic>> stories = await db
          .query(storiesTable, where: "$storyIdColumn = ?", whereArgs: [1]);
      expect(stories, [memory1.stories[0].toMapWithMemoryId(memory1.id)]);
      // there should be 4 stories
      stories = await db.query(storiesTable);
      expect(stories, [
        memory1.stories[0].toMapWithMemoryId(memory1.id),
        memory2.stories[0].toMapWithMemoryId(memory2.id),
        memory2.stories[1].toMapWithMemoryId(memory2.id),
        memory1.stories[1].toMapWithMemoryId(memory1.id),
      ]);

      // update memory1 to no longer have the story with id 1
      Memory updatedMemory1 = Memory(1, now, now + 5, 1,
          [Story(4, now + 5, now + 5, "Story 4!", StoryType.TEXT_STORY)]);
      // save the memory
      Memory savedMem1 = await repository.saveMemory(updatedMemory1);
      memories = await repository.fetchMemories();
      expect(memories[0], savedMem1);
      // story 1 should be deleted
      stories = await db
          .query(storiesTable, where: "$storyIdColumn = ?", whereArgs: [1]);
      expect(stories, []);
      // there should only be 3 stories now
      stories = await db.query(storiesTable);
      expect(stories, [
        memory2.stories[0].toMapWithMemoryId(memory2.id),
        memory2.stories[1].toMapWithMemoryId(memory2.id),
        memory1.stories[1].toMapWithMemoryId(memory1.id),
      ]);
    });

    test("Should be able to delete an existing memory", () async {
      // There should be 2 memories in the DB with 4 stories
      List<Memory> memories = await repository.fetchMemories();
      Memory memory1 = Memory(1, now, now + 5, 1,
          [Story(4, now + 5, now + 5, "Story 4!", StoryType.TEXT_STORY)]);
      Memory memory2 = Memory(2, now, now, 2, [
        Story(2, now, now, "Story 2!", StoryType.TEXT_STORY),
        Story(3, now, now, "Story 3!", StoryType.TEXT_STORY)
      ]);
      expect(memories, [memory1, memory2]);

      // delete memory1
      Memory deletedMemory = await repository.removeMemory(memory1);
      memories = await repository.fetchMemories();
      expect(memories, [memory2]);

      // story 4 should also be deleted
      Database db = await dbProvider.getDatabase();
      List<Map<String, dynamic>> stories = await db.query(storiesTable);
      expect(stories, [
        memory2.stories[0].toMapWithMemoryId(memory2.id),
        memory2.stories[1].toMapWithMemoryId(memory2.id)
      ]);
    });
  });
}
