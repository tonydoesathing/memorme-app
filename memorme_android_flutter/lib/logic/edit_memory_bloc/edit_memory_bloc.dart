import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';
import 'package:path/path.dart';

part 'edit_memory_event.dart';
part 'edit_memory_state.dart';

class EditMemoryBloc extends Bloc<EditMemoryEvent, EditMemoryState> {
  final MemoryRepository repository;
  EditMemoryBloc(this.repository, {Memory memory})
      : super(EditMemoryInitial(memory ?? Memory()));

  @override
  Stream<EditMemoryState> mapEventToState(
    EditMemoryEvent event,
  ) async* {
    if (event is EditMemoryBlocSaveMemory) {
      yield* _mapSaveMemoryToState(event.memory);
    } else if (event is EditMemoryBlocRemoveMemory) {
      yield* _mapRemoveMemoryToState(event.memory);
    }
  }

  Stream<EditMemoryState> _mapSaveMemoryToState(Memory memory) async* {
    try {
      yield EditMemoryLoading(memory);
      print("saving memory");
      Memory savedMem = await this.repository.saveMemory(memory);
      print("saved memory: $savedMem");
      yield EditMemoryLoaded(savedMem);
    } catch (_) {
      yield EditMemoryError(memory, _);
    }
  }

  Stream<EditMemoryState> _mapRemoveMemoryToState(Memory memory) async* {
    try {
      yield EditMemoryLoading(memory);
      Memory removedMem = await this.repository.removeMemory(memory);
      yield EditMemoryRemoved(removedMem);
    } catch (_) {
      yield EditMemoryError(memory, _);
    }
  }
}
