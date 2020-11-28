part of 'memories_bloc.dart';

abstract class MemoriesState extends Equatable {
  const MemoriesState();

  @override
  List<Object> get props => [];
}

/// Loading a memory in progress
class MemoriesLoadInProgress extends MemoriesState {}

/// Successfully loaded a memory
class MemoriesLoadSuccess extends MemoriesState {
  final List<Memory> memories;

  const MemoriesLoadSuccess(this.memories);

  @override
  List<Object> get props => [this.memories];
}

/// Failed loading a memory
class MemoriesLoadFailure extends MemoriesState {
  final String errorCode;
  const MemoriesLoadFailure(this.errorCode);

  @override
  List<Object> get props => [this.errorCode];
}

/// Saving memory in progress
class MemoriesSaveInProgress extends MemoriesState {}

/// Saving memory was successful
class MemoriesSaveSuccess extends MemoriesState {
  final Memory memory;
  const MemoriesSaveSuccess(this.memory);

  @override
  List<Object> get props => [this.memory];
}

/// Failed saving a memory
class MemoriesSaveFailure extends MemoriesState {
  final String errorCode;
  const MemoriesSaveFailure(this.errorCode);

  @override
  List<Object> get props => [this.errorCode];
}
