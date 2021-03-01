part of 'memories_bloc.dart';

/// Every memory state can contain at least the loaded memories and whether it's reached the max
abstract class MemoriesState extends Equatable {
  final List<Memory> memories;
  final bool hasReachedMax;
  MemoriesState({this.memories, this.hasReachedMax});

  @override
  List<Object> get props => [this.memories, this.hasReachedMax];
}

/// Starting up the MemoriesBloc
class MemoriesInitial extends MemoriesState {
  MemoriesInitial({List<Memory> memories, bool hasReachedMax})
      : super(memories: memories ?? [], hasReachedMax: hasReachedMax ?? true);
}

/// Loading a memory in progress
class MemoriesLoadInProgress extends MemoriesState {
  MemoriesLoadInProgress({List<Memory> memories, bool hasReachedMax})
      : super(memories: memories, hasReachedMax: hasReachedMax);

  factory MemoriesLoadInProgress.fromMemoriesState(MemoriesState state) {
    return MemoriesLoadInProgress(
        memories: state.memories, hasReachedMax: state.hasReachedMax);
  }
}

/// Successfully loaded a memory
class MemoriesLoadSuccess extends MemoriesState {
  MemoriesLoadSuccess({List<Memory> memories, bool hasReachedMax})
      : super(memories: memories, hasReachedMax: hasReachedMax);

  /// takes in a state and optional list of [memories] and bool [hasReachedMax]
  factory MemoriesLoadSuccess.fromMemoriesState(MemoriesState state,
      {List<Memory> memories, bool hasReachedMax}) {
    return MemoriesLoadSuccess(
        memories: memories ?? state.memories,
        hasReachedMax: hasReachedMax ?? state.hasReachedMax);
  }
}

/// Failed loading a memory
class MemoriesLoadFailure extends MemoriesState {
  final String errorCode;
  MemoriesLoadFailure(this.errorCode,
      {List<Memory> memories, bool hasReachedMax})
      : super(memories: memories, hasReachedMax: hasReachedMax);

  factory MemoriesLoadFailure.fromMemoriesState(
      MemoriesState state, String errorCode) {
    return MemoriesLoadFailure(errorCode,
        memories: state.memories, hasReachedMax: state.hasReachedMax);
  }

  @override
  List<Object> get props => [this.errorCode, this.memories, this.hasReachedMax];
}

// /// Saving memory in progress
// class MemoriesSaveInProgress extends MemoriesState {}

// /// Saving memory was successful
// class MemoriesSaveSuccess extends MemoriesState {
//   final Memory memory;
//   MemoriesSaveSuccess(this.memory);

//   @override
//   List<Object> get props => [this.memory];
// }

// /// Failed saving a memory
// class MemoriesSaveFailure extends MemoriesState {
//   final String errorCode;
//   MemoriesSaveFailure(this.errorCode);

//   @override
//   List<Object> get props => [this.errorCode];
// }

// part of 'memories_bloc.dart';

// abstract class MemoriesState extends Equatable {
//   const MemoriesState();

//   @override
//   List<Object> get props => [];
// }

// /// Starting up the MemoriesBloc
// class MemoriesInitial extends MemoriesState {}

// /// Loading a memory in progress
// class MemoriesLoadInProgress extends MemoriesState {}

// /// Successfully loaded a memory
// class MemoriesLoadSuccess extends MemoriesState {
//   final List<Memory> memories;
//   final bool hasReachedMax;

//   const MemoriesLoadSuccess(this.memories, this.hasReachedMax);

//   MemoriesLoadSuccess copyWith({List<Memory> memories, bool hasReachedMax}) {
//     return MemoriesLoadSuccess(
//         memories ?? this.memories, hasReachedMax ?? this.hasReachedMax);
//   }

//   @override
//   List<Object> get props => [this.memories];
// }

// /// Failed loading a memory
// class MemoriesLoadFailure extends MemoriesState {
//   final String errorCode;
//   const MemoriesLoadFailure(this.errorCode);

//   @override
//   List<Object> get props => [this.errorCode];
// }

// /// Saving memory in progress
// class MemoriesSaveInProgress extends MemoriesState {}

// /// Saving memory was successful
// class MemoriesSaveSuccess extends MemoriesState {
//   final Memory memory;
//   const MemoriesSaveSuccess(this.memory);

//   @override
//   List<Object> get props => [this.memory];
// }

// /// Failed saving a memory
// class MemoriesSaveFailure extends MemoriesState {
//   final String errorCode;
//   const MemoriesSaveFailure(this.errorCode);

//   @override
//   List<Object> get props => [this.errorCode];
// }
