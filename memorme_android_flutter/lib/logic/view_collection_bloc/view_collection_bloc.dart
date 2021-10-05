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

part 'view_collection_bloc_event.dart';
part 'view_collection_bloc_state.dart';

class ViewCollectionBloc
    extends Bloc<ViewCollectionBlocEvent, ViewCollectionBlocState> {
  final Collection collection;
  final CollectionRepository collectionRepository;
  final MemoryRepository memoryRepository;
  StreamSubscription<CollectionRepositoryEvent> _collectionStreamSubscription;
  StreamSubscription<MemoryRepositoryEvent> _memoryStreamSubscription;
  static const pageSize = 10;

  ViewCollectionBloc(
      this.collectionRepository, this.memoryRepository, this.collection)
      : super(ViewCollectionLoading(
          collection: collection,
          mcRelations: [],
          memories: [],
        )) {
    _collectionStreamSubscription =
        collectionRepository.repositoryEventStream.listen((event) {
      this.add(ViewCollectionBlocCollectionRepoEvent(event));
    });
    _memoryStreamSubscription =
        memoryRepository.repositoryEventStream.listen((event) {
      this.add(ViewCollectionBlocMemoryRepoEvent(event));
    });
  }

  @override
  Stream<ViewCollectionBlocState> mapEventToState(
    ViewCollectionBlocEvent event,
  ) async* {
    if (event is ViewCollectionBlocLoadMemories) {
      yield* _mapLoadMemoriesToState(event.fromStart);
    } else if (event is ViewCollectionBlocCollectionRepoEvent) {
      yield* _mapCollectionRepoEventToState(event.event);
    } else if (event is ViewCollectionBlocMemoryRepoEvent) {
      yield* _mapMemoryRepoEventToState(event.event);
    }
  }

  Stream<ViewCollectionBlocState> _mapLoadMemoriesToState(
      bool fromStart) async* {
    try {
      yield ViewCollectionLoading(
          collection: state.collection,
          memories: state.memories,
          mcRelations: state.mcRelations,
          isLoading: true,
          moreToLoad: state.moreToLoad);

      // load mcRelations
      List<MCRelation> mcRelations =
          await collectionRepository.fetchMCRelations(
              state.collection,
              pageSize,
              fromStart
                  ? null
                  : state.mcRelations[state.mcRelations.length - 1],
              ascending: true);
      // load memories
      List<Memory> memories = [];
      for (MCRelation mcRelation in mcRelations) {
        Memory mem = await memoryRepository.fetch(mcRelation.memoryID);
        memories.add(mem);
      }

      yield (ViewCollectionDisplayed(
          collection: state.collection,
          mcRelations:
              (fromStart ? <MCRelation>[] : state.mcRelations) + mcRelations,
          memories: (fromStart ? <Memory>[] : state.memories) + memories,
          isLoading: false,
          moreToLoad: mcRelations.length > 0));
    } catch (_, stacktrace) {
      FirebaseCrashlytics.instance.recordError(_, stacktrace);
      yield ViewCollectionBlocError(
        _,
        collection: state.collection,
        mcRelations: state.mcRelations,
        memories: state.memories,
        isLoading: state.isLoading,
        moreToLoad: state.moreToLoad,
      );
    }
  }

  Stream<ViewCollectionBlocState> _mapCollectionRepoEventToState(
      CollectionRepositoryEvent event) async* {
    if (event is CollectionRepositoryAddCollection) {
      // ummm also this shouldn't really happen
    } else if (event is CollectionRepositoryUpdateCollection) {
      // reload the memory
      this.add(ViewCollectionBlocLoadMemories(true));
    } else if (event is CollectionRepositoryRemoveCollection) {
      // ummmmmm hopefully this doesn't happen

    }
  }

  Stream<ViewCollectionBlocState> _mapMemoryRepoEventToState(
      MemoryRepositoryEvent event) async* {
    if (event is MemoryRepositoryAddMemory) {
      // ummm also this shouldn't really happen
      this.add(ViewCollectionBlocLoadMemories(true));
    } else if (event is MemoryRepositoryUpdateMemory) {
      // reload the memory
      this.add(ViewCollectionBlocLoadMemories(true));
    } else if (event is MemoryRepositoryRemoveMemory) {
      this.add(ViewCollectionBlocLoadMemories(true));
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
