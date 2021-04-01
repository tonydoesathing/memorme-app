// import 'package:memorme_android_flutter/data/models/memories/memory.dart';
// import 'package:memorme_android_flutter/data/models/stories/story.dart';
// import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
// import 'package:memorme_android_flutter/data/providers/sqlite_db_provider.dart';
// import 'package:memorme_android_flutter/data/repositories/sqlite_memory_repository.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:test/test.dart';

// //TODO: [MMA-108] Fix sqlite test

// main() {
//   //switch sqflite to be in FFI mode
//   sqfliteFfiInit();
//   databaseFactory = databaseFactoryFfi;

//   //SQLite repository and provider
//   SQLiteMemoryRepository repository;
//   SQLiteDBProvider dbProvider;

//   final int allPageSize = 30;

//   group("Local Memory Data Repository Test >", () {
//     setUp(() async {
//       //initialize the provider and repository
//       dbProvider =
//           SQLiteDBProvider.memorMeSQLiteDBProvider(path: inMemoryDatabasePath);
//       repository = SQLiteMemoryRepository(dbProvider);
//     });

//     tearDown(() async {
//       //clean up the provider and repository
//       await dbProvider.closeDatabase();
//       dbProvider = null;
//       repository = null;
//     });
//     test("On creations of repository should create Memories and Stories tables",
//         () async {
//       await repository.fetchMemories(allPageSize, null);
//       Database db = await dbProvider.getDatabase();
//       // get all the tables in the database
//       final tables = await db.rawQuery('SELECT name FROM sqlite_master');
//       expect(tables, [
//         {'name': "$memoriesTable"},
//         {'name': "$storiesTable"}
//       ]);
//     });
//     test("Should return empty initial memories list", () async {
//       List<Memory> memories = await repository.fetchMemories(allPageSize, null);
//       expect(memories, []);
//     });
//     test("Should be able to save new memories", () async {
//       List<Memory> memories = await repository.fetchMemories(allPageSize, null);
//       expect(memories, []);
//       // by leaving id null, SQLite will assign an id
//       int now = DateTime.now().millisecondsSinceEpoch;
//       Memory memory1 = Memory(id: null, dateCreated: now, dateLastEdited: now, storyPreviewId: 1, stories: 
//           [Story(id: null, dateCreated: now, dateLastEdited: now, data: "Story 1!", type: StoryType.TEXT_STORY)]);
//       // save memory1
//       Memory savedMem1 = await repository.saveMemory(memory1);
//       // fetch the memories
//       memories = await repository.fetchMemories(allPageSize, null);
//       // the only memory in the db should be memory1 (primary keys start at 1 in SQLite)
//       expect(memories[0], savedMem1);

//       Memory memory2 = Memory(id: null, dateCreated: now, dateLastEdited: now, storyPreviewId: 2, stories: [
//         Story(id: null, dateCreated: now, dateLastEdited: now, data: "Story 2!", type: StoryType.TEXT_STORY),
//         Story(id: null, dateCreated: now, dateLastEdited: now, data: "Story 3!", type: StoryType.TEXT_STORY)
//       ]);
//       Memory savedMem2 = await repository.saveMemory(memory2);
//       memories = await repository.fetchMemories(allPageSize, null);
//       expect(memories[1], savedMem2);
//     });

//     test("Should be able to update old memories with new stories", () async {
//       List<Memory> memories = await repository.fetchMemories(allPageSize, null);
//       //add memories to db
//       int now = DateTime.now().millisecondsSinceEpoch;
//       Memory memory1 = Memory(id: null, dateCreated: now, dateLastEdited: now, storyPreviewId: 1, stories: 
//           [Story(id: null, dateCreated: now, dateLastEdited: now, data: "Story 1!", type: StoryType.TEXT_STORY)]);
//       // save memory1
//       Memory savedMem1 = await repository.saveMemory(memory1);

