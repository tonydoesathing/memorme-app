part of 'edit_collection_bloc.dart';

abstract class EditCollectionBlocState extends Equatable {
  final Collection collection;
  final Collection initialCollection;
  final Map memories;
  const EditCollectionBlocState(
      {this.collection, this.initialCollection, this.memories});

  @override
  List<Object> get props =>
      [this.collection, this.initialCollection, this.memories];
}

class EditCollectionDisplayed extends EditCollectionBlocState {
  EditCollectionDisplayed(
      {Collection collection, Collection initialCollection, Map memories})
      : super(
            collection: collection,
            initialCollection: initialCollection,
            memories: memories);
}

class EditCollectionLoading extends EditCollectionBlocState {
  EditCollectionLoading(
      {Collection collection, Collection initialCollection, Map memories})
      : super(
            collection: collection,
            initialCollection: initialCollection,
            memories: memories);
}

class EditCollectionSaved extends EditCollectionBlocState {
  EditCollectionSaved(
      {Collection collection, Collection initialCollection, Map memories})
      : super(
            collection: collection,
            initialCollection: initialCollection,
            memories: memories);
}

class EditCollectionError extends EditCollectionBlocState {
  final errorCode;
  EditCollectionError(this.errorCode,
      {Collection collection, Collection initialCollection, Map memories})
      : super(
            collection: collection,
            initialCollection: initialCollection,
            memories: memories);

  @override
  List<Object> get props => [...super.props, errorCode];
}
