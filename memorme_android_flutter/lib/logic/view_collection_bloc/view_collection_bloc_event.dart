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

class ViewCollectionBlocCollectionRepoEvent extends ViewCollectionBlocEvent {
  final CollectionRepositoryEvent event;

  ViewCollectionBlocCollectionRepoEvent(this.event);

  @override
  List<Object> get props => [this.event];
}

class ViewCollectionBlocMemoryRepoEvent extends ViewCollectionBlocEvent {
  final MemoryRepositoryEvent event;

  ViewCollectionBlocMemoryRepoEvent(this.event);

  @override
  List<Object> get props => [this.event];
}
