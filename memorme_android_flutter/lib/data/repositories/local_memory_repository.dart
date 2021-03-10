import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/repositories/exceptions/element_does_not_exist_exception.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';

class LocalMemoryRepository extends MemoryRepository {
  List<Memory> _memories = [];

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
    }
    return memory;
  }

  @override
  Future<Memory> saveMemory(Memory memory) async {
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
}
