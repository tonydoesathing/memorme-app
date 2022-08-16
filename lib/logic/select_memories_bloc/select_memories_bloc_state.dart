part of 'select_memories_bloc.dart';

abstract class SelectMemoriesBlocState extends Equatable {
  final List<Memory> memories;
  final bool hasReachedMax;

  final Map<Memory, bool> selectedMemories;

  const SelectMemoriesBlocState(
      {this.memories, this.hasReachedMax, this.selectedMemories});

  @override
  List<Object> get props =>
      [this.memories, this.hasReachedMax, this.selectedMemories];
}

class SelectMemoriesBlocLoading extends SelectMemoriesBlocState {
  SelectMemoriesBlocLoading(
      {final List<Memory> memories,
      final bool hasReachedMax,
      final Map<Memory, bool> selectedMemories})
      : super(
            memories: memories,
            hasReachedMax: hasReachedMax,
            selectedMemories: selectedMemories);
}

class SelectMemoriesBlocDisplayed extends SelectMemoriesBlocState {
  SelectMemoriesBlocDisplayed(
      {final List<Memory> memories,
      final bool hasReachedMax,
      final Map<Memory, bool> selectedMemories})
      : super(
            memories: memories,
            hasReachedMax: hasReachedMax,
            selectedMemories: selectedMemories);
}

class SelectMemoriesBlocError extends SelectMemoriesBlocState {
  final error;
  SelectMemoriesBlocError(this.error,
      {final List<Memory> memories,
      final bool hasReachedMax,
      final Map<Memory, bool> selectedMemories})
      : super(
            memories: memories,
            hasReachedMax: hasReachedMax,
            selectedMemories: selectedMemories);

  @override
  List<Object> get props => [...super.props, this.error];
}
