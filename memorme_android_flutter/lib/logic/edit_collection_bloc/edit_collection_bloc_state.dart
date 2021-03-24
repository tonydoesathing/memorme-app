part of 'edit_collection_bloc.dart';

abstract class EditCollectionBlocState extends Equatable {
  final Collection collection;
  final Collection initialCollection;
  final bool changed;
  final Map memories;
  final List<MCRelation> mcRelations;
  final List<MCRelation> removedMCRelations;

  const EditCollectionBlocState(
      {this.collection,
      this.initialCollection,
      this.changed,
      this.memories,
      this.mcRelations,
      this.removedMCRelations});

  @override
  List<Object> get props => [
        this.collection,
        this.initialCollection,
        this.changed,
        this.memories,
        this.mcRelations,
        this.removedMCRelations
      ];
}

class EditCollectionDisplayed extends EditCollectionBlocState {
  EditCollectionDisplayed(
      {Collection collection,
      Collection initialCollection,
      bool changed,
      Map memories,
      List<MCRelation> mcRelations,
      List<MCRelation> removedMCRelations})
      : super(
            collection: collection,
            initialCollection: initialCollection,
            changed: changed,
            memories: memories,
            mcRelations: mcRelations,
            removedMCRelations: removedMCRelations);
}

class EditCollectionLoading extends EditCollectionBlocState {
  EditCollectionLoading(
      {Collection collection,
      Collection initialCollection,
      bool changed,
      Map memories,
      List<MCRelation> mcRelations,
      List<MCRelation> removedMCRelations})
      : super(
            collection: collection,
            initialCollection: initialCollection,
            changed: changed,
            memories: memories,
            mcRelations: mcRelations,
            removedMCRelations: removedMCRelations);
}

class EditCollectionSaved extends EditCollectionBlocState {
  EditCollectionSaved(
      {Collection collection,
      Collection initialCollection,
      bool changed,
      Map memories,
      List<MCRelation> mcRelations,
      List<MCRelation> removedMCRelations})
      : super(
            collection: collection,
            initialCollection: initialCollection,
            changed: changed,
            memories: memories,
            mcRelations: mcRelations,
            removedMCRelations: removedMCRelations);
}

class EditCollectionError extends EditCollectionBlocState {
  final errorCode;
  EditCollectionError(this.errorCode,
      {Collection collection,
      Collection initialCollection,
      bool changed,
      Map memories,
      List<MCRelation> mcRelations,
      List<MCRelation> removedMCRelations})
      : super(
            collection: collection,
            initialCollection: initialCollection,
            changed: changed,
            memories: memories,
            mcRelations: mcRelations,
            removedMCRelations: removedMCRelations);

  @override
  List<Object> get props => [...super.props, errorCode];
}
