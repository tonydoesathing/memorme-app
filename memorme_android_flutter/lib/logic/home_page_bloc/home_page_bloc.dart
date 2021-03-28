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

part 'home_page_bloc_event.dart';
part 'home_page_bloc_state.dart';

class HomePageBloc extends Bloc<HomePageBlocEvent, HomePageBlocState> {
  final CollectionRepository collectionRepository;
  final MemoryRepository memoryRepository;
  StreamSubscription<CollectionRepositoryEvent> _collectionStreamSubscription;
  StreamSubscription<MemoryRepositoryEvent> _memoryStreamSubscription;

  static const memoryPageSize = 10;
  static const collectionPageSize = 6;

  HomePageBloc(this.collectionRepository, this.memoryRepository)
      : super(HomePageBlocLoading(
            memories: [], collections: [], collectionMemories: {})) {
    _collectionStreamSubscription =
        collectionRepository.repositoryEventStream.listen((event) {
      this.add(HomePageBlocCollectionRepoEvent(event));
    });
    _memoryStreamSubscription =
        memoryRepository.repositoryEventStream.listen((event) {
      this.add(HomePageBlocMemoryRepoEvent(event));
    });
  }

  @override
  Stream<HomePageBlocState> mapEventToState(
    HomePageBlocEvent event,
  ) async* {
    if (event is HomePageBlocInit) {
      yield* _mapHomePageInitToState();
    } else if (event is HomePageBlocFetchMemories) {
      yield* _mapHomePageFetchMemoriesToState();
    } else if (event is HomePageBlocFetchCollections) {
      yield* _mapHomePageFetchCollectionsToState();
    } else if (event is HomePageBlocCollectionRepoEvent) {
      yield* _mapCollectionRepoEventToState(event.event);
    } else if (event is HomePageBlocMemoryRepoEvent) {
      yield* _mapMemoryRepoEventToState(event.event);
    }
  }

  Stream<HomePageBlocState> _mapHomePageInitToState() async* {
    try {
      yield (HomePageBlocLoading(
          memories: state.memories,
          collections: state.collections,
          collectionMemories: state.collectionMemories));
      // fetch memories
      List<Memory> memories =
          await memoryRepository.fetchMemories(memoryPageSize, null);
      // fetch collections
      List<Collection> collections =
          await collectionRepository.fetchCollections(collectionPageSize, null);
      // build collectionMemories from collections
      for (Collection collection in collections) {
        List<Memory> colMems = [];
        List<MCRelation> mcRelations = await collectionRepository
            .fetchMCRelations(collection, collectionPageSize, null,
                ascending: true);
        for (MCRelation mcRelation in mcRelations) {
          Memory mem = await memoryRepository.fetch(mcRelation.memoryID);
          colMems.add(mem);
        }
        state.collectionMemories[collection.id] = colMems;
      }
      //display
      yield HomePageBlocDisplayed(
          memories: memories,
          collections: collections,
          collectionMemories: state.collectionMemories);
    } catch (_, stacktrace) {
      FirebaseCrashlytics.instance.recordError(_, stacktrace);
      yield HomePageBlocError(_,
          memories: state.memories,
          collections: state.collections,
          collectionMemories: state.collectionMemories);
    }
  }

  Stream<HomePageBlocState> _mapHomePageFetchMemoriesToState() async* {
    try {
      // fetch more memories
      List<Memory> memories = state.memories.length > 0
          ? await memoryRepository.fetchMemories(
              memoryPageSize, state.memories[state.memories.length - 1])
          : [];
      //display
      yield HomePageBlocDisplayed(
          memories: state.memories + memories,
          collections: state.collections,
          collectionMemories: state.collectionMemories);
    } catch (_, stacktrace) {
      FirebaseCrashlytics.instance.recordError(_, stacktrace);
      yield HomePageBlocError(_,
          memories: state.memories,
          collections: state.collections,
          collectionMemories: state.collectionMemories);
    }
  }

