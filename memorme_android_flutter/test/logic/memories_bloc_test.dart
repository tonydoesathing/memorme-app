import 'package:bloc_test/bloc_test.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/data/repositories/local_memory_repository.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';
import 'package:memorme_android_flutter/logic/bloc/memories_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockMemoryRepository extends Mock implements LocalMemoryRepository {}
/*
      A note about testing BLoCs:
        * Always mock your repository; your BLoC test shouldn't depend on the functionality of the repo
        * The setUp() function gets run before each test, so use that to initalize your repo and BLoC
        * If you need to do something special with the repo outside of that, do it in the build function
          of the blocTest
        * blocTest is organized as follows:
          * build: function that initializes the cubit/bloc and returns it
          * act: async function that gives you the bloc and allows you to add events to it
          * expect: an array of the states that you expect to be yielded on events
          * verify: called after expect, and allows for more verifications (like checking the mock repo to see if functions were called)
*/

main() {
  group("MemoriesBloc Test >", () {
    // initial definitions
    MemoriesBloc memoriesBloc;
    MemoryRepository memoryRepository;
    const List<Memory> memories = [
      Memory(1, 1, 1, 1, [Story(1, 1, 1, "Story 1", StoryType.TEXT_STORY)]),
      Memory(2, 2, 2, 2, [Story(2, 2, 2, "Story 2", StoryType.TEXT_STORY)]),
      Memory(3, 3, 3, 4, [
        Story(3, 3, 3, "Story 3", StoryType.TEXT_STORY),
        Story(4, 3, 3, "Story 4", StoryType.TEXT_STORY)
      ]),
    ];

    /// initialize bloc with mocked repo that returns [memories] on .fetchMemories()
    setUp(() {
      memoryRepository = MockMemoryRepository();
      when(memoryRepository.fetchMemories())
          .thenAnswer((_) => Future.value(memories));

      memoriesBloc = MemoriesBloc(memoryRepository);
    });

    /// making sure I set up Equatable correctly
    test("Equal states should be equal", () {
      expect(MemoriesLoadInProgress(), MemoriesLoadInProgress());
      expect(MemoriesLoadSuccess(memories), MemoriesLoadSuccess(memories));
    });

    /// making sure I set up the mock repo correctly
    test("Mock repository should return mock list of memories", () async {
      List<Memory> mems = await memoryRepository.fetchMemories();
      expect(mems, memories);
    });

    /// make sure bloc loads memories
    blocTest<MemoriesBloc, MemoriesState>(
        "On successful MemoriesLoaded, should return loaded memories in MemoriesLoadSuccess state",
        build: () => memoriesBloc,
        act: (MemoriesBloc bloc) async {
          bloc.add(MemoriesLoaded());
        },
        expect: <MemoriesState>[
          MemoriesLoadInProgress(),
          MemoriesLoadSuccess(memories),
        ]);

    /// make sure bloc adds memories
    blocTest<MemoriesBloc, MemoriesState>(
        "On successful MemoriesMemoryAdded, should return MemoriesSaveSuccess with the memory",
        build: () => memoriesBloc,
        act: (MemoriesBloc bloc) async {
          bloc
            ..add(MemoriesLoaded())
            ..add(MemoriesMemoryAdded(Memory(4, 4, 4, 5,
                [Story(5, 4, 4, "Story 5", StoryType.TEXT_STORY)])));
        },
        expect: <MemoriesState>[
          MemoriesLoadInProgress(),
          MemoriesLoadSuccess(memories),
          MemoriesSaveInProgress(),
          MemoriesSaveSuccess(Memory(
              4, 4, 4, 5, [Story(5, 4, 4, "Story 5", StoryType.TEXT_STORY)]))
        ],
        verify: (_) {
          verify(memoryRepository.saveMemory(Memory(4, 4, 4, 5,
              [Story(5, 4, 4, "Story 5", StoryType.TEXT_STORY)]))).called(1);
        });

    /// make sure bloc removes memories
    blocTest<MemoriesBloc, MemoriesState>(
        "On successful MemoriesMemoryRemoved, should return MemoriesSaveSuccess with the memory",
        build: () => memoriesBloc,
        act: (MemoriesBloc bloc) async {
          bloc
            ..add(MemoriesLoaded())
            ..add(MemoriesMemoryRemoved(Memory(1, 1, 1, 1,
                [Story(1, 1, 1, "Story 1", StoryType.TEXT_STORY)])));
        },
        expect: <MemoriesState>[
          MemoriesLoadInProgress(),
          MemoriesLoadSuccess(memories),
          MemoriesSaveInProgress(),
          MemoriesSaveSuccess(Memory(
              1, 1, 1, 1, [Story(1, 1, 1, "Story 1", StoryType.TEXT_STORY)]))
        ],
        verify: (_) {
          verify(memoryRepository.removeMemory(Memory(1, 1, 1, 1,
              [Story(1, 1, 1, "Story 1", StoryType.TEXT_STORY)]))).called(1);
        });

    /// make sure bloc updates memories
    blocTest<MemoriesBloc, MemoriesState>(
        "On successful MemoriesMemoryUpdated, should return MemoriesSaveSuccess with the memory",
        build: () => memoriesBloc,
        act: (MemoriesBloc bloc) async {
          bloc
            ..add(MemoriesLoaded())
            ..add(MemoriesMemoryUpdated(Memory(1, 1, 5, 1, [
              Story(1, 1, 1, "Story 1", StoryType.TEXT_STORY),
              Story(5, 5, 5, "Story 5", StoryType.TEXT_STORY)
            ])));
        },
        expect: <MemoriesState>[
          MemoriesLoadInProgress(),
          MemoriesLoadSuccess(memories),
          MemoriesSaveInProgress(),
          MemoriesSaveSuccess(Memory(1, 1, 5, 1, [
            Story(1, 1, 1, "Story 1", StoryType.TEXT_STORY),
            Story(5, 5, 5, "Story 5", StoryType.TEXT_STORY)
          ]))
        ],
        verify: (_) {
          verify(memoryRepository.saveMemory(Memory(1, 1, 5, 1, [
            Story(1, 1, 1, "Story 1", StoryType.TEXT_STORY),
            Story(5, 5, 5, "Story 5", StoryType.TEXT_STORY)
          ]))).called(1);
        });

    /// make sure bloc gives error on repo.fetchMemories() error
    blocTest<MemoriesBloc, MemoriesState>(
        "On failure of repo.fetchMemories(), should return MemoriesLoadFailure with the error",
        build: () {
          when(memoryRepository.fetchMemories())
              .thenThrow(Exception("LoadError"));
          return memoriesBloc;
        },
        act: (MemoriesBloc bloc) async {
          bloc..add(MemoriesLoaded());
        },
        expect: <MemoriesState>[
          MemoriesLoadInProgress(),
          MemoriesLoadFailure(Exception("LoadError").toString())
        ],
        verify: (_) {
          verify(memoryRepository.fetchMemories()).called(1);
        });

    /// make sure bloc gives error on repo.saveMemory() error
    blocTest<MemoriesBloc, MemoriesState>(
        "On failure of repo.saveMemory(), should return MemoriesSaveFailure with the error",
        build: () {
          when(memoryRepository.saveMemory(any))
              .thenThrow(Exception("SaveError"));
          return memoriesBloc;
        },
        act: (MemoriesBloc bloc) async {
          bloc
            ..add(MemoriesLoaded())
            ..add(MemoriesMemoryAdded(Memory(4, 4, 4, 5,
                [Story(5, 4, 4, "Story 5", StoryType.TEXT_STORY)])));
        },
        expect: <MemoriesState>[
          MemoriesLoadInProgress(),
          MemoriesLoadSuccess(memories),
          MemoriesSaveInProgress(),
          MemoriesSaveFailure(Exception("SaveError").toString())
        ],
        verify: (_) {
          verify(memoryRepository.saveMemory(Memory(4, 4, 4, 5,
              [Story(5, 4, 4, "Story 5", StoryType.TEXT_STORY)]))).called(1);
        });

    /// make sure bloc gives error on repo.removeMemories() error
    blocTest<MemoriesBloc, MemoriesState>(
        "On failure of repo.removeMemory(), should return MemoriesSaveFailure with the error",
        build: () {
          when(memoryRepository.removeMemory(any))
              .thenThrow(Exception("RemoveError"));
          return memoriesBloc;
        },
        act: (MemoriesBloc bloc) async {
          bloc
            ..add(MemoriesLoaded())
            ..add(MemoriesMemoryRemoved(Memory(1, 1, 1, 1,
                [Story(1, 1, 1, "Story 1", StoryType.TEXT_STORY)])));
        },
        expect: <MemoriesState>[
          MemoriesLoadInProgress(),
          MemoriesLoadSuccess(memories),
          MemoriesSaveInProgress(),
          MemoriesSaveFailure(Exception("RemoveError").toString())
        ],
        verify: (_) {
          verify(memoryRepository.removeMemory(Memory(1, 1, 1, 1,
              [Story(1, 1, 1, "Story 1", StoryType.TEXT_STORY)]))).called(1);
        });
  });
}
