part of 'collections_bloc.dart';

abstract class CollectionsBlocEvent extends Equatable {
  const CollectionsBlocEvent();

  @override
  List<Object> get props => [];
}

class CollectionsBlocLoadCollections extends CollectionsBlocEvent {
  final bool fromStart;

  CollectionsBlocLoadCollections(this.fromStart);

  @override
  List<Object> get props => [...super.props, fromStart];
}
