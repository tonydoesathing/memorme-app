import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';

class LocalMemoryRepository extends MemoryRepository {
  List<Memory> memories;

  LocalMemoryRepository(this.memories);

  @override
  Future<List<Memory>> fetchMemories() {
    return Future(() {
      return memories;
    });
  }

  @override
  Future<Memory> saveMemory(Memory memory) {
    return Future(() {
      memories.add(memory);
      return memory;
    });
  }

  @override
  Future<Memory> removeMemory(Memory memory) {
    return Future(() {
      memories.remove(memory);
      return memory;
    });
  }
}
