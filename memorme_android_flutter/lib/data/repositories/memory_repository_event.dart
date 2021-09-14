import 'package:equatable/equatable.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';

abstract class MemoryRepositoryEvent extends Equatable {
  const MemoryRepositoryEvent();

  @override
  List<Object> get props => [];
}

class MemoryRepositoryAddMemory extends MemoryRepositoryEvent {
  final Memory addedMemory;

  MemoryRepositoryAddMemory(this.addedMemory);

  @override
  List<Object> get props => [...super.props, this.addedMemory];
}

class MemoryRepositoryRemoveMemory extends MemoryRepositoryEvent {
  final Memory removedMemory;

  MemoryRepositoryRemoveMemory(this.removedMemory);

  @override
  List<Object> get props => [...super.props, this.removedMemory];
}

class MemoryRepositoryUpdateMemory extends MemoryRepositoryEvent {
  final Memory updatedMemory;

  MemoryRepositoryUpdateMemory(this.updatedMemory);

  @override
  List<Object> get props => [...super.props, this.updatedMemory];
}
