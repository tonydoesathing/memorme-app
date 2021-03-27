import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';

part 'select_memories_bloc_event.dart';
part 'select_memories_bloc_state.dart';

class SelectMemoriesBloc
    extends Bloc<SelectMemoriesBlocEvent, SelectMemoriesBlocState> {
  final MemoryRepository repository;
  static const pageSize = 15;

  SelectMemoriesBloc(this.repository)
      : super(SelectMemoriesBlocLoading(
            memories: [], hasReachedMax: false, selectedMemories: {}));

  @override
  Stream<SelectMemoriesBlocState> mapEventToState(
    SelectMemoriesBlocEvent event,
  ) async* {
    if (event is SelectMemoriesBlocLoadMemories) {
      yield* _mapLoadMemoriesToState(event.fromStart);
    } else if (event is SelectMemoriesBlocSelectMemory) {
      yield* _mapSelectMemoryToState(event.selectedMemory);
    } else if (event is SelectMemoriesBlocUnselectMemory) {
      yield* _mapUnselectMemoryToState(event.unselectedMemory);
    }
  }

  Stream<SelectMemoriesBlocState> _mapLoadMemoriesToState(
      bool fromStart) async* {
    try {
      yield SelectMemoriesBlocLoading(
          memories: state.memories,
          hasReachedMax: state.hasReachedMax,
          selectedMemories: state.selectedMemories);
      if (fromStart) {
        // load memories from beginning
        final List<Memory> memories =
            await this.repository.fetchMemories(pageSize, null);
        yield SelectMemoriesBlocDisplayed(
            memories: memories,
            hasReachedMax: false,
            selectedMemories: state.selectedMemories);
      } else {
        //load from last memory
        List<Memory> memories;
        // check to see if we have a last memory
        if (state.memories.isEmpty) {
          // we don't, just load from beginning
          memories = await this.repository.fetchMemories(pageSize, null);
        } else {
          // we do have memories; load from last memory
          memories = await this.repository.fetchMemories(
              pageSize, state.memories[state.memories.length - 1]);
        }

        // check to see if there are any memories left in repo
        if (memories.isEmpty) {
          // there aren't
          // just copy the current state's memories and note that it's hit the max
          yield SelectMemoriesBlocDisplayed(
              memories: state.memories,
              hasReachedMax: true,
              selectedMemories: state.selectedMemories);
        } else {
          // there are
          yield SelectMemoriesBlocDisplayed(
              memories: state.memories + memories,
              hasReachedMax: false,
              selectedMemories: state.selectedMemories);
        }
      }
    } catch (_) {
      yield SelectMemoriesBlocError(_,
          memories: state.memories,
          hasReachedMax: state.hasReachedMax,
          selectedMemories: state.selectedMemories);
    }
  }

  Stream<SelectMemoriesBlocState> _mapSelectMemoryToState(
      Memory selectedMemory) async* {
    try {
      yield SelectMemoriesBlocLoading(
          memories: state.memories,
          hasReachedMax: state.hasReachedMax,
          selectedMemories: state.selectedMemories);

      Map<Memory, bool> selectedMemories = state.selectedMemories;
      selectedMemories[selectedMemory] = true;
      yield SelectMemoriesBlocDisplayed(
          memories: state.memories,
          hasReachedMax: state.hasReachedMax,
          selectedMemories: selectedMemories);
    } catch (_) {
      yield SelectMemoriesBlocError(_,
          memories: state.memories,
          hasReachedMax: state.hasReachedMax,
          selectedMemories: state.selectedMemories);
    }
  }

  Stream<SelectMemoriesBlocState> _mapUnselectMemoryToState(
      Memory unselectedMemory) async* {
    try {
      yield SelectMemoriesBlocLoading(
          memories: state.memories,
          hasReachedMax: state.hasReachedMax,
          selectedMemories: state.selectedMemories);
      Map<Memory, bool> selectedMemories = state.selectedMemories;
      selectedMemories.remove(unselectedMemory);

      yield SelectMemoriesBlocDisplayed(
          memories: state.memories,
          hasReachedMax: state.hasReachedMax,
          selectedMemories: selectedMemories);
    } catch (_) {
      yield SelectMemoriesBlocError(_,
          memories: state.memories,
          hasReachedMax: state.hasReachedMax,
          selectedMemories: state.selectedMemories);
    }
  }
}
