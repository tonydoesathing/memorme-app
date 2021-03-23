part of 'collections_bloc.dart';

abstract class CollectionsBlocState extends Equatable {
  final List<Collection> collections;
  final Map<Collection, List<Memory>> collectionsMemories;
  final bool hasReachedMax;

  const CollectionsBlocState(
      {this.collections, this.collectionsMemories, this.hasReachedMax});

  @override
  List<Object> get props =>
      [this.collections, collectionsMemories, this.hasReachedMax];
}

class CollectionsLoading extends CollectionsBlocState {
  CollectionsLoading(
      {List<Collection> collections,
      Map<Collection, List<Memory>> collectionsMemories,
      bool hasReachedMax})
      : super(
            collections: collections,
            collectionsMemories: collectionsMemories,
            hasReachedMax: hasReachedMax);
}

class CollectionsDisplayed extends CollectionsBlocState {
  CollectionsDisplayed(
      {List<Collection> collections,
      Map<Collection, List<Memory>> collectionsMemories,
      bool hasReachedMax})
      : super(
            collections: collections,
            collectionsMemories: collectionsMemories,
            hasReachedMax: hasReachedMax);
}

class CollectionsError extends CollectionsBlocState {
  final errorCode;
  CollectionsError(this.errorCode,
      {List<Collection> collections,
      Map<Collection, List<Memory>> collectionsMemories,
      bool hasReachedMax})
      : super(
            collections: collections,
            collectionsMemories: collectionsMemories,
            hasReachedMax: hasReachedMax);

  @override
  List<Object> get props => [...super.props, errorCode];
}
