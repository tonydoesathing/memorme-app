part of 'edit_memory_bloc.dart';

abstract class EditMemoryEvent extends Equatable {
  final Memory memory;
  const EditMemoryEvent(this.memory);

  @override
  List<Object> get props => [this.memory];
}

/// save a [memory]
class EditMemoryBlocSaveMemory extends EditMemoryEvent {
  EditMemoryBlocSaveMemory(Memory memory) : super(memory);
}

/// remove a [memory]
class EditMemoryBlocRemoveMemory extends EditMemoryEvent {
  EditMemoryBlocRemoveMemory(Memory memory) : super(memory);
}
