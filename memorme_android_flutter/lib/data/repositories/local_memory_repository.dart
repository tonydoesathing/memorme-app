/*
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';

class LocalMemoryRepository extends MemoryRepository {
  List<Memory> memories;

  LocalMemoryRepository(this.memories);

  @override
  Future<List<Memory>> fetchMemories(int pageSize, Memory lastMemory) {
    return Future(() {
      int offset = lastMemory == null ? 0 : memories.indexOf(lastMemory) + 1;
      if (offset + pageSize > memories.length) {
        // not enough elements left for entire page size
        // just return up to the last value
        return memories.sublist(offset);
      } else {
        // return an entire page size
        return memories.sublist(offset, offset + pageSize);
      }
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
*/
