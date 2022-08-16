import 'package:flutter_test/flutter_test.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/data/providers/database_provider.dart';
import 'package:memorme_android_flutter/data/repositories/sqlite_memory_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

main(){
  
  SQLiteMemoryRepository mRepo;
  // Database db;
  DBProvider dbProvider;

  group("Memory Repository >", (){
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    
    setUp(() async {
      dbProvider = DBProvider();
      mRepo = SQLiteMemoryRepository(dbProvider);
    });

    tearDown(() async {
      // db = null;
      await dbProvider.closeDatabase();
      dbProvider = null;
      mRepo = null;
    });

    test("Can save, retrieve, and delete memory with text story", () async {
      
      Story s1 = Story(
        id: 1,
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.now(),
        data: "hallo",
        type: StoryType.TEXT_STORY,
        position: 1
      );
      
      Story s2 = Story(
        id: 2,
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.now(),
        data: "hallo",
        type: StoryType.TEXT_STORY,
        position: 2
      );

      Memory m = Memory(
          id: 1,
          title: "ee",
          previewStory: s1,
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now(),
          createLocation: 5,
          stories: [s1, s2]);

      Memory savedM = await mRepo.saveMemory(m);
      expect(savedM, m);

      Memory retrievedM = await mRepo.fetch(m.id);
      expect(retrievedM, m);

      Memory deletedM = await mRepo.removeMemory(m);
      expect(deletedM, m);
    });

    test("Can fetch four memories of various page sizes", () async {
      Story s1 = Story(
        id: 1,
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.now(),
        data: "hallo",
        type: StoryType.TEXT_STORY,
        position: 1
      );
      Story s2 = Story(
        id: 2,
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.now(),
        data: "hallo",
        type: StoryType.TEXT_STORY,
        position: 2
      );
      Story s3 = Story(
        id: 3,
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.now(),
        data: "hallo",
        type: StoryType.TEXT_STORY,
        position: 3
      );
      Story s4 = Story(
        id: 4,
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.now(),
        data: "hallo",
        type: StoryType.TEXT_STORY,
        position: 4
      );
      Story s5 = Story(
        id: 5,
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.now(),
        data: "hallo",
        type: StoryType.TEXT_STORY,
        position: 5
      );
      Story s6 = Story(
        id: 6,
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.now(),
        data: "hallo",
        type: StoryType.TEXT_STORY,
        position: 6
      );
      Story s7 = Story(
        id: 7,
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.now(),
        data: "hallo",
        type: StoryType.TEXT_STORY,
        position: 7
      );
      Story s8 = Story(
        id: 8,
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.now(),
        data: "hallo",
        type: StoryType.TEXT_STORY,
        position: 8
      );

      Memory m1 = Memory(
        id: 1,
        title: "ee",
        previewStory: s1,
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.fromMicrosecondsSinceEpoch(1000),
        createLocation: 5,
        stories: [s1, s2]
      );
      await mRepo.saveMemory(m1);
      Memory m2 = Memory(
        id: 2,
        title: "ee",
        previewStory: s3,
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.fromMicrosecondsSinceEpoch(2000),
        createLocation: 5,
        stories: [s3, s4]
      );
      await mRepo.saveMemory(m2);
      Memory m3 = Memory(
        id: 3,
        title: "ee",
        previewStory: s5,
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.fromMicrosecondsSinceEpoch(3000),
        createLocation: 5,
        stories: [s5, s6]
      );
      await mRepo.saveMemory(m3);
      Memory m4 = Memory(
        id: 4,
        title: "ee",
        previewStory: s7,
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.fromMicrosecondsSinceEpoch(4000),
        createLocation: 5,
        stories: [s7, s8]
      );
      await mRepo.saveMemory(m4);

      // Check if all memories fetchable
      List<Memory> mems = await mRepo.fetchMemories(4, null);
      expect(mems.first, m4);
      expect(mems[1], m3);
      expect(mems[2], m2);
      expect(mems.last, m1);

      // Check if first two memories fetched are most recent
      mems = await mRepo.fetchMemories(2, null);
      expect(mems.first, m4);
      expect(mems.last, m3);

      // Check if next two memories fetched are second most recent
      mems = await mRepo.fetchMemories(2, mems.last);
      expect(mems.first, m2);
      expect(mems.last, m1);

      // Check if only returns one memory when page size is 2, but only one fits criteria
      mems = await mRepo.fetchMemories(2, mems.first);
      expect(mems.first, m1);
      expect(mems.last, m1);
    });

    test("Can remove stories", () async {
      Story s1 = Story(id: 1, dateCreated: DateTime.now(), dateLastEdited: DateTime.now(), data: "hallo", type: StoryType.TEXT_STORY, position: 1);
      Story s2 = Story(id: 2, dateCreated: DateTime.now(), dateLastEdited: DateTime.now(), data: "hallo", type: StoryType.TEXT_STORY, position: 2);
      Story s3 = Story(id: 3, dateCreated: DateTime.now(), dateLastEdited: DateTime.now(), data: "hallo", type: StoryType.TEXT_STORY, position: 3);
      Story s4 = Story(id: 4, dateCreated: DateTime.now(), dateLastEdited: DateTime.now(), data: "hallo", type: StoryType.TEXT_STORY, position: 4);
      Memory m1 = Memory(id: 1, title: "ee", previewStory: s1, dateCreated: DateTime.now(), dateLastEdited: DateTime.fromMicrosecondsSinceEpoch(1000), createLocation: 5, stories: [s1, s2, s3, s4]);

      // save memory then remove its stories

      m1 = await mRepo.saveMemory(m1);
      Story ret1 = await mRepo.removeStory(m1.stories[0]);
      Story ret2 = await mRepo.removeStory(m1.stories[1]);
      Story ret3 = await mRepo.removeStory(m1.stories[2]);
      Story ret4 = await mRepo.removeStory(m1.stories[3]);

      expect(ret1, m1.stories[0]);
      expect(ret2, m1.stories[1]);
      expect(ret3, m1.stories[2]);
      expect(ret4, m1.stories[3]);

      // remove stories that don't exist
      ret1 = await mRepo.removeStory(m1.stories[0]);
      ret2 = await mRepo.removeStory(m1.stories[1]);
      ret3 = await mRepo.removeStory(m1.stories[2]);
      ret4 = await mRepo.removeStory(m1.stories[3]);

      expect(ret1, null);
      expect(ret2, null);
      expect(ret3, null);
      expect(ret4, null);

    });

    test("Can save picture stories", () async {
      Story s1 = Story(id: 1, dateCreated: DateTime.now(), dateLastEdited: DateTime.now(), data: "hallo", type: StoryType.PICTURE_STORY, position: 1);
      Memory m1 = Memory(id: 1, title: "ee", previewStory: s1, dateCreated: DateTime.now(), dateLastEdited: DateTime.fromMicrosecondsSinceEpoch(1000), createLocation: 5, stories: [s1]);

      m1 = await mRepo.saveMemory(m1);
      Story ret1 = await mRepo.removeStory(m1.stories[0]);

      expect(ret1, !null);
      expect(ret1, m1.stories[0]);

    });

  });
}