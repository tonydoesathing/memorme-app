import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/repositories/collection_repository.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';

part 'collections_bloc_event.dart';
part 'collections_bloc_state.dart';

class CollectionsBloc extends Bloc<CollectionsBlocEvent, CollectionsBlocState> {
  CollectionRepository collectionsRepository;
  MemoryRepository memoryRepository;
  static const int pageSize = 3;

  CollectionsBloc(this.collectionsRepository, this.memoryRepository)
      : super(CollectionsLoading(
            collections: [], collectionsMemories: {}, hasReachedMax: false));

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
          collections: state.collections,
          collectionsMemories: state.collectionsMemories,
          hasReachedMax: state.hasReachedMax);
      // load collections from beginning if fromStart true or collections.last is null
      List<Collection> newCollections =
          await collectionsRepository.fetchCollections(
              pageSize,
              fromStart
                  ? null
                  : state.collections[state.collections.length - 1]);

      // load memories into collectionsMemories
      for (Collection collection in newCollections) {
        List<Memory> memories = [];
        // get the first n mcRelations
        List<MCRelation> mcRelations = await collectionsRepository
            .fetchMCRelations(collection, pageSize, null, ascending: true);
        // load the associated memories into collectionsMemories
        for (MCRelation mcRelation in mcRelations) {
          Memory mem = await memoryRepository.fetch(mcRelation.memoryID);
          memories.add(mem);
        }
        state.collectionsMemories[collection] = memories;
      }

      yield (CollectionsDisplayed(
          collections:
              (fromStart ? <Collection>[] : state.collections) + newCollections,
          collectionsMemories: state.collectionsMemories,
          hasReachedMax: newCollections.length == 0 ? true : false));
    } catch (_) {
      yield CollectionsError(_,
          collections: state.collections,
          collectionsMemories: state.collectionsMemories,
          hasReachedMax: state.hasReachedMax);
    }
  }
}
