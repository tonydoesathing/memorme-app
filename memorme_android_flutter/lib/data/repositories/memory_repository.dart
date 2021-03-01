import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';

abstract class MemoryRepository {
  /// returns a list of memories with size [pageSize] after [offset] (inclusive)
  Future<List<Memory>> fetchMemories(int pageSize, Memory lastMemory);

  /// saves a [memory]
  Future<Memory> saveMemory(Memory memory);

  /// removes a [memory]
  Future<Memory> removeMemory(Memory memory);
}
