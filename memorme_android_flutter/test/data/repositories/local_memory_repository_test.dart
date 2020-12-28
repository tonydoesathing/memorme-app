import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/repositories/local_memory_repository.dart';
import 'package:test/test.dart';

main() {
  group("Local Memory Data Repository Test >", () {
    LocalMemoryRepository repository;

    setUp(() {
      repository = LocalMemoryRepository([]);
    });
    test("Should return empty initial memories list", () {
      repository.fetchMemories().then((memories) => expect(memories, []));
    });
    test("Should be able to save memories", () {
      repository.fetchMemories().then((memories) => expect(memories, []));
      int now = DateTime.now().millisecondsSinceEpoch;
      Memory memory1 = Memory(1, now, now, 0, []);
      repository.saveMemory(memory1);
      repository
          .fetchMemories()
          .then((memories) => expect(memories[0], memory1));
      Memory memory2 = Memory(2, now, now, 0, []);
      repository.saveMemory(memory2);
      repository
          .fetchMemories()
          .then((memories) => expect(memories[1], memory2));
    });

    test("Should be able to remove memories", () async {
      List<Memory> memories = await repository.fetchMemories();
      expect(memories, []);

      int now = DateTime.now().millisecondsSinceEpoch;
      Memory memory1 = Memory(1, now, now, 0, []);
      await repository.saveMemory(memory1);
      memories = await repository.fetchMemories();
      expect(memories[0], memory1);

      Memory memory2 = Memory(2, now, now, 0, []);
      await repository.saveMemory(memory2);
      memories = await repository.fetchMemories();
      expect(memories[1], memory2);

      await repository.removeMemory(memory1);
      memories = await repository.fetchMemories();
      expect(memories[0], memory2);

      await repository.removeMemory(memory2);
      memories = await repository.fetchMemories();
      expect(memories, []);
    });
  });
}