  Stream<HomePageBlocState> _mapHomePageFetchCollectionsToState() async* {
    try {
      // fetch collections
      List<Collection> collections = state.collections.length > 0
          ? await collectionRepository.fetchCollections(collectionPageSize,
              state.collections[state.collections.length - 1])
          : [];
      // build collectionMemories from collections
      for (Collection collection in collections) {
        List<Memory> colMems = [];
        List<MCRelation> mcRelations = await collectionRepository
            .fetchMCRelations(collection, collectionPageSize, null,
                ascending: true);
        for (MCRelation mcRelation in mcRelations) {
          Memory mem = await memoryRepository.fetch(mcRelation.memoryID);
          colMems.add(mem);
        }
        state.collectionMemories[collection.id] = colMems;
      }
      // display
      yield HomePageBlocDisplayed(
          memories: state.memories,
          collections: state.collections + collections,
          collectionMemories: state.collectionMemories);
    } catch (_, stacktrace) {
      FirebaseCrashlytics.instance.recordError(_, stacktrace);
      yield HomePageBlocError(_,
          memories: state.memories,
          collections: state.collections,
          collectionMemories: state.collectionMemories);
    }
  }

  Stream<HomePageBlocState> _mapCollectionRepoEventToState(
      CollectionRepositoryEvent event) async* {
    if (event is CollectionRepositoryAddCollection) {
      yield (HomePageBlocLoading(
          memories: state.memories,
          collections: state.collections,
          collectionMemories: state.collectionMemories));
      // add new collection to beginning of thing
      state.collections.insert(0, event.addedCollection);
      // get memories
      List<Memory> memories = [];
      for (MCRelation mcRelation in event.mcRelations) {
        Memory mem = await memoryRepository.fetch(mcRelation.memoryID);
        memories.add(mem);
      }
      state.collectionMemories[event.addedCollection.id] = memories;

      yield HomePageBlocDisplayed(
          memories: state.memories,
          collections: state.collections,
          collectionMemories: state.collectionMemories);
    } else if (event is CollectionRepositoryUpdateCollection) {
      // update the collection preview

      int index = state.collections
          .indexWhere((element) => element.id == event.updatedCollection.id);
      if (index != -1) {
        yield (HomePageBlocLoading(
            memories: state.memories,
            collections: state.collections,
            collectionMemories: state.collectionMemories));

        List<Collection> collections = state.collections;
        Map<int, List<Memory>> collectionsMemories = state.collectionMemories;
        // remove the old collection from collectionsMemories and collections
        collectionsMemories.remove(collections[index].id);
        collections.removeAt(index);
        // set the collection to be correct
        collections.insert(0, event.updatedCollection);
        // update collectionsMemories
        List<Memory> memories = [];
        for (MCRelation mcRelation in event.mcRelations) {
          Memory mem = await memoryRepository.fetch(mcRelation.memoryID);
          memories.add(mem);
        }
        collectionsMemories[event.updatedCollection.id] = memories;

        yield (HomePageBlocDisplayed(
            memories: state.memories,
            collections: collections,
            collectionMemories: collectionsMemories));
      }
    } else if (event is CollectionRepositoryRemoveCollection) {
      yield (HomePageBlocLoading(
          memories: state.memories,
          collections: state.collections,
          collectionMemories: state.collectionMemories));
      // remove it from the list
      List<Collection> collections = state.collections;
      Map<int, List<Memory>> collectionsMemories = state.collectionMemories;
      collections
          .removeWhere((element) => element.id == event.removedCollection.id);
      collectionsMemories
          .removeWhere((key, value) => key == event.removedCollection.id);

      yield (HomePageBlocDisplayed(
          memories: state.memories,
          collections: collections,
          collectionMemories: collectionsMemories));
    }
  }

  Stream<HomePageBlocState> _mapMemoryRepoEventToState(
      MemoryRepositoryEvent event) async* {
    if (event is MemoryRepositoryAddMemory) {
      // reload everything
      this.add(HomePageBlocInit());
    } else if (event is MemoryRepositoryUpdateMemory) {
      // reload everything
      this.add(HomePageBlocInit());
    } else if (event is MemoryRepositoryRemoveMemory) {
      // remove the memory
      yield (HomePageBlocLoading(
          memories: state.memories,
          collections: state.collections,
          collectionMemories: state.collectionMemories));
      state.memories
          .removeWhere((element) => element.id == event.removedMemory.id);

      yield (HomePageBlocDisplayed(
          memories: state.memories,
          collections: state.collections,
          collectionMemories: state.collectionMemories));
    }
  }

  @override
  Future<void> close() {
    _collectionStreamSubscription?.cancel();
    _memoryStreamSubscription?.cancel();
    return super.close();
  }
}
