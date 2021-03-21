part of 'view_collection_bloc.dart';

abstract class ViewCollectionBlocState extends Equatable {
  final Collection collection;
  final List<MCRelation> mcRelations;
  final List<Memory> memories;
  final bool isLoading;
  final bool moreToLoad;

  const ViewCollectionBlocState(
      {this.collection,
      this.mcRelations,
      this.memories,
      this.isLoading,
      this.moreToLoad});

  @override
  List<Object> get props => [
        this.collection,
        this.mcRelations,
        this.memories,
        this.isLoading,
        this.moreToLoad
      ];
}

class ViewCollectionLoading extends ViewCollectionBlocState {
  const ViewCollectionLoading(
      {Collection collection,
      List<MCRelation> mcRelations,
      List<Memory> memories,
      bool isLoading,
      bool moreToLoad})
      : super(
            collection: collection,
            mcRelations: mcRelations,
            memories: memories,
            isLoading: isLoading,
            moreToLoad: moreToLoad);
}

class ViewCollectionDisplayed extends ViewCollectionBlocState {
  const ViewCollectionDisplayed(
      {Collection collection,
      List<MCRelation> mcRelations,
      List<Memory> memories,
      bool isLoading,
      bool moreToLoad})
      : super(
            collection: collection,
            mcRelations: mcRelations,
            memories: memories,
            isLoading: isLoading,
            moreToLoad: moreToLoad);
}

class ViewCollectionBlocError extends ViewCollectionBlocState {
  final errorCode;

  ViewCollectionBlocError(this.errorCode,
      {Collection collection,
      List<MCRelation> mcRelations,
      List<Memory> memories,
      bool isLoading,
      bool moreToLoad})
      : super(
            collection: collection,
            mcRelations: mcRelations,
            memories: memories,
            isLoading: isLoading,
            moreToLoad: moreToLoad);
}
