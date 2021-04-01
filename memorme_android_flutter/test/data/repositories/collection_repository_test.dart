import 'package:flutter_test/flutter_test.dart';
import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/data/providers/database_provider.dart';
import 'package:memorme_android_flutter/data/repositories/sqlite_collection_repository.dart';
import 'package:memorme_android_flutter/data/repositories/sqlite_memory_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

main(){
  
  SQLiteCollectionRepository cRepo;
  SQLiteMemoryRepository mRepo;
  // Database db;
  DBProvider dbProvider;

  group("Collection Repository >", (){
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    setUp(() async {
      dbProvider = DBProvider();
      cRepo = SQLiteCollectionRepository(dbProvider);
      mRepo = SQLiteMemoryRepository(dbProvider);
    });

    tearDown(() async {
      // db = null;
      await dbProvider.closeDatabase();
      dbProvider = null;
      cRepo = null;
      mRepo = null;
    });

    test("Can save, retrieve, and delete collections, mcrelations with text story", () async {

      Collection c1 = Collection(id: 1, previewData: "Hallo", type: 1, title: "hej", dateCreated: DateTime.now(), dateLastEdited: DateTime.fromMicrosecondsSinceEpoch(10000));
      Collection c2 = Collection(id: 2, previewData: "Hall", type: 10, title: "hejj", dateCreated: DateTime.now(), dateLastEdited: DateTime.fromMicrosecondsSinceEpoch(20000));
      Collection c3 = Collection(id: 3, previewData: "Hal", type: 100, title: "hejjj", dateCreated: DateTime.now(), dateLastEdited: DateTime.fromMicrosecondsSinceEpoch(30000));
      Collection c4 = Collection(id: 4, previewData: "Ha", type: 1000, title: "hejjjj", dateCreated: DateTime.now(), dateLastEdited: DateTime.fromMicrosecondsSinceEpoch(40000));

      Memory mem1 = Memory(id: 10);
      Memory mem2 = Memory(id: 20);
      Memory mem3 = Memory(id: 30);
      Memory mem4 = Memory(id: 40);
      Memory mem5 = Memory(id: 50);
      Memory mem6 = Memory(id: 60);
      Memory mem7 = Memory(id: 70);
      Memory mem8 = Memory(id: 80);

      MCRelation mc1 = MCRelation(id: 1, memoryID: 10, collectionID: 1, relationshipData: "Single", dateCreated: DateTime.now(), dateLastEdited: DateTime.fromMicrosecondsSinceEpoch(100000));
      MCRelation mc2 = MCRelation(id: 2, memoryID: 20, collectionID: 1, relationshipData: "Singl", dateCreated: DateTime.now(), dateLastEdited: DateTime.fromMicrosecondsSinceEpoch(200000));
      MCRelation mc3 = MCRelation(id: 3, memoryID: 30, collectionID: 1, relationshipData: "Sing", dateCreated: DateTime.now(), dateLastEdited: DateTime.fromMicrosecondsSinceEpoch(300000));
      MCRelation mc4 = MCRelation(id: 4, memoryID: 40, collectionID: 1, relationshipData: "Sin", dateCreated: DateTime.now(), dateLastEdited: DateTime.fromMicrosecondsSinceEpoch(400000));
      MCRelation mc5 = MCRelation(id: 5, memoryID: 50, collectionID: 2, relationshipData: "Si", dateCreated: DateTime.now(), dateLastEdited: DateTime.fromMicrosecondsSinceEpoch(500000));
      MCRelation mc6 = MCRelation(id: 6, memoryID: 60, collectionID: 2, relationshipData: "S", dateCreated: DateTime.now(), dateLastEdited: DateTime.fromMicrosecondsSinceEpoch(600000));
      MCRelation mc7 = MCRelation(id: 7, memoryID: 70, collectionID: 3, relationshipData: "So", dateCreated: DateTime.now(), dateLastEdited: DateTime.fromMicrosecondsSinceEpoch(700000));
      MCRelation mc8 = MCRelation(id: 8, memoryID: 80, collectionID: 4, relationshipData: "Sou", dateCreated: DateTime.now(), dateLastEdited: DateTime.fromMicrosecondsSinceEpoch(800000));

      // Check if everything saves properly

      await cRepo.saveCollection(c1);
      await cRepo.saveCollection(c2);
      await cRepo.saveCollection(c3);
      await cRepo.saveCollection(c4);
      await mRepo.saveMemory(mem1);
      await mRepo.saveMemory(mem2);
      await mRepo.saveMemory(mem3);
      await mRepo.saveMemory(mem4);
      await mRepo.saveMemory(mem5);
      await mRepo.saveMemory(mem6);
      await mRepo.saveMemory(mem7);
      await mRepo.saveMemory(mem8);
      await cRepo.saveMCRelation(mc1);
      await cRepo.saveMCRelation(mc2);
      await cRepo.saveMCRelation(mc3);
      await cRepo.saveMCRelation(mc4);
      await cRepo.saveMCRelation(mc5);
      await cRepo.saveMCRelation(mc6);
      await cRepo.saveMCRelation(mc7);
      await cRepo.saveMCRelation(mc8);

      expect(await cRepo.fetchCollections(8, null), [c4, c3, c2, c1]);
      expect(await cRepo.fetchMCRelations(c1, 10, null), [mc4, mc3, mc2, mc1]);
      expect(await cRepo.fetchMCRelations(c2, 2, null), [mc6, mc5]);
      expect(await cRepo.fetchMCRelations(c3, 2, null), [mc7]);
      expect(await cRepo.fetchMCRelations(c4, 1, null), [mc8]);

      // Check if everything deletes

      cRepo.removeCollection(c1);
      cRepo.removeCollection(c2);

      expect(await cRepo.fetch(1), null);
      expect(await cRepo.fetchMCRelations(c1, 10, null), []);
      expect(await cRepo.fetch(2), null);
      expect(await cRepo.fetchMCRelations(c2, 10, null), []);
      expect(await cRepo.fetch(3), c3);
      expect(await cRepo.fetchMCRelations(c3, 2, null), [mc7]);
      expect(await cRepo.fetch(4), c4);
      expect(await cRepo.fetchMCRelations(c4, 1, null), [mc8]);
      
      cRepo.removeMCRelation(mc8);
      expect(await cRepo.fetch(4), c4);
      expect(await cRepo.fetchMCRelations(c4, 1, null), []);

    });

    test("Can fetch mcrelations of various page sizes", () async {

      Collection c1 = Collection(id: 1, previewData: "Hallo", type: 1, title: "hej", dateCreated: DateTime.now(), dateLastEdited: DateTime.fromMicrosecondsSinceEpoch(10000));

      Memory mem1 = Memory(id: 10);
      Memory mem2 = Memory(id: 20);
      Memory mem3 = Memory(id: 30);
      Memory mem4 = Memory(id: 40);

      MCRelation mc1 = MCRelation(id: 1, memoryID: 10, collectionID: 1, relationshipData: "Single", dateCreated: DateTime.now(), dateLastEdited: DateTime.fromMicrosecondsSinceEpoch(100000));
      MCRelation mc2 = MCRelation(id: 2, memoryID: 20, collectionID: 1, relationshipData: "Singl", dateCreated: DateTime.now(), dateLastEdited: DateTime.fromMicrosecondsSinceEpoch(200000));
      MCRelation mc3 = MCRelation(id: 3, memoryID: 30, collectionID: 1, relationshipData: "Sing", dateCreated: DateTime.now(), dateLastEdited: DateTime.fromMicrosecondsSinceEpoch(300000));
      MCRelation mc4 = MCRelation(id: 4, memoryID: 40, collectionID: 1, relationshipData: "Sin", dateCreated: DateTime.now(), dateLastEdited: DateTime.fromMicrosecondsSinceEpoch(400000));

      await cRepo.saveCollection(c1);
      await mRepo.saveMemory(mem1);
      await mRepo.saveMemory(mem2);
      await mRepo.saveMemory(mem3);
      await mRepo.saveMemory(mem4);
      await cRepo.saveMCRelation(mc1);
      await cRepo.saveMCRelation(mc2);
      await cRepo.saveMCRelation(mc3);
      await cRepo.saveMCRelation(mc4);

      // retrieve various mcrelations combinations from first collection

      expect(await cRepo.fetchMCRelations(c1, 10, null), [mc4, mc3, mc2, mc1]);
      expect(await cRepo.fetchMCRelations(c1, 4, null), [mc4, mc3, mc2, mc1]);
      expect(await cRepo.fetchMCRelations(c1, 3, null), [mc4, mc3, mc2]);
      expect(await cRepo.fetchMCRelations(c1, 3, null), [mc4, mc3, mc2]);
      expect(await cRepo.fetchMCRelations(c1, 2, mc3), [mc2, mc1]);
      expect(await cRepo.fetchMCRelations(c1, 2, mc2), [mc1]);
      expect(await cRepo.fetchMCRelations(c1, 1, mc1), []);
      expect(await cRepo.fetchMCRelations(c1, 0, mc1), []);
      

    });
  });
}