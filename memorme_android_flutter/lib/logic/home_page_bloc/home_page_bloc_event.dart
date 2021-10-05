part of 'home_page_bloc.dart';

abstract class HomePageBlocEvent extends Equatable {
  const HomePageBlocEvent();

  @override
  List<Object> get props => [];
}

class HomePageBlocInit extends HomePageBlocEvent {}

class HomePageBlocFetchMemories extends HomePageBlocEvent {}

class HomePageBlocFetchCollections extends HomePageBlocEvent {}

class HomePageBlocCollectionRepoEvent extends HomePageBlocEvent {
  final CollectionRepositoryEvent event;

  HomePageBlocCollectionRepoEvent(this.event);

  @override
  List<Object> get props => [this.event];
}

class HomePageBlocMemoryRepoEvent extends HomePageBlocEvent {
  final MemoryRepositoryEvent event;

  HomePageBlocMemoryRepoEvent(this.event);

  @override
  List<Object> get props => [this.event];
}
