part of 'edit_collection_bloc.dart';

abstract class EditCollectionBlocState extends Equatable {
  final Collection collection;
  final Collection initialCollection;
  final bool changed;
  final Map memories;
  final List<MCRelation> mcRelations;
  const EditCollectionBlocState(
      {this.collection,
      this.initialCollection,
      this.changed,
      this.memories,
      this.mcRelations});

  @override
  List<Object> get props => [
        this.collection,
        this.initialCollection,
        this.changed,
        this.memories,
        this.mcRelations
      ];
}

class EditCollectionDisplayed extends EditCollectionBlocState {
  EditCollectionDisplayed(
      {Collection collection,
      Collection initialCollection,
      bool changed,
      Map memories,
      List<MCRelation> mcRelations})
      : super(
            collection: collection,
            initialCollection: initialCollection,
            changed: changed,
            memories: memories,
            mcRelations: mcRelations);
}

class EditCollectionLoading extends EditCollectionBlocState {
  EditCollectionLoading(
      {Collection collection,
      Collection initialCollection,
      bool changed,
      Map memories,
      List<MCRelation> mcRelations})
      : super(
            collection: collection,
            initialCollection: initialCollection,
            changed: changed,
            memories: memories,
            mcRelations: mcRelations);
}

class EditCollectionSaved extends EditCollectionBlocState {
  EditCollectionSaved(
      {Collection collection,
      Collection initialCollection,
      bool changed,
      Map memories,
      List<MCRelation> mcRelations})
      : super(
            collection: collection,
            initialCollection: initialCollection,
            changed: changed,
            memories: memories,
            mcRelations: mcRelations);
}

class EditCollectionError extends EditCollectionBlocState {
  final errorCode;
  EditCollectionError(this.errorCode,
      {Collection collection,
      Collection initialCollection,
      bool changed,
      Map memories,
      List<MCRelation> mcRelations})
      : super(
            collection: collection,
            initialCollection: initialCollection,
            changed: changed,
            memories: memories,
            mcRelations: mcRelations);

  @override
  List<Object> get props => [...super.props, errorCode];
}
