import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/data/providers/file_provider.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';
import 'package:memorme_android_flutter/logic/memories_bloc/memories_bloc.dart';
import 'package:path/path.dart';

part 'edit_memory_event.dart';
part 'edit_memory_state.dart';

class EditMemoryBloc extends Bloc<EditMemoryEvent, EditMemoryState> {
  final MemoryRepository repository;
  final MemoriesBloc _memoriesBloc;
  EditMemoryBloc(this.repository, this._memoriesBloc, {Memory memory})
      : super(EditMemoryDisplayed(
            memory ?? Memory(stories: []), memory ?? Memory(stories: [])));

  @override
  Stream<EditMemoryState> mapEventToState(
    EditMemoryEvent event,
  ) async* {
    if (event is EditMemoryBlocSaveMemory) {
      yield* _mapSaveMemoryToState();
    } else if (event is EditMemoryBlocDiscardMemory) {
      yield* _mapDiscardMemoryToState();
    } else if (event is EditMemoryBlocAddStory) {
      yield* _mapAddStoryToState(event.story);
    }
  }

  /// Save the memory
  ///
  /// Prepare the memory to be saved then try and save it.
  Stream<EditMemoryState> _mapSaveMemoryToState() async* {
    try {
      yield EditMemoryLoading(state.memory, state.initialMemory);
      Memory preparedMemory = Memory.editMemory(state.memory,
          dateCreated:
              state.memory.dateCreated ?? DateTime.now().millisecondsSinceEpoch,
          dateLastEdited: DateTime.now().millisecondsSinceEpoch,
          storyPreviewId: state.memory.storyPreviewId ?? 0);
      Memory savedMem = await this.repository.saveMemory(preparedMemory);
      // update the memories bloc with the memory
      _memoriesBloc.add(MemoriesBlocUpdateMemory(savedMem));
      yield EditMemorySaved(savedMem, state.initialMemory);
    } catch (_) {
      yield EditMemoryError(state.memory, state.initialMemory, _);
    }
  }

  /// Discards the memory being edited
  ///
  /// For each media story not in the initial memory, deletes the file
  Stream<EditMemoryState> _mapDiscardMemoryToState() async* {
    try {
      yield EditMemoryLoading(state.memory, state.initialMemory);
      // find added media
      for (Story story in state.memory.stories) {
        if (!state.initialMemory.stories.contains(story) &&
            story.type == StoryType.PICTURE_STORY) {
          await FileProvider().removeFileFromPath(story.data);
        }
      }
      yield EditMemoryDiscarded(state.memory, state.initialMemory);
    } catch (_) {
      yield EditMemoryError(state.memory, state.initialMemory, _);
    }
  }

  /// Adds a story to the memory
  Stream<EditMemoryState> _mapAddStoryToState(Story story) async* {
    try {
      yield EditMemoryLoading(state.memory, state.initialMemory);
      yield EditMemoryDisplayed(
          Memory.editMemory(state.memory,
              stories: state.memory.stories + [story]),
          state.initialMemory);
    } catch (_) {
      yield EditMemoryError(state.memory, state.initialMemory, _);
    }
  }
}
