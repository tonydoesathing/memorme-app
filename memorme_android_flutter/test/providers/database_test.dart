import 'package:flutter_test/flutter_test.dart';
import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/data/models/collections/collection_type.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/sql_constants.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/data/providers/database_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

main() {
  DBProvider dbProvider;
  Database db;

  group("Database >", () {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    setUp(() async {
      dbProvider = DBProvider();
      db = await dbProvider.getDatabase(pathToDb: inMemoryDatabasePath);
    });

    tearDown(() async {
      db = null;
      await dbProvider.closeDatabase();
      dbProvider = null;
    });

    test("Is database set up properly?", () async {
      final tables = await db.rawQuery('SELECT name FROM sqlite_master');
      expect(tables, [
        {'name': "$story_table"},
        {'name': "$memory_table"},
        {'name': "$collection_table"},
        {'name': "$memory_collection_relationship_table"}
      ]);
    });

    test(
        "Are memory and story maps successfully stored in and retrieved from database",
        () async {
      Database db = await dbProvider.getDatabase();

      Story s = Story(
          id: 1,
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now(),
          data: "fuKC",
          type: StoryType.TEXT_STORY,
          position: 5);

      Memory m = Memory(
          id: 1,
          title: "meow",
          previewStory: s,
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now(),
          createLocation: 5,
          stories: [s]);
      int memoryid = await db.insert("$memory_table", m.toMap());

      int storyid = await db.insert("$story_table", s.toMap(m));

      List<Map> retrievedStories =
          await db.query("$story_table", where: "id = $storyid");
      Map retrievedStoryMap = retrievedStories.first;
      expect(s, Story.fromMap(retrievedStoryMap));

      List<Map> retrievedMemories =
          await (db.query("$memory_table", where: "id = $memoryid"));
      Map retrievedMemoryMap = retrievedMemories.first;
      expect(
          m,
          Memory.fromMap(
              retrievedMemoryMap, [Story.fromMap(retrievedStoryMap)]));
    });

    test(
        "Are collection maps successfully stored in and retrieved from database",
        () async {
      Collection c = Collection(
        id: 1,
        previewData: "first: 1",
        type: CollectionType.DECK,
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.now(),
        mcRelations: [],
      );
      int collectionid = await db.insert("$collection_table", c.toMap());

      List<Map> retrieved =
          await db.query("$collection_table", where: "id = $collectionid");
      Map retrievedMap = retrieved.first;
      expect(c, Collection.fromMap(retrievedMap, []));
    });

    test(
        "Are memory-collection relationships successfully stored in and retrieved from database",
        () async {
      Story s = Story(
          id: 1,
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now(),
          data: "fuKC",
          type: StoryType.TEXT_STORY,
          position: 5);

      Memory m = Memory(
          id: 1,
          title: "meow",
          previewStory: s,
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now(),
          createLocation: 5,
          stories: [s]);
      int memoryid = await db.insert("$memory_table", m.toMap());

      int storyid = await db.insert("$story_table", s.toMap(m));

      Collection c = Collection(
        id: 1,
        previewData: "1",
        type: CollectionType.DECK,
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.now(),
        mcRelations: [],
      );
      int collectionid = await db.insert("$collection_table", c.toMap());

      MCRelation mc = MCRelation(
        id: 1,
        memoryID: memoryid,
        collectionID: collectionid,
        relationshipData: "1",
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.now(),
      );
      int mcid =
          await db.insert("$memory_collection_relationship_table", mc.toMap());
      List<Map> retrieved = await db
          .query("$memory_collection_relationship_table", where: "id = $mcid");
      Map retrievedMap = retrieved.first;
      expect(mc, MCRelation.fromMap(retrievedMap));
    });

    test("Tables generate an id for inserted elements", () async {
      Story s = Story(
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now(),
          data: "fuKC",
          type: StoryType.TEXT_STORY,
          position: 5);

      Memory m = Memory(
          title: "meow",
          previewStory: s,
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now(),
          createLocation: 5,
          stories: [s]);
      int memoryid = await db.insert("$memory_table", m.toMap());
      expect(memoryid, 1);
      m = Memory.editMemory(m, id: memoryid);

      int storyid = await db.insert("$story_table", s.toMap(m));
      expect(storyid, 1);

      Collection c = Collection(
        previewData: "1",
        type: CollectionType.DECK,
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.now(),
        mcRelations: [],
      );
      int collectionid = await db.insert("$collection_table", c.toMap());
      expect(collectionid, 1);

      c = Collection.editCollection(c, id: collectionid);

      MCRelation mc = MCRelation(
        memoryID: memoryid,
        collectionID: collectionid,
        relationshipData: "1",
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.now(),
      );
      int mcid =
          await db.insert("$memory_collection_relationship_table", mc.toMap());

      expect(mcid, 1);
    });
  });
}
