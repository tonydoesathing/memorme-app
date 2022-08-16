part of 'home_page_bloc.dart';

abstract class HomePageBlocState extends Equatable {
  final List<Memory> memories;
  final List<Collection> collections;
  final Map<int, List<Memory>> collectionMemories;
  const HomePageBlocState(
      {this.memories, this.collections, this.collectionMemories});

  @override
  List<Object> get props =>
      [this.memories, this.collections, this.collectionMemories];
}

class HomePageBlocLoading extends HomePageBlocState {
  HomePageBlocLoading(
      {List<Memory> memories,
      List<Collection> collections,
      Map<int, List<Memory>> collectionMemories})
      : super(
            memories: memories,
            collections: collections,
            collectionMemories: collectionMemories);
}

class HomePageBlocDisplayed extends HomePageBlocState {
  HomePageBlocDisplayed(
      {List<Memory> memories,
      List<Collection> collections,
      Map<int, List<Memory>> collectionMemories})
      : super(
            memories: memories,
            collections: collections,
            collectionMemories: collectionMemories);
}

class HomePageBlocError extends HomePageBlocState {
  final error;

  HomePageBlocError(this.error,
      {List<Memory> memories,
      List<Collection> collections,
      Map<int, List<Memory>> collectionMemories})
      : super(
            memories: memories,
            collections: collections,
            collectionMemories: collectionMemories);

  @override
  List<Object> get props => [...super.props, error];
}
