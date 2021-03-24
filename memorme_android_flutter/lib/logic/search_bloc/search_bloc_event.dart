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
