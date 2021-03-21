import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/repositories/collection_repository.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';

part 'view_collection_bloc_event.dart';
part 'view_collection_bloc_state.dart';

class ViewCollectionBloc
    extends Bloc<ViewCollectionBlocEvent, ViewCollectionBlocState> {
  final Collection collection;
  final CollectionRepository collectionRepository;
  final MemoryRepository memoryRepository;
  static const pageSize = 10;

  ViewCollectionBloc(
      this.collectionRepository, this.memoryRepository, this.collection)
      : super(ViewCollectionLoading(
          collection: collection,
          mcRelations: [],
          memories: [],
        ));

  @override
  Stream<ViewCollectionBlocState> mapEventToState(
    ViewCollectionBlocEvent event,
  ) async* {
    if (event is ViewCollectionBlocLoadMemories) {
      yield* _mapLoadMemoriesToState(event.fromStart);
    }
  }

  Stream<ViewCollectionBlocState> _mapLoadMemoriesToState(
      bool fromStart) async* {
    try {
      yield ViewCollectionLoading(
          collection: state.collection,
          memories: state.memories,
          isLoading: true,
          moreToLoad: state.moreToLoad);

      // load mcRelations
      List<MCRelation> mcRelations =
          await collectionRepository.fetchMCRelations(
              state.collection,
              pageSize,
              fromStart
                  ? null
                  : state.mcRelations[state.mcRelations.length - 1]);
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
    } catch (_) {
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
}
