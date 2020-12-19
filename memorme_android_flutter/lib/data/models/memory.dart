import 'package:equatable/equatable.dart';
import 'package:memorme_android_flutter/models/memory.dart' as OldMemory;

class Memory extends Equatable {
  final List<String> media;
  final List<String> stories;

  /// stores lists of [media] and [stories]
  const Memory(this.media, this.stories);

  @override
  List<Object> get props => [media, stories];

  factory Memory.fromOldMemory(OldMemory.Memory memory) {
    return Memory(memory.getAllMedia(), memory.getAllStories());
  }
}
