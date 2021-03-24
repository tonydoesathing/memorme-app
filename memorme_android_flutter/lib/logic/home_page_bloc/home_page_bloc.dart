import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/repositories/collection_repository.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';

part 'home_page_bloc_event.dart';
part 'home_page_bloc_state.dart';

class HomePageBloc extends Bloc<HomePageBlocEvent, HomePageBlocState> {
  final CollectionRepository collectionRepository;
  final MemoryRepository memoryRepository;

  static const memoryPageSize = 3;
  static const collectionPageSize = 6;

  HomePageBloc(this.collectionRepository, this.memoryRepository)
      : super(HomePageBlocLoading(
            memories: [], collections: [], collectionMemories: {}));

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
    }
  }

  Stream<HomePageBlocState> _mapHomePageInitToState() async* {
    try {
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
    } catch (_) {
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
    } catch (_) {
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
    } catch (_) {
      yield HomePageBlocError(_,
          memories: state.memories,
          collections: state.collections,
          collectionMemories: state.collectionMemories);
    }
  }
}
