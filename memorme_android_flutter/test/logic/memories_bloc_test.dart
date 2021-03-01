import 'package:bloc_test/bloc_test.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/data/repositories/local_memory_repository.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';
import 'package:memorme_android_flutter/logic/memories_bloc/memories_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

//TODO: [MMA-106] Fix memories_bloc test

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
      Memory(
          id: 1,
          dateCreated: 1,
          dateLastEdited: 1,
          storyPreviewId: 1,
          stories: [
            Story(
                id: 1,
                dateCreated: 1,
                dateLastEdited: 1,
                data: "Story 1!",
                type: StoryType.TEXT_STORY)
          ]),
      Memory(
          id: 2,
          dateCreated: 2,
          dateLastEdited: 2,
          storyPreviewId: 2,
          stories: [
            Story(
                id: 2,
                dateCreated: 2,
                dateLastEdited: 2,
                data: "Story 2!",
                type: StoryType.TEXT_STORY)
          ]),
      Memory(
          id: 3,
          dateCreated: 3,
          dateLastEdited: 3,
          storyPreviewId: 4,
          stories: [
            Story(
                id: 3,
                dateCreated: 3,
                dateLastEdited: 3,
                data: "Story 3!",
                type: StoryType.TEXT_STORY),
            Story(
                id: 4,
                dateCreated: 3,
                dateLastEdited: 3,
                data: "Story 4!",
                type: StoryType.TEXT_STORY)
          ]),
    ];

    /// initialize bloc with mocked repo that returns [memories] on .fetchMemories()
    setUp(() {
      memoryRepository = MockMemoryRepository();
      when(memoryRepository.fetchMemories(any, any))
          .thenAnswer((_) => Future.value(memories));

      memoriesBloc = MemoriesBloc(memoryRepository);
    });

    /// making sure I set up Equatable correctly
    test("Equal states should be equal", () {
      expect(MemoriesLoadInProgress(), MemoriesLoadInProgress());
      expect(MemoriesLoadSuccess(memories: memories),
          MemoriesLoadSuccess(memories: memories));
    });

    /// making sure I set up the mock repo correctly
    test("Mock repository should return mock list of memories", () async {
      List<Memory> mems = await memoryRepository.fetchMemories(15, null);
      expect(mems, memories);
    });

    /// make sure bloc loads memories
    blocTest<MemoriesBloc, MemoriesState>(
        "On successful MemoriesLoaded, should return loaded memories in MemoriesLoadSuccess state",
        build: () => memoriesBloc,
        act: (MemoriesBloc bloc) async {
          bloc.add(MemoriesBlocLoadMemories(null));
        },
        expect: <MemoriesState>[
          MemoriesLoadInProgress(),
          MemoriesLoadSuccess(memories: memories),
        ]);

    /// make sure bloc adds memories
    blocTest<MemoriesBloc, MemoriesState>(
        "On successful MemoriesMemoryAdded, should return MemoriesSaveSuccess with the memory",
        build: () => memoriesBloc,
        act: (MemoriesBloc bloc) async {
          bloc
            ..add(MemoriesBlocLoadMemories(null))
            ..add(MemoriesMemoryAdded(Memory(
                id: 4,
                dateCreated: 4,
                dateLastEdited: 4,
                storyPreviewId: 5,
                stories: [
                  Story(
                      id: 5,
                      dateCreated: 4,
                      dateLastEdited: 4,
                      data: "Story 5!",
                      type: StoryType.TEXT_STORY)
                ])));
        },
        expect: <MemoriesState>[
          MemoriesLoadInProgress(),
          MemoriesLoadSuccess(memories: memories),
          MemoriesSaveInProgress(),
          MemoriesSaveSuccess(Memory(
              id: 4,
              dateCreated: 4,
              dateLastEdited: 4,
              storyPreviewId: 5,
              stories: [
                Story(
                    id: 5,
                    dateCreated: 4,
                    dateLastEdited: 4,
                    data: "Story 5!",
                    type: StoryType.TEXT_STORY)
              ]))
        ],
        verify: (_) {
          verify(memoryRepository.saveMemory(Memory(
              id: 4,
              dateCreated: 4,
              dateLastEdited: 4,
              storyPreviewId: 5,
              stories: [
                Story(
                    id: 5,
                    dateCreated: 4,
                    dateLastEdited: 4,
                    data: "Story 5!",
                    type: StoryType.TEXT_STORY)
              ]))).called(1);
        });

    /// make sure bloc removes memories
    blocTest<MemoriesBloc, MemoriesState>(
        "On successful MemoriesMemoryRemoved, should return MemoriesSaveSuccess with the memory",
        build: () => memoriesBloc,
        act: (MemoriesBloc bloc) async {
          bloc
            ..add(MemoriesBlocLoadMemories(null))
            ..add(MemoriesMemoryRemoved(Memory(
                id: 1,
                dateCreated: 1,
                dateLastEdited: 1,
                storyPreviewId: 1,
                stories: [
                  Story(
                      id: 1,
                      dateCreated: 1,
                      dateLastEdited: 1,
                      data: "Story 1!",
                      type: StoryType.TEXT_STORY)
                ])));
        },
        expect: <MemoriesState>[
          MemoriesLoadInProgress(),
          MemoriesLoadSuccess(memories: memories),
          MemoriesSaveInProgress(),
          MemoriesSaveSuccess(Memory(
              id: 1,
              dateCreated: 1,
              dateLastEdited: 1,
              storyPreviewId: 1,
              stories: [
                Story(
                    id: 1,
                    dateCreated: 1,
                    dateLastEdited: 1,
                    data: "Story 1!",
                    type: StoryType.TEXT_STORY)
              ]))
        ],
        verify: (_) {
          verify(memoryRepository.removeMemory(Memory(
              id: 1,
              dateCreated: 1,
              dateLastEdited: 1,
              storyPreviewId: 1,
              stories: [
                Story(
                    id: 1,
                    dateCreated: 1,
                    dateLastEdited: 1,
                    data: "Story 1!",
                    type: StoryType.TEXT_STORY)
              ]))).called(1);
        });

    /// make sure bloc updates memories
    blocTest<MemoriesBloc, MemoriesState>(
        "On successful MemoriesMemoryUpdated, should return MemoriesSaveSuccess with the memory",
        build: () => memoriesBloc,
        act: (MemoriesBloc bloc) async {
          bloc
            ..add(MemoriesBlocLoadMemories(null))
            ..add(MemoriesBlocUpdateMemory(Memory(
                id: 1,
                dateCreated: 1,
                dateLastEdited: 5,
                storyPreviewId: 1,
                stories: [
                  Story(
                      id: 1,
                      dateCreated: 1,
                      dateLastEdited: 1,
                      data: "Story 1!",
                      type: StoryType.TEXT_STORY),
                  Story(
                      id: 5,
                      dateCreated: 5,
                      dateLastEdited: 5,
                      data: "Story 5!",
                      type: StoryType.TEXT_STORY)
                ])));
        },
        expect: <MemoriesState>[
          MemoriesLoadInProgress(),
          MemoriesLoadSuccess(memories: memories),
          MemoriesSaveInProgress(),
          MemoriesSaveSuccess(Memory(
              id: 1,
              dateCreated: 1,
              dateLastEdited: 5,
              storyPreviewId: 1,
              stories: [
                Story(
                    id: 1,
                    dateCreated: 1,
                    dateLastEdited: 1,
                    data: "Story 1!",
                    type: StoryType.TEXT_STORY),
                Story(
                    id: 5,
                    dateCreated: 5,
                    dateLastEdited: 5,
                    data: "Story 5!",
                    type: StoryType.TEXT_STORY)
              ]))
        ],
        verify: (_) {
          verify(memoryRepository.saveMemory(Memory(
              id: 1,
              dateCreated: 1,
              dateLastEdited: 5,
              storyPreviewId: 1,
              stories: [
                Story(
                    id: 1,
                    dateCreated: 1,
                    dateLastEdited: 1,
                    data: "Story 1!",
                    type: StoryType.TEXT_STORY),
                Story(
                    id: 5,
                    dateCreated: 5,
                    dateLastEdited: 5,
                    data: "Story 5!",
                    type: StoryType.TEXT_STORY)
              ]))).called(1);
        });

    /// make sure bloc gives error on repo.fetchMemories() error
    blocTest<MemoriesBloc, MemoriesState>(
        "On failure of repo.fetchMemories(), should return MemoriesLoadFailure with the error",
        build: () {
          when(memoryRepository.fetchMemories(any, any))
              .thenThrow(Exception("LoadError"));
          return memoriesBloc;
        },
        act: (MemoriesBloc bloc) async {
          bloc..add(MemoriesBlocLoadMemories(null));
        },
        expect: <MemoriesState>[
          MemoriesLoadInProgress(),
          MemoriesLoadFailure(Exception("LoadError").toString())
        ],
        verify: (_) {
          verify(memoryRepository.fetchMemories(any, any)).called(1);
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
            ..add(MemoriesBlocLoadMemories(null))
            ..add(MemoriesMemoryAdded(Memory(
                id: 4,
                dateCreated: 4,
                dateLastEdited: 4,
                storyPreviewId: 5,
                stories: [
                  Story(
                      id: 5,
                      dateCreated: 4,
                      dateLastEdited: 4,
                      data: "Story 5!",
                      type: StoryType.TEXT_STORY)
                ])));
        },
        expect: <MemoriesState>[
          MemoriesLoadInProgress(),
          MemoriesLoadSuccess(memories: memories),
          MemoriesSaveInProgress(),
          MemoriesSaveFailure(Exception("SaveError").toString())
        ],
        verify: (_) {
          verify(memoryRepository.saveMemory(Memory(
              id: 4,
              dateCreated: 4,
              dateLastEdited: 4,
              storyPreviewId: 5,
              stories: [
                Story(
                    id: 5,
                    dateCreated: 4,
                    dateLastEdited: 4,
                    data: "Story 5!",
                    type: StoryType.TEXT_STORY)
              ]))).called(1);
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
            ..add(MemoriesBlocLoadMemories(null))
            ..add(MemoriesMemoryRemoved(Memory(
                id: 1,
                dateCreated: 1,
                dateLastEdited: 1,
                storyPreviewId: 1,
                stories: [
                  Story(
                      id: 1,
                      dateCreated: 1,
                      dateLastEdited: 1,
                      data: "Story 1!",
                      type: StoryType.TEXT_STORY)
                ])));
        },
        expect: <MemoriesState>[
          MemoriesLoadInProgress(),
          MemoriesLoadSuccess(memories: memories),
          MemoriesSaveInProgress(),
          MemoriesSaveFailure(Exception("RemoveError").toString())
        ],
        verify: (_) {
          verify(memoryRepository.removeMemory(Memory(
              id: 1,
              dateCreated: 1,
              dateLastEdited: 1,
              storyPreviewId: 1,
              stories: [
                Story(
                    id: 1,
                    dateCreated: 1,
                    dateLastEdited: 1,
                    data: "Story 1!",
                    type: StoryType.TEXT_STORY)
              ]))).called(1);
        });
  });
}