//       Memory memory2 = Memory(id: null, dateCreated: now, dateLastEdited: now, storyPreviewId: 2, stories: [
//         Story(id: null, dateCreated: now, dateLastEdited: now, data: "Story 2!", type: StoryType.TEXT_STORY),
//         Story(id: null, dateCreated: now, dateLastEdited: now, data: "Story 3!", type: StoryType.TEXT_STORY)
//       ]);
//       Memory savedMem2 = await repository.saveMemory(memory2);
//       memories = await repository.fetchMemories(allPageSize, null);

//       //new memories should be in there
//       expect(memories.contains(savedMem1), true);
//       expect(memories.contains(savedMem2), true);
//       // update memory 1 with a new story
//       now = DateTime.now().millisecondsSinceEpoch;
//       final List<Story> stories = [
//         ...savedMem1.stories,
//         Story(id: null, dateCreated: now, dateLastEdited: now, data: "Story 4!", type: StoryType.TEXT_STORY)
//       ];
//       Memory updatedMemory1 = Memory(id: savedMem1.id, dateCreated: savedMem1.dateCreated, dateLastEdited: now, storyPreviewId: savedMem1.storyPreviewId, stories: stories);
//       Memory savedUpdatedMem1 = await repository.saveMemory(updatedMemory1);
//       memories = await repository.fetchMemories(allPageSize, null);
//       expect(memories.contains(savedUpdatedMem1), true);
//     });

//     test("Should be able to update old memories by removing stories", () async {
//       List<Memory> memories = await repository.fetchMemories(allPageSize, null);
//       //add memories to db
//       int now = DateTime.now().millisecondsSinceEpoch;
//       Memory memory1 = Memory(id: null, dateCreated: now, dateLastEdited: now, storyPreviewId: 1, stories: 
//           [Story(id: null, dateCreated: now, dateLastEdited: now, data: "Story 1!", type: StoryType.TEXT_STORY)]);
//       // save memory1
//       Memory savedMem1 = await repository.saveMemory(memory1);

//       Memory memory2 = Memory(id: null, dateCreated: now, dateLastEdited: now, storyPreviewId: 2, stories: [
//         Story(id: null, dateCreated: now, dateLastEdited: now, data: "Story 2!", type: StoryType.TEXT_STORY),
//         Story(id: null, dateCreated: now, dateLastEdited: now, data: "Story 3!", type: StoryType.TEXT_STORY)
//       ]);
//       Memory savedMem2 = await repository.saveMemory(memory2);
//       memories = await repository.fetchMemories(allPageSize, null);

//       //new memories should be in there
//       expect(memories.contains(savedMem1), true);
//       expect(memories.contains(savedMem2), true);

//       // there should be 1 story with the id of memory2's 1st story id
//       Database db = await dbProvider.getDatabase();
//       List<Map<String, dynamic>> stories = await db.query(storiesTable,
//           where: "$storyIdColumn = ?", whereArgs: [savedMem2.stories[0].id]);
//       expect(stories, [savedMem2.stories[0].toMapWithMemoryId(savedMem2.id)]);

//       // check number of stories
//       stories = await db.query(storiesTable);
//       int oldNumStories = stories.length;

//       // update memory2 to no longer have its first story
//       now = DateTime.now().millisecondsSinceEpoch;
//       Story deletedStory = savedMem2.stories.removeAt(0);
//       Memory updatedMemory2 = Memory.editMemory(savedMem2,
//           dateLastEdited: now, storyPreviewId: savedMem2.stories[0].id);
//       // save the memory
//       Memory savedUpdatedMem2 = await repository.saveMemory(updatedMemory2);
//       memories = await repository.fetchMemories(allPageSize, null);
//       expect(memories.contains(savedUpdatedMem2), true);
//       // story 1 should be deleted
//       stories = await db.query(storiesTable,
//           where: "$storyIdColumn = ?", whereArgs: [deletedStory.id]);
//       expect(stories, []);
//       // there should be 1 fewer story
//       stories = await db.query(storiesTable);
//       expect(stories.length, oldNumStories - 1);
//     });

