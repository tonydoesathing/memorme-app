part of 'search_bloc.dart';

abstract class SearchBlocEvent extends Equatable {
  const SearchBlocEvent();

  @override
  List<Object> get props => [];
}

class SearchBlocInitialize extends SearchBlocEvent {}

class SearchBlocSearch extends SearchBlocEvent {
  final String query;

  SearchBlocSearch(this.query);

  @override
  List<Object> get props => [...super.props, query];
}

class SearchBlocCollectionRepoEvent extends SearchBlocEvent {
  final CollectionRepositoryEvent event;

  SearchBlocCollectionRepoEvent(this.event);

  @override
  List<Object> get props => [this.event];
}

class SearchBlocMemoryRepoEvent extends SearchBlocEvent {
  final MemoryRepositoryEvent event;

  SearchBlocMemoryRepoEvent(this.event);

  @override
  List<Object> get props => [this.event];
}
