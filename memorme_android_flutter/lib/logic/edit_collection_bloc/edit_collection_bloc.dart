import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/data/models/collections/collection_type.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/repositories/collection_repository.dart';
import 'package:memorme_android_flutter/data/repositories/collection_repository_event.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';

part 'edit_collection_bloc_event.dart';
part 'edit_collection_bloc_state.dart';

class EditCollectionBloc
    extends Bloc<EditCollectionBlocEvent, EditCollectionBlocState> {
  final CollectionRepository collectionRepository;
  final MemoryRepository memoryRepository;
  static const pageSize = 2000;

  EditCollectionBloc(this.collectionRepository, this.memoryRepository,
      {Collection collection})
      : super(EditCollectionLoading(
            collection: collection ?? Collection(),
            initialCollection: collection ?? Collection(),
            changed: false,
            memories: {},
            mcRelations: [],
            removedMCRelations: []));

  @override
  Stream<EditCollectionBlocState> mapEventToState(
    EditCollectionBlocEvent event,
  ) async* {
    if (event is EditCollectionBlocLoadCollection) {
      yield* _mapLoadCollectionToState(event.fromStart);
    } else if (event is EditCollectionBlocSaveCollection) {
      yield* _mapSaveCollectionToState();
    } else if (event is EditCollectionBlocEditTitle) {
      yield* _mapEditTitleToState(event.newTitle);
    } else if (event is EditCollectionBlocAddMemory) {
      yield* _mapAddMemoryToState(event.memory);
    } else if (event is EditCollectionBlocRemoveMemory) {
      yield* _mapRemoveMemoryToState(event.mcRelation);
    }
  }

  Stream<EditCollectionBlocState> _mapLoadCollectionToState(
      bool fromStart) async* {
    try {
      // say we're loading
      yield EditCollectionLoading(
          collection: state.collection,
          initialCollection: state.initialCollection,
          changed: state.changed,
          memories: state.memories,
          mcRelations: state.mcRelations,
          removedMCRelations: state.removedMCRelations);

      List<MCRelation> mcRelations = [];

      // is it new? if not, load, the MCRelations and memories
      if (state.collection.id != null) {
        // load MCRelations
        mcRelations = await collectionRepository.fetchMCRelations(
            state.collection,
            pageSize,
            fromStart ? null : state.mcRelations[state.mcRelations.length - 1],
            ascending: true);

        // load memories
        for (MCRelation mcRelation in mcRelations) {
          Memory mem = await memoryRepository.fetch(mcRelation.memoryID);
          state.memories[mem.id] = mem;
        }
      }

      yield EditCollectionDisplayed(
          collection: state.collection,
          initialCollection: state.initialCollection,
          changed: state.changed,
          mcRelations: state.mcRelations + mcRelations,
          memories: state.memories,
          removedMCRelations: state.removedMCRelations);
    } catch (_) {
      yield EditCollectionError(_,
          collection: state.collection,
          initialCollection: state.initialCollection,
          changed: state.changed,
          memories: state.memories,
          mcRelations: state.mcRelations,
          removedMCRelations: state.removedMCRelations);
    }
  }

  Stream<EditCollectionBlocState> _mapSaveCollectionToState() async* {
    try {
      // say we're loading
      yield EditCollectionLoading(
          collection: state.collection,
          initialCollection: state.initialCollection,
          changed: state.changed,
          memories: state.memories,
          mcRelations: state.mcRelations,
          removedMCRelations: state.removedMCRelations);

      bool adding = state.collection.id == null;

      // save collection
      Collection savedCol = await collectionRepository.saveCollection(
          Collection.editCollection(state.collection,
              type: CollectionType.DECK,
              dateCreated: state.collection.dateCreated ?? DateTime.now(),
              dateLastEdited: DateTime.now()));

      List<MCRelation> savedMCRelations = [];
      // save MCRelations
      for (MCRelation mcRelation in state.mcRelations) {
        MCRelation savedMCRelation = await collectionRepository.saveMCRelation(
            MCRelation.editMCRelation(mcRelation,
                collectionID: savedCol.id,
                dateCreated: mcRelation.dateCreated ?? DateTime.now(),
                dateLastEdited: DateTime.now()));
        savedMCRelations.add(savedMCRelation);
      }

      // delete MCRelations that aren't in the initialCollection
      for (MCRelation mcRelation in state.removedMCRelations) {
        await collectionRepository.removeMCRelation(mcRelation);
      }

      // send the event to those listening
      if (adding) {
        collectionRepository.addEvent(
            CollectionRepositoryAddCollection(savedCol, savedMCRelations));
      } else {
        collectionRepository.addEvent(
            CollectionRepositoryUpdateCollection(savedCol, savedMCRelations));
      }

      yield EditCollectionSaved(
          collection: savedCol,
          initialCollection: state.initialCollection,
          changed: state.changed,
          memories: state.memories,
          mcRelations: savedMCRelations,
          removedMCRelations: state.removedMCRelations);
    } catch (_) {
      yield EditCollectionError(_,
          collection: state.collection,
          initialCollection: state.initialCollection,
          changed: state.changed,
          memories: state.memories,
          mcRelations: state.mcRelations,
          removedMCRelations: state.removedMCRelations);
    }
  }

  Stream<EditCollectionBlocState> _mapEditTitleToState(String newTitle) async* {
    try {
      yield EditCollectionDisplayed(
          collection:
              Collection.editCollection(state.collection, title: newTitle),
          initialCollection: state.initialCollection,
          changed: true,
          memories: state.memories,
          mcRelations: state.mcRelations,
          removedMCRelations: state.removedMCRelations);
    } catch (_) {
      yield EditCollectionError(_,
          collection: state.collection,
          initialCollection: state.initialCollection,
          changed: state.changed,
          memories: state.memories,
          mcRelations: state.mcRelations,
          removedMCRelations: state.removedMCRelations);
    }
  }

  Stream<EditCollectionBlocState> _mapAddMemoryToState(Memory memory) async* {
    try {
      // add memory to memories
      state.memories[memory.id] = memory;

      // add mcrelation to mcrelations
      yield EditCollectionDisplayed(
          collection: state.collection,
          initialCollection: state.initialCollection,
          changed: true,
          mcRelations: state.mcRelations +
              [
                MCRelation(
                    memoryID: memory.id,
                    relationshipData: state.mcRelations.length.toString(),
                    dateCreated: DateTime.now(),
                    dateLastEdited: DateTime.now())
              ],
          memories: state.memories,
          removedMCRelations: state.removedMCRelations);
    } catch (_) {
      yield EditCollectionError(_,
          collection: state.collection,
          initialCollection: state.initialCollection,
          changed: state.changed,
          memories: state.memories,
          mcRelations: state.mcRelations,
          removedMCRelations: state.removedMCRelations);
    }
  }

  Stream<EditCollectionBlocState> _mapRemoveMemoryToState(
      MCRelation mcRelation) async* {
    try {
      yield EditCollectionLoading(
          collection: state.collection,
          initialCollection: state.initialCollection,
          changed: state.changed,
          memories: state.memories,
          mcRelations: state.mcRelations,
          removedMCRelations: state.removedMCRelations);

      // remove mcRelation from mcRelations
      state.mcRelations.remove(mcRelation);

      if (mcRelation.id != null) {
        // add it to removed mcRelations
        state.removedMCRelations.add(mcRelation);
      }

      yield EditCollectionDisplayed(
          collection: state.collection,
          initialCollection: state.initialCollection,
          changed: true,
          memories: state.memories,
          mcRelations: state.mcRelations,
          removedMCRelations: state.removedMCRelations);
    } catch (_) {
      yield EditCollectionError(_,
          collection: state.collection,
          initialCollection: state.initialCollection,
          changed: state.changed,
          memories: state.memories,
          mcRelations: state.mcRelations,
          removedMCRelations: state.removedMCRelations);
    }
  }
}
