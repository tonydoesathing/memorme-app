part of 'search_bloc.dart';

abstract class SearchBlocState extends Equatable {
  final String query;
  final List<SearchResult> results;
  final Map<int, List<Memory>> collectionMemories;
  const SearchBlocState({this.query, this.results, this.collectionMemories});

  @override
  List<Object> get props => [this.results];
}

class SearchBlocLoading extends SearchBlocState {
  SearchBlocLoading(
      {String query,
      List<SearchResult> results,
      Map<int, List<Memory>> collectionMemories})
      : super(
            query: query,
            results: results,
            collectionMemories: collectionMemories);
}

class SearchBlocDisplayed extends SearchBlocState {
  SearchBlocDisplayed(
      {String query,
      List<SearchResult> results,
      Map<int, List<Memory>> collectionMemories})
      : super(
            query: query,
            results: results,
            collectionMemories: collectionMemories);
}

class SearchBlocError extends SearchBlocState {
  final error;
  SearchBlocError(this.error,
      {String query,
      List<SearchResult> results,
      Map<int, List<Memory>> collectionMemories})
      : super(
            query: query,
            results: results,
            collectionMemories: collectionMemories);

  @override
  List<Object> get props => [...super.props, error];
}
