import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';

part 'memories_event.dart';
part 'memories_state.dart';

class MemoriesBloc extends Bloc<MemoriesEvent, MemoriesState> {
  final MemoryRepository repository;
  MemoriesBloc(this.repository) : super(MemoriesLoadInProgress());

  @override
  Stream<MemoriesState> mapEventToState(
    MemoriesEvent event,
  ) async* {
    if (event is MemoriesLoaded) {
      yield* _mapMemoriesLoadedToState();
    } else if (event is MemoriesMemoryAdded) {
      yield* _mapMemoriesSaveMemoryToState(event.memory);
    } else if (event is MemoriesMemoryRemoved) {
      yield* _mapMemoriesMemoryRemovedToState(event.memory);
    } else if (event is MemoriesMemoryUpdated) {
      yield* _mapMemoriesSaveMemoryToState(event.memory);
    }
  }

  /// Try to fetch memories from repository
  /// If successful, return [MemoriesLoadSuccess] state
  /// If failure, return [MemoriesLoadFailure] state
  Stream<MemoriesState> _mapMemoriesLoadedToState() async* {
    try {
      yield MemoriesLoadInProgress();
      final List<Memory> memories = await this.repository.fetchMemories();
      yield MemoriesLoadSuccess(memories);
    } catch (_) {
      yield MemoriesLoadFailure(_.toString());
    }
  }

  /// Try to save a new or existing memory to repository
  /// If successful, return [MemoriesSaveSuccess] state
  /// If failure, return [MemoriesSaveFailure] state
  Stream<MemoriesState> _mapMemoriesSaveMemoryToState(Memory memory) async* {
    try {
      yield MemoriesSaveInProgress();
      await this.repository.saveMemory(memory);
      yield MemoriesSaveSuccess(memory);
    } catch (_) {
      yield MemoriesSaveFailure(_.toString());
    }
  }

  /// Try to remove a memory from repository
  /// If successful, return [MemoriesSaveSuccess] state
  /// If failure, return [MemoriesSaveFailure] state
  Stream<MemoriesState> _mapMemoriesMemoryRemovedToState(Memory memory) async* {
    try {
      yield MemoriesSaveInProgress();
      await this.repository.removeMemory(memory);
      yield MemoriesSaveSuccess(memory);
    } catch (_) {
      yield MemoriesSaveFailure(_.toString());
    }
  }
}
