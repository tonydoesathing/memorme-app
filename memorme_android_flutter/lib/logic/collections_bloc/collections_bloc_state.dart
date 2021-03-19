part of 'collections_bloc.dart';

abstract class CollectionsBlocState extends Equatable {
  final List<Collection> collections;
  final Map memories;
  const CollectionsBlocState({
    this.collections,
    this.memories,
  });

  @override
  List<Object> get props => [this.collections];
}

class CollectionsLoading extends CollectionsBlocState {
  CollectionsLoading({List<Collection> collections, Map memories})
      : super(collections: collections, memories: memories);
}

class CollectionsDisplayed extends CollectionsBlocState {
  CollectionsDisplayed({List<Collection> collections, Map memories})
      : super(collections: collections, memories: memories);
}

class CollectionsError extends CollectionsBlocState {
  final errorCode;
  CollectionsError(this.errorCode, {List<Collection> collections, Map memories})
      : super(collections: collections, memories: memories);

  @override
  List<Object> get props => [...super.props, errorCode];
}
