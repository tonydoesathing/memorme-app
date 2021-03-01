import 'package:flutter_test/flutter_test.dart';
import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/sql_constants.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/providers/database_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  DBProvider dbProvider;
  Database db;

  group("Mapping", () {
    test("Do memory maps work", () {
      Memory m = Memory("First Memory", 10, 100, 1000);
      Map mappedM = m.toMap();
      Memory unmappedM = Memory.fromMap(mappedM);
      expect(m, unmappedM);
    });

    test("Do story maps work", () {
      Story s = Story(1, 8, 80, "SampleText", 800, -1);
      Map mappedS = s.toMap();
      Story unmappedS = Story.fromMap(mappedS);
      expect(s, unmappedS);
    });

    test("Do collection maps work", () {
      Collection c = Collection("a", 3, "b", 70, 90);
      Map mappedC = c.toMap();
      Collection unmappedC = Collection.fromMap(mappedC);
      expect(c, unmappedC);
    });

    test("Do memory-collection object maps work", () {
      MCData mc = MCData(1, 2, "relationshipData", 400000, 8000000);
      Map mappedMC = mc.toMap();
      MCData unmappedMC = MCData.fromMap(mappedMC);
      expect(mc, unmappedMC);
    });
  });

  group("Database", () {
    setUp(() async {
      sqfliteFfiInit();
      dbProvider = DBProvider();

      // copies db_provider init_database because "openDatabase" method needs to use databaseFactoryFfi
      String directory = await databaseFactoryFfi.getDatabasesPath();
      String dbPath = join(directory, "MemorMe.db");
      OpenDatabaseOptions dbOptions = dbProvider.options;
      db = await databaseFactoryFfi.openDatabase(dbPath, options: dbOptions);
    });

    tearDown(() async {
      await db.delete("$story_table");
      await db.delete("$memory_collection_relationship_table");
      await db.delete("$memory_table");
      await db.delete("$collection_table");
    });

    test(
        "Are memory and story maps successfully stored in and retrieved from database",
        () async {
      Memory m = Memory("First Memory", 10, 100, 1000);
      int memoryid = await db.insert("$memory_table", m.toMap());

      Story s = Story(memoryid, 8, 80, "SampleText", 800, -1);
      int storyid = await db.insert("$story_table", s.toMap());

      List<Map> retrieved =
          await (db.query("$memory_table", where: "id = $memoryid"));
      Map retrievedMap = retrieved.first;
      expect(m, Memory.fromMap(retrievedMap));

      retrieved = await db.query("$story_table", where: "id = $storyid");
      retrievedMap = retrieved.first;
      expect(s, Story.fromMap(retrievedMap));
    });

    test(
        "Are collection maps successfully stored in and retrieved from database",
        () async {
      Collection c = Collection("a", 3, "b", 70, 90);
      int collectionid = await db.insert("$collection_table", c.toMap());

      List<Map> retrieved =
          await db.query("$collection_table", where: "id = $collectionid");
      Map retrievedMap = retrieved.first;
      expect(c, Collection.fromMap(retrievedMap));
    });

    test(
        "Are memory-collection relationships successfully stored in and retrieved from database",
        () async {
      Memory m = Memory("First Memory", 10, 100, 1000);
      int memoryid = await db.insert("$memory_table", m.toMap());
      Collection c = Collection("a", 3, "b", 70, 90);
      int collectionid = await db.insert("$collection_table", c.toMap());

      MCData mc =
          MCData(memoryid, collectionid, "relationshipData", 90, 98989898);
      int mcid =
          await db.insert("$memory_collection_relationship_table", mc.toMap());
      List<Map> retrieved = await db
          .query("$memory_collection_relationship_table", where: "id = $mcid");
      Map retrievedMap = retrieved.first;
      expect(mc, MCData.fromMap(retrievedMap));
    });
  });
}
