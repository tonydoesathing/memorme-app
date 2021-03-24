part of 'edit_collection_bloc.dart';

abstract class EditCollectionBlocEvent extends Equatable {
  const EditCollectionBlocEvent();

  @override
  List<Object> get props => [];
}

class EditCollectionBlocLoadCollection extends EditCollectionBlocEvent {
  final fromStart;

  EditCollectionBlocLoadCollection(this.fromStart);
}

class EditCollectionBlocSaveCollection extends EditCollectionBlocEvent {}

class EditCollectionBlocEditTitle extends EditCollectionBlocEvent {
  final String newTitle;

  EditCollectionBlocEditTitle(this.newTitle);

  @override
  List<Object> get props => [this.newTitle];
}

class EditCollectionBlocAddMemory extends EditCollectionBlocEvent {
  final Memory memory;

  EditCollectionBlocAddMemory(this.memory);

  @override
  List<Object> get props => [this.memory];
}

class EditCollectionBlocRemoveMemory extends EditCollectionBlocEvent {
  final MCRelation mcRelation;

  EditCollectionBlocRemoveMemory(this.mcRelation);

  @override
  List<Object> get props => [this.mcRelation];
}
