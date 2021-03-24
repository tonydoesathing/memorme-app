import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/search_result.dart';
import 'package:memorme_android_flutter/data/repositories/collection_repository.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';

part 'search_bloc_event.dart';
part 'search_bloc_state.dart';

class SearchBloc extends Bloc<SearchBlocEvent, SearchBlocState> {
  final CollectionRepository collectionRepository;
  final MemoryRepository memoryRepository;

  SearchBloc(this.collectionRepository, this.memoryRepository)
      : super(
            SearchBlocLoading(query: "", results: [], collectionMemories: {}));

  @override
  Stream<SearchBlocState> mapEventToState(
    SearchBlocEvent event,
  ) async* {
    if (event is SearchBlocInitialize) {
      yield* _mapInitializeToState();
    } else if (event is SearchBlocSearch) {
      yield* _mapSearchToState(event.query);
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
    } catch (_) {
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
    } catch (_) {
      yield SearchBlocError(_,
          query: state.query,
          results: state.results,
          collectionMemories: state.collectionMemories);
    }
  }
}
