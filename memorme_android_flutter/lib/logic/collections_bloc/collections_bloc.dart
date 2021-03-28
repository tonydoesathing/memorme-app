import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/repositories/collection_repository.dart';
import 'package:memorme_android_flutter/data/repositories/collection_repository_event.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository_event.dart';

part 'collections_bloc_event.dart';
part 'collections_bloc_state.dart';

class CollectionsBloc extends Bloc<CollectionsBlocEvent, CollectionsBlocState> {
  CollectionRepository collectionsRepository;
  MemoryRepository memoryRepository;
  static const int pageSize = 10;
  StreamSubscription<CollectionRepositoryEvent> _collectionStreamSubscription;
  StreamSubscription<MemoryRepositoryEvent> _memoryStreamSubscription;

  CollectionsBloc(this.collectionsRepository, this.memoryRepository)
      : super(CollectionsLoading(
            collections: [], collectionsMemories: {}, hasReachedMax: false)) {
    _collectionStreamSubscription =
        this.collectionsRepository.repositoryEventStream.listen((event) {
      this.add(CollectionsBlocCollectionRepoEvent(event));
    });
    _memoryStreamSubscription =
        memoryRepository.repositoryEventStream.listen((event) {
      this.add(CollectionsBlocMemoryRepoEvent(event));
    });
  }

  @override
  Stream<CollectionsBlocState> mapEventToState(
    CollectionsBlocEvent event,
  ) async* {
    if (event is CollectionsBlocLoadCollections) {
      yield* _mapLoadCollectionsToState(event.fromStart);
    } else if (event is CollectionsBlocCollectionRepoEvent) {
      yield* _mapRepoEventToState(event.event);
    } else if (event is CollectionsBlocMemoryRepoEvent) {
      yield* _mapMemoryRepoEventToState(event.event);
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
    } catch (_, stacktrace) {
      FirebaseCrashlytics.instance.recordError(_, stacktrace);
      yield CollectionsError(_,
          collections: state.collections,
          collectionsMemories: state.collectionsMemories,
          hasReachedMax: state.hasReachedMax);
    }
  }

  Stream<CollectionsBlocState> _mapRepoEventToState(
      CollectionRepositoryEvent event) async* {
    if (event is CollectionRepositoryAddCollection) {
      yield (CollectionsLoading(
          collections: state.collections,
          collectionsMemories: state.collectionsMemories,
          hasReachedMax: state.hasReachedMax));
      // add collection to the beginning of list
      state.collections.insert(0, event.addedCollection);
      // get memories
      List<Memory> memories = [];
      for (MCRelation mcRelation in event.mcRelations) {
        Memory mem = await memoryRepository.fetch(mcRelation.memoryID);
        memories.add(mem);
      }
      state.collectionsMemories[event.addedCollection] = memories;

      yield (CollectionsDisplayed(
          collections: state.collections,
          collectionsMemories: state.collectionsMemories,
          hasReachedMax: state.hasReachedMax));
    } else if (event is CollectionRepositoryUpdateCollection) {
      // if it's already in the list, update it
      int index = state.collections
          .indexWhere((element) => element.id == event.updatedCollection.id);
      if (index != -1) {
        yield (CollectionsLoading(
            collections: state.collections,
            collectionsMemories: state.collectionsMemories,
            hasReachedMax: state.hasReachedMax));

        List<Collection> collections = state.collections;
        Map<Collection, List<Memory>> collectionsMemories =
            state.collectionsMemories;
        // remove the old collection from collectionsMemories and collections
        collectionsMemories.remove(collections[index]);
        collections.removeAt(index);
        // set the collection to be correct
        collections.insert(0, event.updatedCollection);
        // update collectionsMemories
        List<Memory> memories = [];
        for (MCRelation mcRelation in event.mcRelations) {
          Memory mem = await memoryRepository.fetch(mcRelation.memoryID);
          memories.add(mem);
        }
        collectionsMemories[event.updatedCollection] = memories;

        yield (CollectionsDisplayed(
            collections: collections,
            collectionsMemories: collectionsMemories,
            hasReachedMax: state.hasReachedMax));
      }
    } else if (event is CollectionRepositoryRemoveCollection) {
      // if it's in the list, remove it
      yield (CollectionsLoading(
          collections: state.collections,
          collectionsMemories: state.collectionsMemories,
          hasReachedMax: state.hasReachedMax));
      List<Collection> collections = state.collections;
      Map<Collection, List<Memory>> collectionsMemories =
          state.collectionsMemories;
      collections
          .removeWhere((element) => element.id == event.removedCollection.id);
      collectionsMemories
          .removeWhere((key, value) => key.id == event.removedCollection.id);
      yield (CollectionsDisplayed(
          collections: collections,
          collectionsMemories: collectionsMemories,
          hasReachedMax: state.hasReachedMax));
    }
  }

  Stream<CollectionsBlocState> _mapMemoryRepoEventToState(
      MemoryRepositoryEvent event) async* {
    if (event is MemoryRepositoryAddMemory) {
      this.add(CollectionsBlocLoadCollections(true));
    } else if (event is MemoryRepositoryUpdateMemory) {
      this.add(CollectionsBlocLoadCollections(true));
    } else if (event is MemoryRepositoryRemoveMemory) {
      this.add(CollectionsBlocLoadCollections(true));
    }
  }

  @override
  Future<void> close() {
    // close stream subscription
    _collectionStreamSubscription?.cancel();
    _memoryStreamSubscription?.cancel();
    return super.close();
  }
}
