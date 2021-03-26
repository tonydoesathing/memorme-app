import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/data/providers/file_provider.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';
import 'package:memorme_android_flutter/logic/memories_bloc/memories_bloc.dart';

part 'edit_memory_event.dart';
part 'edit_memory_state.dart';

class EditMemoryBloc extends Bloc<EditMemoryEvent, EditMemoryState> {
  final MemoryRepository repository;
  EditMemoryBloc(this.repository, {Memory memory})
      : super(EditMemoryDisplayed(
            memory != null
                ? Memory.editMemory(memory, stories: List.from(memory.stories))
                : Memory(stories: []),
            memory ?? Memory(stories: [])));

  @override
  Stream<EditMemoryState> mapEventToState(
    EditMemoryEvent event,
  ) async* {
    if (event is EditMemoryBlocSaveMemory) {
      yield* _mapSaveMemoryToState();
    } else if (event is EditMemoryBlocDiscardMemory) {
      yield* _mapDiscardMemoryToState();
    } else if (event is EditMemoryBlocEditTitle) {
      yield* _mapEditTitleToState(event.newTitle);
    } else if (event is EditMemoryBlocAddStory) {
      yield* _mapAddStoryToState(event.story);
    } else if (event is EditMemoryBlocRemoveStory) {
      yield* _mapRemoveStoryFromState(event.story);
    } else if (event is EditMemoryBlocReorderStory) {
      yield* _mapReorderStoryToState(event.oldIndex, event.newIndex);
    }
  }

  /// Save the memory
  ///
  /// Prepare the memory to be saved then try and save it.
  Stream<EditMemoryState> _mapSaveMemoryToState() async* {
    try {
      yield EditMemoryLoading(state.memory, state.initialMemory);
      Memory preparedMemory = Memory.editMemory(state.memory,
          dateCreated: state.memory.dateCreated ?? DateTime.now(),
          dateLastEdited: DateTime.now());

      List<Story> storiesToRemove = [];
      // if story in initialMemory not in savedMemory, remove it from storage
      for (Story s in state.initialMemory.stories) {
        if (preparedMemory.stories
                .indexWhere((element) => element.id == s.id) ==
            -1) {
          if (s.type == StoryType.PICTURE_STORY) {
            // remove file
            await FileProvider().removeFileFromPath(s.data);
          }
          // remove from repo
          storiesToRemove.add(s);
        }
      }
      for (Story s in storiesToRemove) {
        repository.removeStory(s);
      }

      Memory savedMem = await this.repository.saveMemory(preparedMemory);
      // update the memories bloc with the memory
      // _memoriesBloc.add(MemoriesBlocUpdateMemory(savedMem));
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
        if (state.initialMemory.stories
                    .indexWhere((element) => element.id == story.id) ==
                -1 &&
            story.type == StoryType.PICTURE_STORY) {
          await FileProvider().removeFileFromPath(story.data);
        }
      }
      yield EditMemoryDiscarded(state.memory, state.initialMemory);
    } catch (_) {
      yield EditMemoryError(state.memory, state.initialMemory, _);
    }
  }

  /// Updates the memory with the new title
  Stream<EditMemoryState> _mapEditTitleToState(String newTitle) async* {
    try {
      yield EditMemoryDisplayed(
          Memory.editMemory(state.memory, title: newTitle),
          state.initialMemory);
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

  /// Removes a story from the memory
  Stream<EditMemoryState> _mapRemoveStoryFromState(Story story) async* {
    try {
      yield EditMemoryLoading(state.memory, state.initialMemory);
      // if story wasn't in initial memory, remove it from storage
      if (!state.initialMemory.stories.contains(story) &&
          story.type == StoryType.PICTURE_STORY) {
        await FileProvider().removeFileFromPath(story.data);
      }
      // remove it from the memory
      state.memory.stories.remove(story);

      yield EditMemoryDisplayed(
          Memory.editMemory(state.memory, stories: state.memory.stories),
          state.initialMemory);
    } catch (_) {
      yield EditMemoryError(state.memory, state.initialMemory, _);
    }
  }

  /// Removes a story from the memory
  Stream<EditMemoryState> _mapReorderStoryToState(
      int oldIndex, int newIndex) async* {
    try {
      yield EditMemoryLoading(state.memory, state.initialMemory);
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final Story item = state.memory.stories.removeAt(oldIndex);

      state.memory.stories.insert(newIndex, item);
      //shiiiiiiiiiittttt we gotta reorder the whole goddamn list
      for (int i = 0; i < state.memory.stories.length; i++) {
        state.memory.stories[i] =
            Story.editStory(state.memory.stories[i], storyPosition: i);
      }

      yield EditMemoryDisplayed(state.memory, state.initialMemory);
    } catch (_) {
      yield EditMemoryError(state.memory, state.initialMemory, _);
    }
  }
}
