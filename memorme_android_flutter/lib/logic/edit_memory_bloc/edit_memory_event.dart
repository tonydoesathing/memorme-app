part of 'edit_memory_bloc.dart';

abstract class EditMemoryEvent extends Equatable {
  const EditMemoryEvent();

  @override
  List<Object> get props => [];
}

/// add a [story] to a [Memory]
class EditMemoryBlocAddStory extends EditMemoryEvent {
  final Story story;
  EditMemoryBlocAddStory(this.story);
}

/// save a [memory]
class EditMemoryBlocSaveMemory extends EditMemoryEvent {}

/// remove a [memory]
class EditMemoryBlocDiscardMemory extends EditMemoryEvent {}
