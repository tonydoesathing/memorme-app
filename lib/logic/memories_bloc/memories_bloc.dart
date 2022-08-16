import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository_event.dart';

part 'memories_event.dart';
part 'memories_state.dart';

/// a BLoC for accessing memories
class MemoriesBloc extends Bloc<MemoriesEvent, MemoriesState> {
  final MemoryRepository repository;
  StreamSubscription<MemoryRepositoryEvent> _memoryStreamSubscription;
  static const int pageSize = 15;
  MemoriesBloc(this.repository) : super(MemoriesInitial()) {
    _memoryStreamSubscription =
        repository.repositoryEventStream.listen((event) {
      this.add(MemoriesBlocRepoEvent(event));
    });
  }

  @override
  Stream<MemoriesState> mapEventToState(
    MemoriesEvent event,
  ) async* {
    if (event is MemoriesBlocLoadMemories) {
      yield* _mapMemoriesLoadedToState(event.fromStart);
    } else if (event is MemoriesBlocUpdateMemory) {
      yield* _mapMemoriesUpdateToState(event.memory);
    } else if (event is MemoriesBlocRepoEvent) {
      yield* _mapRepoEventToState(event.event);
    }
  }

  /// Try to fetch [pageSize] # of memories after [lastMemory] from repository
  ///
  /// If successful, return [MemoriesLoadSuccess] state
  /// If failure, return [MemoriesLoadFailure] state
  Stream<MemoriesState> _mapMemoriesLoadedToState(bool fromStart) async* {
    final currentState = state;
    try {
      yield MemoriesLoadInProgress.fromMemoriesState(currentState);

      if (fromStart) {
        // load memories from beginning
        final List<Memory> memories =
            await this.repository.fetchMemories(pageSize, null);
        yield MemoriesLoadSuccess(memories: memories, hasReachedMax: false);
      } else {
        //load from last memory
        List<Memory> memories;
        // check to see if we have a last memory
        if (currentState.memories.isEmpty) {
          // we don't, just load from beginning
          memories = await this.repository.fetchMemories(pageSize, null);
        } else {
          // we do have memories; load from last memory
          memories = await this.repository.fetchMemories(pageSize,
              currentState.memories[currentState.memories.length - 1]);
        }

        // check to see if there are any memories left in repo
        if (memories.isEmpty) {
          // there aren't
          // just copy the current state's memories and note that it's hit the max
          yield MemoriesLoadSuccess.fromMemoriesState(currentState,
              hasReachedMax: true);
        } else {
          // there are
          yield MemoriesLoadSuccess(
              memories: currentState.memories + memories, hasReachedMax: false);
        }
      }
    } catch (_, stacktrace) {
      FirebaseCrashlytics.instance.recordError(_, stacktrace);
      yield MemoriesLoadFailure.fromMemoriesState(currentState, _.toString());
    }
  }

  /// Update state with a new or existing memory
  Stream<MemoriesState> _mapMemoriesUpdateToState(Memory memory) async* {
    final currentState = state;
    yield MemoriesLoadInProgress.fromMemoriesState(currentState);
    // check to see if we edited a memory
    int memToRemove =
        currentState.memories.indexWhere((element) => element.id == memory.id);
    if (memToRemove != -1) currentState.memories.removeAt(memToRemove);
    // return the memories with the new/edited memory at the beginning
    yield MemoriesLoadSuccess.fromMemoriesState(this.state,
        memories: [memory] + currentState.memories);
  }

  Stream<MemoriesState> _mapRepoEventToState(
      MemoryRepositoryEvent event) async* {
    if (event is MemoryRepositoryAddMemory) {
      // add memory to top
      this.add(MemoriesBlocUpdateMemory(event.addedMemory));
    } else if (event is MemoryRepositoryUpdateMemory) {
      // updat ememory
      this.add(MemoriesBlocUpdateMemory(event.updatedMemory));
    } else if (event is MemoryRepositoryRemoveMemory) {
      final currentState = state;
      yield MemoriesLoadInProgress.fromMemoriesState(currentState);
      currentState.memories
          .removeWhere((element) => element.id == event.removedMemory.id);
      yield MemoriesLoadSuccess.fromMemoriesState(currentState);
    }
  }

  @override
  Future<void> close() {
    _memoryStreamSubscription.cancel();
    return super.close();
  }
}
