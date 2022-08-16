import 'package:equatable/equatable.dart';
import 'package:memorme_android_flutter/data/models/collections/collection.dart';

abstract class CollectionRepositoryEvent extends Equatable {
  const CollectionRepositoryEvent();

  @override
  List<Object> get props => [];
}

class CollectionRepositoryAddCollection extends CollectionRepositoryEvent {
  final Collection addedCollection;
  final List<MCRelation> mcRelations;

  CollectionRepositoryAddCollection(this.addedCollection, this.mcRelations);

  @override
  List<Object> get props =>
      [...super.props, this.addedCollection, this.mcRelations];
}

class CollectionRepositoryRemoveCollection extends CollectionRepositoryEvent {
  final Collection removedCollection;

  CollectionRepositoryRemoveCollection(this.removedCollection);

  @override
  List<Object> get props => [...super.props, this.removedCollection];
}

class CollectionRepositoryUpdateCollection extends CollectionRepositoryEvent {
  final Collection updatedCollection;
  final List<MCRelation> mcRelations;

  CollectionRepositoryUpdateCollection(
      this.updatedCollection, this.mcRelations);

  @override
  List<Object> get props =>
      [...super.props, this.updatedCollection, this.mcRelations];
}
