part of 'memories_bloc.dart';

abstract class MemoriesEvent extends Equatable {
  const MemoriesEvent();

  @override
  List<Object> get props => [];
}

/// Add [memory] to [memories]
class MemoriesMemoryAdded extends MemoriesEvent {
  final Memory memory;
  const MemoriesMemoryAdded(this.memory);

  @override
  List<Object> get props => [this.memory];
}

/// Remove [memory] from [memories]
class MemoriesMemoryRemoved extends MemoriesEvent {
  final Memory memory;
  const MemoriesMemoryRemoved(this.memory);

  @override
  List<Object> get props => [this.memory];
}

/// Update [memory] in [memories]
class MemoriesMemoryUpdated extends MemoriesEvent {
  final Memory memory;
  const MemoriesMemoryUpdated(this.memory);

  @override
  List<Object> get props => [this.memory];
}

/// Fetch [memories]
class MemoriesLoaded extends MemoriesEvent {}
