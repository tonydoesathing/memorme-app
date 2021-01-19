import 'dart:math';

import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/data/repositories/local_memory_repository.dart';
import 'package:test/test.dart';

main() {
  group("Local Memory Data Repository Test >", () {
    LocalMemoryRepository repository;

    setUp(() {
      repository = LocalMemoryRepository([]);
    });
    test("Should return empty initial memories list", () {
      repository
          .fetchMemories(15, null)
          .then((memories) => expect(memories, []));
    });
    test("Should be able to save memories", () {
      repository
          .fetchMemories(15, null)
          .then((memories) => expect(memories, []));
      int now = DateTime.now().millisecondsSinceEpoch;
      Memory memory1 = Memory(id: 1, dateCreated: now, dateLastEdited: now, storyPreviewId: 0, stories: []);
      repository.saveMemory(memory1);
      repository
          .fetchMemories(15, null)
          .then((memories) => expect(memories[0], memory1));
      Memory memory2 = Memory(id: 2, dateCreated: now, dateLastEdited: now, storyPreviewId: 0, stories: []);
      repository.saveMemory(memory2);
      repository
          .fetchMemories(15, null)
          .then((memories) => expect(memories[1], memory2));
    });

    test("Should be able to pageinate memories", () async {
      final pageSize = 3;
      List<Memory> memories = await repository.fetchMemories(pageSize, null);
      expect(memories, []);
      //add 7 memories
      List<Memory> addedMems = [];
      for (int i = 0; i < 7; i++) {
        int now = DateTime.now().millisecondsSinceEpoch;
        Story story = Story(id: i, dateCreated: now, dateLastEdited: now, data: "Story #$i", type: StoryType.TEXT_STORY);
        Memory memory = Memory(id: i, dateCreated: now, dateLastEdited: now, storyPreviewId: i, stories: [story]);
        addedMems.add(memory);
        await repository.saveMemory(memory);
      }
      memories = await repository.fetchMemories(15, null);
      expect(memories, addedMems);
      //fetch the first page of memories
      memories = await repository.fetchMemories(3, null);
      //should be the first 3
      expect(memories, addedMems.sublist(0, 3));
      //fetch the next page of memories
      memories =
          await repository.fetchMemories(3, memories[memories.length - 1]);
      //should be the next 3
      expect(memories, addedMems.sublist(3, 6));
      //fetch the last page of memories
      memories =
          await repository.fetchMemories(3, memories[memories.length - 1]);
      //should be the last memory
      expect(memories, addedMems.sublist(6));
      //fetch again
      memories =
          await repository.fetchMemories(3, memories[memories.length - 1]);
      //should be an empty list
      expect(memories, []);
    });

    test("Should be able to remove memories", () async {
      List<Memory> memories = await repository.fetchMemories(15, null);
      expect(memories, []);

      int now = DateTime.now().millisecondsSinceEpoch;
      Memory memory1 = Memory(id: 1, dateCreated: now, dateLastEdited: now, storyPreviewId: 0, stories: []);
      await repository.saveMemory(memory1);
      memories = await repository.fetchMemories(15, null);
      expect(memories[0], memory1);

      Memory memory2 = Memory(id: 2, dateCreated: now, dateLastEdited: now, storyPreviewId: 0, stories: []);
      await repository.saveMemory(memory2);
      memories = await repository.fetchMemories(15, null);
      expect(memories[1], memory2);

      await repository.removeMemory(memory1);
      memories = await repository.fetchMemories(15, null);
      expect(memories[0], memory2);

      await repository.removeMemory(memory2);
      memories = await repository.fetchMemories(15, null);
      expect(memories, []);
    });
  });
}
