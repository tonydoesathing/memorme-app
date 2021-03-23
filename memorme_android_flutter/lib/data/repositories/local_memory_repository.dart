import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/repositories/exceptions/element_does_not_exist_exception.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';

class LocalMemoryRepository extends MemoryRepository {
  List<Memory> _memories = [];
  List<Story> _stories = [];

  @override
  Future<Memory> fetch(int id) async {
    return _memories.firstWhere(
      (element) => element.id == id,
      orElse: () {
        throw ElementNotInStorageException();
      },
    );
  }

  @override
  Future<List<Memory>> fetchMemories(int pageSize, Memory lastMemory,
      {bool ascending = false}) async {
    // sort the memories in ascending or descending order based on dateLastEdited
    _memories.sort((a, b) => ascending
        ? a.dateLastEdited.compareTo(b.dateLastEdited)
        : -1 * a.dateLastEdited.compareTo(b.dateLastEdited));

    int indexOfLastMem = _memories.indexOf(lastMemory);
    if (indexOfLastMem == -1 && lastMemory != null) {
      throw ElementNotInStorageException();
    }

    int offset = lastMemory == null ? 0 : indexOfLastMem + 1;
    if (offset + pageSize > _memories.length) {
      // not enough memories left for entire page size;
      // just reutrn up to last value
      return _memories.sublist(offset);
    }
    // return entire pageSize
    return _memories.sublist(offset, offset + pageSize);
  }

  @override
  Future<Memory> removeMemory(Memory memory) async {
    bool removed = _memories.remove(memory);
    if (!removed) {
      throw ElementNotInStorageException();
    } else {
      // remove stories
      for (Story story in memory.stories) {
        _stories.removeWhere((element) => element.id == story.id);
      }
    }
    return memory;
  }

  @override
  Future<Memory> saveMemory(Memory memory) async {
    // go through stories
    List<Story> stories = [];
    for (Story story in memory.stories) {
      Story s = story;
      // id is null? give it an id
      if (s.id == null) {
        s = Story.editStory(s, id: _stories.length);
      }
      int index = _stories.indexWhere((element) => element.id == story.id);
      if (index == -1) {
        // not in _stories; add it
        _stories.add(story);
      } else {
        // it's in stories; update it
        _stories[index] = story;
      }
      stories.add(s);
    }
    // add stories to memory
    memory = Memory.editMemory(memory, stories: stories);

    // give memory an id if it doesn't have one
    if (memory.id == null) {
      int id = _memories.length;
      Memory newMem = Memory.editMemory(memory, id: id);
      _memories.add(newMem);
      return newMem;
    }
    // if _memories has the memory with the id, update it
    int index = _memories.indexWhere((element) => element.id == memory.id);
    if (index > -1) {
      _memories[index] = memory;
    }
    // otherwise, add it
    _memories.add(memory);

    return memory;
  }

  @override
  Future<Story> removeStory(Story story) async {
    int index = 0;
    // see if the story is in one of the memories
    for (Memory m in _memories) {
      index = m.stories.indexWhere((element) => element.id == story.id);
      if (index != -1) {
        // remove it and break
        m.stories.removeAt(index);
        break;
      }
    }
    // see if in stories
    int secondIndex = 0;
    secondIndex = _stories.indexWhere((element) => element.id == story.id);
    if (index == -1 && secondIndex == -1) {
      throw ElementNotInStorageException();
    }
    return story;
  }
}
