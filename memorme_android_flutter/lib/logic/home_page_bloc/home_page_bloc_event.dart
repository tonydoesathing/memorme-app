part of 'home_page_bloc.dart';

abstract class HomePageBlocEvent extends Equatable {
  const HomePageBlocEvent();

  @override
  List<Object> get props => [];
}

class HomePageBlocInit extends HomePageBlocEvent {}

class HomePageBlocFetchMemories extends HomePageBlocEvent {}

class HomePageBlocFetchCollections extends HomePageBlocEvent {}
