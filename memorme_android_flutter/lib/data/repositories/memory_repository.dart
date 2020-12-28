import 'package:memorme_android_flutter/data/models/memories/memory.dart';

abstract class MemoryRepository {
  /// returns a list of memories
  Future<List<Memory>> fetchMemories();

  /// saves a [memory]
  Future<Memory> saveMemory(Memory memory);

  /// removes a [memory]
  Future<Memory> removeMemory(Memory memory);
}
