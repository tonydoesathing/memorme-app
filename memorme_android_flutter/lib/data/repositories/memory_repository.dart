import 'dart:async';

import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/search_result.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository_event.dart';

abstract class MemoryRepository {
  final _controller = StreamController<MemoryRepositoryEvent>.broadcast();

  /// returns a list of memories with size [pageSize] after [offset] (inclusive)
  /// and sorts it by date last edited and optional [ascending] bool; defaults to false
  ///
  /// Pass in a null [lastMemory] to go from the beginning
  ///
  /// surround with `try{}catch{}` to handle exceptions:
  ///  * [ElementNotInStorageException] - the lastMemory is not in the storage mechanism
  Future<List<Memory>> fetchMemories(int pageSize, Memory lastMemory,
      {bool ascending = false});

  /// fetches a [Memory] by its [id]
  /// returns the [memory] fetched
  ///
  /// surround with `try{}catch{}` to handle exceptions:
  ///  * [ElementNotInStorageException] - the element is not in the storage mechanism
  Future<Memory> fetch(int id);

  /// saves the [memory]
  /// returns the [memory] saved
  ///
  /// surround with `try{}catch{}` to handle exceptions:
  ///  * [SaveElementFailureException] - an error occurred when saving the element
  Future<Memory> saveMemory(Memory memory);

  /// removes the [memory]
  /// returns the removed [memory]
  ///
  /// surround with `try{}catch{}` to handle exceptions:
  ///  * [ElementNotInStorageException] - the element is not in the storage mechanism
  ///  * [RemoveElementFailureException] - an error occurred when removing the element
  Future<Memory> removeMemory(Memory memory);

  /// removes the [story] from the repo
  /// returns the removed [story]
  ///
  /// surround with `try{}catch{}` to handle exceptions:
  ///  * [ElementNotInStorageException] - the element is not in the storage mechanism
  ///  * [RemoveElementFailureException] - an error occurred when removing the element
  Future<Story> removeStory(Story story);

  /// searches for [memory] that match the [query]
  /// returns a list of [searchResults] sorted by points decending
  Future<List<SearchResult>> searchMemories(String query);

  /// gives a stream of [MemoryRepositoryEvent] that can be subscribed to
  Stream<MemoryRepositoryEvent> get repositoryEventStream =>
      _controller.stream.asBroadcastStream();

  /// add an event to the stream
  void addEvent(MemoryRepositoryEvent event) {
    _controller.add(event);
  }

  /// call to close the stream
  void dispose() {
    _controller.close();
  }
}
