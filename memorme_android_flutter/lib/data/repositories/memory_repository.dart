import 'package:memorme_android_flutter/data/models/memory.dart';

abstract class MemoryRepository {
  /// returns a list of memories
  Future<List<Memory>> fetchMemories();

  /// saves a [memory]
  Future<void> saveMemory(Memory memory);

  /// removes a [memory]
  Future<void> removeMemory(Memory memory);
}
