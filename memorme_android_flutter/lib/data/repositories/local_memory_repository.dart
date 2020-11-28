import 'package:memorme_android_flutter/data/models/memory.dart';
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
  Future<void> saveMemory(Memory memory) {
    return Future(() {
      memories.add(memory);
    });
  }

  @override
  Future<void> removeMemory(Memory memory) {
    return Future(() {
      memories.remove(memory);
    });
  }
}
