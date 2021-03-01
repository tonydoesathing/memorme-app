import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';

abstract class MemoryRepository {
  /// returns a list of memories with size [pageSize] after [offset] (inclusive)
  /// and sorts it by date last edited and optional [ascending] bool; defaults to false
  Future<List<Memory>> fetchMemories(int pageSize, Memory lastMemory,
      {bool ascending = false});

  /// fetches a [Memory] by its [id]
  Future<Memory> fetch(int id);

  /// saves the [memory]
  Future<Memory> saveMemory(Memory memory);

  /// removes the [memory]
  Future<Memory> removeMemory(Memory memory);
}
