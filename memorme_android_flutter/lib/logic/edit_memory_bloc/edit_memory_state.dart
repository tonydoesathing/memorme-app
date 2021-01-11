part of 'edit_memory_bloc.dart';

abstract class EditMemoryState extends Equatable {
  final Memory memory;
  const EditMemoryState(this.memory);

  @override
  List<Object> get props => [this.memory];
}

class EditMemoryInitial extends EditMemoryState {
  EditMemoryInitial(Memory memory) : super(memory);
}

class EditMemoryLoading extends EditMemoryState {
  EditMemoryLoading(Memory memory) : super(memory);
}

class EditMemoryLoaded extends EditMemoryState {
  EditMemoryLoaded(Memory memory) : super(memory);
}

class EditMemoryRemoved extends EditMemoryState {
  EditMemoryRemoved(Memory memory) : super(memory);
}

class EditMemoryError extends EditMemoryState {
  final errorCode;
  EditMemoryError(Memory memory, this.errorCode) : super(memory);
}
