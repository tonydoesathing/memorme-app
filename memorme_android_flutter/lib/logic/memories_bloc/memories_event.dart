part of 'memories_bloc.dart';

abstract class MemoriesEvent extends Equatable {
  const MemoriesEvent();

  @override
  List<Object> get props => [];
}

/// Update [memory] in [memories]
class MemoriesBlocUpdateMemory extends MemoriesEvent {
  final Memory memory;
  const MemoriesBlocUpdateMemory(this.memory);

  @override
  List<Object> get props => [this.memory];
}

/// Fetch [memories] from optional [fromStart]
class MemoriesBlocLoadMemories extends MemoriesEvent {
  final bool fromStart;

  MemoriesBlocLoadMemories(this.fromStart);
}
