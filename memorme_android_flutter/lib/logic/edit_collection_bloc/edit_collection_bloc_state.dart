part of 'edit_collection_bloc.dart';

abstract class EditCollectionBlocState extends Equatable {
  final Collection collection;
  const EditCollectionBlocState(this.collection);

  @override
  List<Object> get props => [this.collection];
}

class EditCollectionDisplayed extends EditCollectionBlocState {
  EditCollectionDisplayed(Collection collection) : super(collection);
}

class EditCollectionLoading extends EditCollectionBlocState {
  EditCollectionLoading(Collection collection) : super(collection);
}

class EditCollectionSaved extends EditCollectionBlocState {
  EditCollectionSaved(Collection collection) : super(collection);
}

class EditCollectionError extends EditCollectionBlocState {
  final errorCode;
  EditCollectionError(Collection collection, this.errorCode)
      : super(collection);

  @override
  List<Object> get props => [...super.props, errorCode];
}
