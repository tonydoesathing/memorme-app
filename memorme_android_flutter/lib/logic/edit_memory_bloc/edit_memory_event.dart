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

  @override
  List<Object> get props => [this.story];
}

/// removes a [story] from a [Memory]
class EditMemoryBlocRemoveStory extends EditMemoryEvent {
  final Story story;
  EditMemoryBlocRemoveStory(this.story);

  @override
  List<Object> get props => [this.story];
}

/// reorder a [story] in a [Memory]
class EditMemoryBlocReorderStory extends EditMemoryEvent {
  final int oldIndex;
  final int newIndex;

  EditMemoryBlocReorderStory(this.oldIndex, this.newIndex);

  @override
  List<Object> get props => [this.oldIndex, this.newIndex];
}

/// save a [memory]
class EditMemoryBlocSaveMemory extends EditMemoryEvent {}

/// remove a [memory]
class EditMemoryBlocDiscardMemory extends EditMemoryEvent {}

/// edits the [title] of the [memory]
class EditMemoryBlocEditTitle extends EditMemoryEvent {
  final String newTitle;

  EditMemoryBlocEditTitle(this.newTitle);

  @override
  List<Object> get props => [this.newTitle];
}
