part of 'edit_collection_bloc.dart';

abstract class EditCollectionBlocEvent extends Equatable {
  const EditCollectionBlocEvent();

  @override
  List<Object> get props => [];
}

class EditCollectionBlocSaveCollection extends EditCollectionBlocEvent {}
