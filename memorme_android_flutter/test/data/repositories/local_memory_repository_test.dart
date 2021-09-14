import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/search_result.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/repositories/exceptions/element_does_not_exist_exception.dart';
import 'package:memorme_android_flutter/data/repositories/local_memory_repository.dart';
import 'package:test/test.dart';

main() {
  group("Local Memory Data Repository Test >", () {
    LocalMemoryRepository repository;

    setUp(() {
      repository = LocalMemoryRepository();
    });
    test("Should return empty initial memories list", () async {
      List<Memory> mems = await repository.fetchMemories(5, null);
      expect(mems, []);
    });
    test("Should be able to save and fetch memories", () async {
      List<Story> stories = [Story(id: 1), Story(id: 2)];
      Memory m = Memory(
          id: 3,
          title: "meow",
          previewStory: stories[0],
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now(),
          stories: stories);
      List<Memory> mems = await repository.fetchMemories(5, null);
      expect(mems, []);

      await repository.saveMemory(m);

      Memory memInRepo = await repository.fetch(m.id);
      expect(memInRepo, m);
    });

    test("Saving a memory without an ID should give an ID", () async {
      Memory m = Memory(
          title: "test",
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now());
      Memory savedMem = await repository.saveMemory(m);
      expect(savedMem.id, 0);
      m = Memory.editMemory(m, id: savedMem.id);
      expect(savedMem, m);
    });

    test("Should be able to pageinate memories", () async {
      List<Memory> memories = [];
      for (int i = 0; i < 10; i++) {
        Memory savedMem = await repository.saveMemory(Memory(
            dateCreated: DateTime.now(), dateLastEdited: DateTime.now()));
        memories.add(savedMem);
      }
      memories
          .sort((a, b) => -1 * a.dateLastEdited.compareTo(b.dateLastEdited));
      expect(memories, await repository.fetchMemories(10, null));
      expect(memories.sublist(2, 4),
          await repository.fetchMemories(2, memories[1]));
      memories.sort((a, b) => a.dateLastEdited.compareTo(b.dateLastEdited));
      expect(
          memories, await repository.fetchMemories(10, null, ascending: true));
    });

    test("Should be able to remove memories", () async {
      List<Story> stories = [Story(id: 1), Story(id: 2)];
      Memory m = Memory(
          id: 3,
          title: "meow",
          previewStory: stories[0],
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now(),
          stories: stories);
      List<Memory> mems = await repository.fetchMemories(5, null);
      expect(mems, []);

      await repository.saveMemory(m);

      Memory memInRepo = await repository.fetch(m.id);
      expect(memInRepo, m);

      Memory deletedMem = await repository.removeMemory(m);
      mems = await repository.fetchMemories(5, null);
      expect(mems, []);
    });

    test("Shouldn't be able to remove memories that aren't there", () async {
      List<Story> stories = [Story(id: 1), Story(id: 2)];
      Memory m = Memory(
          id: 3,
          title: "meow",
          previewStory: stories[0],
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now(),
          stories: stories);
      List<Memory> mems = await repository.fetchMemories(5, null);
      expect(mems, []);

      expect(() async => await repository.removeMemory(m),
          throwsA(isA<ElementNotInStorageException>()));
    });
    test("Should be able to search according to query", () async {
      List<Story> stories = [Story(id: 1, data: "1"), Story(id: 2, data: "2")];
      Memory m = Memory(
          title: "Meow",
          previewStory: stories[0],
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now(),
          stories: stories);
      m = await repository.saveMemory(m);

      List<SearchResult> search = await repository.searchMemories("meow");
      expect(search.length, 1);

      Memory m2 = Memory(
          title: "2",
          previewStory: stories[0],
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now(),
          stories: stories);
      m2 = await repository.saveMemory(m2);

      search = await repository.searchMemories("2");
      expect(search.length, 2);
      expect(search[0].object, m2);
      print(search);
    });
  });
}
