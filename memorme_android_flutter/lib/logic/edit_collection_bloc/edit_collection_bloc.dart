import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/repositories/collection_repository.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';

part 'edit_collection_bloc_event.dart';
part 'edit_collection_bloc_state.dart';

class EditCollectionBloc
    extends Bloc<EditCollectionBlocEvent, EditCollectionBlocState> {
  final CollectionRepository collectionRepository;
  final MemoryRepository memoryRepository;

  EditCollectionBloc(this.collectionRepository, this.memoryRepository,
      {Collection collection})
      : super(EditCollectionLoading(
            collection: collection ?? Collection(mcRelations: []),
            initialCollection: collection ?? Collection(mcRelations: [])));

  @override
  Stream<EditCollectionBlocState> mapEventToState(
    EditCollectionBlocEvent event,
  ) async* {
    if (event is EditCollectionBlocLoadCollection) {
      yield* _mapLoadCollectionToState();
    } else if (event is EditCollectionBlocSaveCollection) {
      yield* _mapSaveCollectionToState();
    } else if (event is EditCollectionBlocEditTitle) {
      yield* _mapEditTitleToState(event.newTitle);
    } else if (event is EditCollectionBlocAddMemory) {
      yield* _mapAddMemoryToState(event.memory);
    }
  }

  Stream<EditCollectionBlocState> _mapLoadCollectionToState() async* {
    try {
      yield EditCollectionLoading(
          collection: state.collection,
          initialCollection: state.initialCollection,
          memories: state.memories);
      Collection collection = Collection.editCollection(state.collection);
      // load memories
      Map memories = Map();
      if (collection.mcRelations != null) {
        for (MCRelation relation in state.collection.mcRelations) {
          Memory mem = await memoryRepository.fetch(relation.memoryID);
          memories[mem.id] = mem;
        }
      } else {
        collection = Collection.editCollection(collection, mcRelations: []);
      }
      // display collection
      yield EditCollectionDisplayed(
          collection: collection,
          initialCollection: collection,
          memories: memories);
    } catch (_) {
      yield EditCollectionError(_,
          collection: state.collection,
          initialCollection: state.initialCollection,
          memories: state.memories);
    }
  }

  Stream<EditCollectionBlocState> _mapSaveCollectionToState() async* {
    try {
      yield EditCollectionLoading(
          collection: state.collection,
          initialCollection: state.initialCollection,
          memories: state.memories);
      Collection savedCol = await collectionRepository.saveCollection(
          Collection.editCollection(state.collection,
              dateCreated: state.collection.dateCreated ?? DateTime.now(),
              dateLastEdited: DateTime.now()));
      print(await collectionRepository.fetchCollections(5, null));
      yield EditCollectionSaved(
          collection: savedCol,
          initialCollection: state.initialCollection,
          memories: state.memories);
    } catch (_) {
      yield EditCollectionError(_,
          collection: state.collection,
          initialCollection: state.initialCollection,
          memories: state.memories);
    }
  }

  Stream<EditCollectionBlocState> _mapEditTitleToState(String newTitle) async* {
    try {
      yield EditCollectionDisplayed(
          collection:
              Collection.editCollection(state.collection, title: newTitle),
          initialCollection: state.initialCollection,
          memories: state.memories);
    } catch (_) {
      yield EditCollectionError(_,
          collection: state.collection,
          initialCollection: state.initialCollection,
          memories: state.memories);
    }
  }

  Stream<EditCollectionBlocState> _mapAddMemoryToState(Memory memory) async* {
    try {
      Map memories = state.memories;
      memories[memory.id] = memory;
      yield EditCollectionDisplayed(
          collection: Collection.editCollection(state.collection, mcRelations: [
            ...state.collection.mcRelations,
            MCRelation(
                memoryID: memory.id,
                relationshipData:
                    state.collection.mcRelations.length.toString(),
                dateCreated: DateTime.now(),
                dateLastEdited: DateTime.now())
          ]),
          initialCollection: state.initialCollection,
          memories: memories);
    } catch (_) {
      yield EditCollectionError(_,
          collection: state.collection,
          initialCollection: state.initialCollection,
          memories: state.memories);
    }
  }
}
