part of 'collections_bloc.dart';

abstract class CollectionsBlocState extends Equatable {
  final List<Collection> collections;
  final Map<Collection, List<Memory>> collectionsMemories;
  const CollectionsBlocState({
    this.collections,
    this.collectionsMemories,
  });

  @override
  List<Object> get props => [this.collections, collectionsMemories];
}

class CollectionsLoading extends CollectionsBlocState {
  CollectionsLoading(
      {List<Collection> collections,
      Map<Collection, List<Memory>> collectionsMemories})
      : super(
            collections: collections, collectionsMemories: collectionsMemories);
}

class CollectionsDisplayed extends CollectionsBlocState {
  CollectionsDisplayed(
      {List<Collection> collections,
      Map<Collection, List<Memory>> collectionsMemories})
      : super(
            collections: collections, collectionsMemories: collectionsMemories);
}

class CollectionsError extends CollectionsBlocState {
  final errorCode;
  CollectionsError(this.errorCode,
      {List<Collection> collections,
      Map<Collection, List<Memory>> collectionsMemories})
      : super(
            collections: collections, collectionsMemories: collectionsMemories);

  @override
  List<Object> get props => [...super.props, errorCode];
}
