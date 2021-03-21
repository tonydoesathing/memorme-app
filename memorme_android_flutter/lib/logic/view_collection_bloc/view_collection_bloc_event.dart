part of 'view_collection_bloc.dart';

abstract class ViewCollectionBlocEvent extends Equatable {
  const ViewCollectionBlocEvent();

  @override
  List<Object> get props => [];
}

class ViewCollectionBlocLoadMemories extends ViewCollectionBlocEvent {
  final bool fromStart;

  ViewCollectionBlocLoadMemories(this.fromStart);

  @override
  List<Object> get props => [this.fromStart];
}
