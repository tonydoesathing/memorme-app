import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/data/repositories/collection_repository.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';

part 'collections_bloc_event.dart';
part 'collections_bloc_state.dart';

class CollectionsBloc extends Bloc<CollectionsBlocEvent, CollectionsBlocState> {
  CollectionRepository collectionsRepository;
  MemoryRepository memoryRepository;
  static const int pageSize = 5;

  CollectionsBloc(this.collectionsRepository, this.memoryRepository)
      : super(CollectionsLoading(memories: {}));

  @override
  Stream<CollectionsBlocState> mapEventToState(
    CollectionsBlocEvent event,
  ) async* {
    if (event is CollectionsBlocLoadCollections) {
      yield* _mapLoadCollectionsToState(event.fromStart);
    }
  }

  Stream<CollectionsBlocState> _mapLoadCollectionsToState(
      bool fromStart) async* {
    try {
      yield CollectionsLoading(
          collections: state.collections, memories: state.memories);
      List<Collection> newCollections;
      if (!fromStart) {
        // if the collection is null or empty, load from the beginning
        if (state.collections == null || state.collections.isEmpty) {
          fromStart = true;
        } else {
          // else, load the next page
          List<Collection> page = await collectionsRepository.fetchCollections(
              pageSize, state.collections.last);
          newCollections = [...state.collections, ...page];
        }
      }
      if (fromStart) {
        // replace whatever our current list of collections is with first page
        newCollections =
            await collectionsRepository.fetchCollections(pageSize, null);
      }
      // load memories into map
      for (Collection collection in newCollections) {
        for (MCRelation mcRelation in collection.mcRelations) {
          // put memory in map
          state.memories[mcRelation.memoryID] =
              await memoryRepository.fetch(mcRelation.memoryID);
        }
      }
      yield CollectionsDisplayed(
          collections: newCollections, memories: state.memories);
    } catch (_) {
      yield CollectionsError(_,
          collections: state.collections, memories: state.memories);
    }
  }
}
