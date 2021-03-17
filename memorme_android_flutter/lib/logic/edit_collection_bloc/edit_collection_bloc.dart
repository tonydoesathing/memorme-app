import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/data/repositories/collection_repository.dart';

part 'edit_collection_bloc_event.dart';
part 'edit_collection_bloc_state.dart';

class EditCollectionBloc
    extends Bloc<EditCollectionBlocEvent, EditCollectionBlocState> {
  final CollectionRepository repository;

  EditCollectionBloc(this.repository, {Collection collection})
      : super(
            EditCollectionDisplayed(collection ?? Collection(mcRelations: [])));

  @override
  Stream<EditCollectionBlocState> mapEventToState(
    EditCollectionBlocEvent event,
  ) async* {
    if (event is EditCollectionBlocSaveCollection) {
      yield* _mapSaveCollectionToState();
    }
  }

  Stream<EditCollectionBlocState> _mapSaveCollectionToState() async* {
    try {
      yield EditCollectionLoading(state.collection);
      yield EditCollectionSaved(state.collection);
    } catch (_) {
      yield EditCollectionError(state.collection, _);
    }
  }
}
