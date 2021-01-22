part of 'edit_memory_bloc.dart';

abstract class EditMemoryState extends Equatable {
  final Memory initialMemory;
  final Memory memory;
  const EditMemoryState(this.memory, this.initialMemory);

  @override
  List<Object> get props => [this.memory];
}

class EditMemoryDisplayed extends EditMemoryState {
  EditMemoryDisplayed(Memory memory, Memory initialMemory)
      : super(memory, initialMemory);
}

class EditMemoryLoading extends EditMemoryState {
  EditMemoryLoading(Memory memory, Memory initialMemory)
      : super(memory, initialMemory);
}

class EditMemoryDiscarded extends EditMemoryState {
  EditMemoryDiscarded(Memory memory, Memory initialMemory)
      : super(memory, initialMemory);
}

class EditMemorySaved extends EditMemoryState {
  EditMemorySaved(Memory memory, Memory initialMemory)
      : super(memory, initialMemory);
}

class EditMemoryError extends EditMemoryState {
  final errorCode;
  EditMemoryError(Memory memory, Memory initialMemory, this.errorCode)
      : super(memory, initialMemory);
}
