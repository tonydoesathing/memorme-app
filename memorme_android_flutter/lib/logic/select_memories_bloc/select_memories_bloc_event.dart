part of 'select_memories_bloc.dart';

abstract class SelectMemoriesBlocEvent extends Equatable {
  const SelectMemoriesBlocEvent();

  @override
  List<Object> get props => [];
}

/// Fetch [memories] from optional [fromStart]
class SelectMemoriesBlocLoadMemories extends SelectMemoriesBlocEvent {
  final bool fromStart;

  SelectMemoriesBlocLoadMemories(this.fromStart);

  @override
  List<Object> get props => [this.fromStart];
}

class SelectMemoriesBlocSelectMemory extends SelectMemoriesBlocEvent {
  final Memory selectedMemory;

  SelectMemoriesBlocSelectMemory(this.selectedMemory);

  @override
  List<Object> get props => [this.selectedMemory];
}

class SelectMemoriesBlocUnselectMemory extends SelectMemoriesBlocEvent {
  final Memory unselectedMemory;

  SelectMemoriesBlocUnselectMemory(this.unselectedMemory);

  @override
  List<Object> get props => [this.unselectedMemory];
}