//     test("Should be able to delete an existing memory", () async {
//       List<Memory> memories = await repository.fetchMemories(allPageSize, null);
//       //add memory to db
//       int now = DateTime.now().millisecondsSinceEpoch;
//       Memory memory1 = Memory(id: null, dateCreated: now, dateLastEdited: now, storyPreviewId: 1, stories: 
//           [Story(id: null, dateCreated: now, dateLastEdited: now, data: "Story 1!", type: StoryType.TEXT_STORY)]);
//       // save memory1
//       Memory savedMem1 = await repository.saveMemory(memory1);
//       //new memory should be in there
//       memories = await repository.fetchMemories(allPageSize, null);
//       expect(memories.contains(savedMem1), true);

//       // get stories
//       Database db = await dbProvider.getDatabase();
//       List<Map<String, dynamic>> stories = await db.query(storiesTable);
//       int oldStoriesSize = stories.length;

//       // delete memory1
//       Memory deletedMemory = await repository.removeMemory(savedMem1);
//       memories = await repository.fetchMemories(allPageSize, null);
//       expect(memories.contains(deletedMemory), false);

//       // story should be deleted
//       stories = await db.query(storiesTable,
//           where: "$storyIdColumn = ?",
//           whereArgs: [deletedMemory.stories[0].id]);
//       expect(stories, []);
//       stories = await db.query(storiesTable);
//       // stories length should be 1 fewer than old stories length
//       expect(stories.length, oldStoriesSize - 1);
//     });

//     test("Should be able to pageinate memories", () async {
//       final pageSize = 3;
//       List<Memory> memories = await repository.fetchMemories(allPageSize, null);
//       //add a memory
//       int now = DateTime.now().millisecondsSinceEpoch;
//       Memory initialSavedMem = await repository.saveMemory(Memory(id: null, dateCreated: now, dateLastEdited: now, storyPreviewId: 0, stories: 
//         [Story(id: null, dateCreated: now, dateLastEdited: now, data: "Story 1!", type: StoryType.TEXT_STORY)]));

//       //get page with last memory being the one we just inserted
//       memories = await repository.fetchMemories(pageSize, initialSavedMem);
//       //it should be empty
//       expect(memories, []);

//       //add 7 memories
//       List<Memory> addedMems = [];
//       for (int i = 0; i < 7; i++) {
//         now = DateTime.now().millisecondsSinceEpoch;
//         Story story = Story(id: i, dateCreated: now, dateLastEdited: now, data: "Story #$i", type: StoryType.TEXT_STORY);
//         Memory memory = Memory(id: i, dateCreated: now, dateLastEdited: now, storyPreviewId: i, stories: [story]);
//         memory = await repository.saveMemory(memory);
//         addedMems.add(memory);
//       }

//       //db should have added memories
//       memories = await repository.fetchMemories(allPageSize, null);
//       for (Memory mem in addedMems) {
//         expect(memories.contains(mem), true);
//       }

//       //fetch the first page of memories
//       memories = await repository.fetchMemories(3, initialSavedMem);
//       //should be the first 3
//       expect(memories, addedMems.sublist(0, 3));
//       //fetch the next page of memories
//       memories =
//           await repository.fetchMemories(3, memories[memories.length - 1]);
//       //should be the next 3
//       expect(memories, addedMems.sublist(3, 6));
//       //fetch the last page of memories
//       memories =
//           await repository.fetchMemories(3, memories[memories.length - 1]);
//       //should be the last memory
//       expect(memories, addedMems.sublist(6));
//       //fetch again
//       memories =
//           await repository.fetchMemories(3, memories[memories.length - 1]);
//       //should be an empty list
//       expect(memories, []);
//     });
//   });
// }
