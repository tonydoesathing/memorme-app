import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/search_result.dart';
import 'package:memorme_android_flutter/data/repositories/collection_repository.dart';
import 'package:memorme_android_flutter/data/repositories/collection_repository_event.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository_event.dart';

part 'search_bloc_event.dart';
part 'search_bloc_state.dart';

class SearchBloc extends Bloc<SearchBlocEvent, SearchBlocState> {
  final CollectionRepository collectionRepository;
  final MemoryRepository memoryRepository;
  StreamSubscription<CollectionRepositoryEvent> _collectionStreamSubscription;
  StreamSubscription<MemoryRepositoryEvent> _memoryStreamSubscription;

  SearchBloc(this.collectionRepository, this.memoryRepository)
      : super(
            SearchBlocLoading(query: "", results: [], collectionMemories: {})) {
    _collectionStreamSubscription =
        collectionRepository.repositoryEventStream.listen((event) {
      this.add(SearchBlocCollectionRepoEvent(event));
    });
    _memoryStreamSubscription =
        memoryRepository.repositoryEventStream.listen((event) {
      this.add(SearchBlocMemoryRepoEvent(event));
    });
  }

  @override
  Stream<SearchBlocState> mapEventToState(
    SearchBlocEvent event,
  ) async* {
    if (event is SearchBlocInitialize) {
      yield* _mapInitializeToState();
    } else if (event is SearchBlocSearch) {
      yield* _mapSearchToState(event.query);
    } else if (event is SearchBlocCollectionRepoEvent) {
      yield* _mapCollectionRepoEventToState(event.event);
    } else if (event is SearchBlocMemoryRepoEvent) {
      yield* _mapMemoryRepoEventToState(event.event);
    }
  }

  Stream<SearchBlocState> _mapInitializeToState() async* {
    try {
      yield SearchBlocLoading(
          query: state.query,
          results: state.results,
          collectionMemories: state.collectionMemories);

      yield SearchBlocDisplayed(
          query: state.query,
          results: state.results,
          collectionMemories: state.collectionMemories);
    } catch (_, stacktrace) {
      FirebaseCrashlytics.instance.recordError(_, stacktrace);
      yield SearchBlocError(_,
          query: state.query,
          results: state.results,
          collectionMemories: state.collectionMemories);
    }
  }

  Stream<SearchBlocState> _mapSearchToState(String query) async* {
    try {
      if (query == "") {
        yield SearchBlocDisplayed(
            query: state.query, results: [], collectionMemories: {});
      } else {
        yield SearchBlocLoading(
            query: query,
            results: state.results,
            collectionMemories: state.collectionMemories);
        // search memories and collections then combine the two
        List<SearchResult> memoryResults =
            await memoryRepository.searchMemories(query);
        List<SearchResult> collectionResults =
            await collectionRepository.searchCollections(query);
        // map mcRelations to collectionMemories
        for (SearchResult result in collectionResults) {
          Collection collection = result.object;
          List<Memory> colMems = [];
          List<MCRelation> mcRelations = await collectionRepository
              .fetchMCRelations(collection, 6, null, ascending: true);
          for (MCRelation mcRelation in mcRelations) {
            Memory mem = await memoryRepository.fetch(mcRelation.memoryID);
            colMems.add(mem);
          }
          state.collectionMemories[collection.id] = colMems;
        }

        List<SearchResult> finalResults = memoryResults + collectionResults;
        // sort according to points
        finalResults.sort((a, b) => -1 * a.points.compareTo(b.points));

        // yield
        yield SearchBlocDisplayed(
            query: state.query,
            results: finalResults,
            collectionMemories: state.collectionMemories);
      }
    } catch (_, stacktrace) {
      FirebaseCrashlytics.instance.recordError(_, stacktrace);
      yield SearchBlocError(_,
          query: state.query,
          results: state.results,
          collectionMemories: state.collectionMemories);
    }
  }

  Stream<SearchBlocState> _mapCollectionRepoEventToState(
      CollectionRepositoryEvent event) async* {
    if (event is CollectionRepositoryAddCollection) {
      // ummm also this shouldn't really happen
      this.add(SearchBlocSearch(state.query));
    } else if (event is CollectionRepositoryUpdateCollection) {
      // update the collection
      this.add(SearchBlocSearch(state.query));
    } else if (event is CollectionRepositoryRemoveCollection) {
      // remove the collection
      yield SearchBlocLoading(
          query: state.query,
          results: state.results,
          collectionMemories: state.collectionMemories);
      int index = state.results.indexWhere((element) {
        Object obj = element.object;
        if (obj is Collection) {
          return obj.id == event.removedCollection.id;
        }
        return false;
      });
      if (index != -1) {
        state.results.removeAt(index);
      }
      yield SearchBlocDisplayed(
          query: state.query,
          results: state.results,
          collectionMemories: state.collectionMemories);
    }
  }

  Stream<SearchBlocState> _mapMemoryRepoEventToState(
      MemoryRepositoryEvent event) async* {
    if (event is MemoryRepositoryAddMemory) {
      this.add(SearchBlocSearch(state.query));
    } else if (event is MemoryRepositoryUpdateMemory) {
      this.add(SearchBlocSearch(state.query));
    } else if (event is MemoryRepositoryRemoveMemory) {
      yield SearchBlocLoading(
          query: state.query,
          results: state.results,
          collectionMemories: state.collectionMemories);
      int index = state.results.indexWhere((element) {
        Object obj = element.object;
        if (obj is Memory) {
          return obj.id == event.removedMemory.id;
        }
        return false;
      });
      if (index != -1) {
        state.results.removeAt(index);
      }
      yield SearchBlocDisplayed(
          query: state.query,
          results: state.results,
          collectionMemories: state.collectionMemories);
    }
  }

  @override
  Future<void> close() {
    _collectionStreamSubscription?.cancel();
    _memoryStreamSubscription?.cancel();
    return super.close();
  }
}
