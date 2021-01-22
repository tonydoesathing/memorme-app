import 'package:bloc_test/bloc_test.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/data/repositories/local_memory_repository.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';
import 'package:memorme_android_flutter/logic/edit_memory_bloc/edit_memory_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockMemoryRepository extends Mock implements LocalMemoryRepository {}

main() {
  group("EditMemoryBloc Test >", () {
    EditMemoryBloc editMemoryBloc;
    MemoryRepository memoryRepository;

    const Memory memory = Memory(
        id: 5,
        dateCreated: 15,
        dateLastEdited: 25,
        storyPreviewId: 10,
        stories: [
          Story(
              id: 10,
              dateCreated: 15,
              dateLastEdited: 25,
              data: "Story 10",
              type: StoryType.TEXT_STORY)
        ]);

    setUp(() {
      memoryRepository = MockMemoryRepository();

      editMemoryBloc = EditMemoryBloc(memoryRepository);
    });

    test("Not passing in a memory should create an empty memory", () async {
      expect(editMemoryBloc.state,
          EditMemoryDisplayed(Memory(stories: []), Memory(stories: [])));
    });

    test("Passing in a memory should return an initial state with that memory",
        () async {
      editMemoryBloc = EditMemoryBloc(memoryRepository,
          memory: Memory(
              id: 5,
              dateCreated: 15,
              dateLastEdited: 25,
              storyPreviewId: 10,
              stories: [
                Story(
                    id: 10,
                    dateCreated: 15,
                    dateLastEdited: 25,
                    data: "Story 10",
                    type: StoryType.TEXT_STORY)
              ]));
      expect(
          editMemoryBloc.state,
          EditMemoryDisplayed(
              Memory(
                  id: 5,
                  dateCreated: 15,
                  dateLastEdited: 25,
                  storyPreviewId: 10,
                  stories: [
                    Story(
                        id: 10,
                        dateCreated: 15,
                        dateLastEdited: 25,
                        data: "Story 10",
                        type: StoryType.TEXT_STORY)
                  ]),
              Memory(stories: [])));
    });

    test("Testing equality", () {
      expect(
          Memory(
              id: 5,
              dateCreated: 15,
              dateLastEdited: 25,
              storyPreviewId: 10,
              stories: [
                Story(
                    id: 10,
                    dateCreated: 15,
                    dateLastEdited: 25,
                    data: "Story 10",
                    type: StoryType.TEXT_STORY)
              ]),
          memory);
      expect(EditMemoryLoading(Memory(stories: []), Memory(stories: [])),
          EditMemoryLoading(Memory(stories: []), Memory(stories: [])));
      expect(
          EditMemoryDisplayed(memory, Memory(stories: [])),
          EditMemoryDisplayed(
              Memory(
                  id: 5,
                  dateCreated: 15,
                  dateLastEdited: 25,
                  storyPreviewId: 10,
                  stories: [
                    Story(
                        id: 10,
                        dateCreated: 15,
                        dateLastEdited: 25,
                        data: "Story 10",
                        type: StoryType.TEXT_STORY)
                  ]),
              Memory(stories: [])));
    });

    // blocTest<EditMemoryBloc, EditMemoryState>("description",
    //     build: () {}, act: (bloc) {}, expect: <EditMemoryState>[]);
    blocTest<EditMemoryBloc, EditMemoryState>(
      "On successful save, should save to repo and return saved state",
      build: () {
        when(memoryRepository.saveMemory(any))
            .thenAnswer((_) => Future.value(memory));
        return editMemoryBloc;
      },
      act: (bloc) {
        bloc.add(EditMemoryBlocSaveMemory());
      },
      expect: <EditMemoryState>[
        EditMemoryLoading(Memory(stories: []), Memory(stories: [])),
        EditMemorySaved(memory, Memory(stories: []))
      ],
      verify: (cubit) {
        verify(memoryRepository.saveMemory(Memory(stories: [])));
      },
    );

    blocTest<EditMemoryBloc, EditMemoryState>(
      "On failed save, should return error",
      build: () {
        when(memoryRepository.saveMemory(any))
            .thenThrow(Exception("Could not save"));
        return editMemoryBloc;
      },
      act: (bloc) {
        bloc.add(EditMemoryBlocSaveMemory());
      },
      expect: <EditMemoryState>[
        EditMemoryLoading(Memory(stories: []), Memory(stories: [])),
        EditMemoryError(
            Memory(stories: []), Memory(stories: []), "Could not save")
      ],
      verify: (cubit) {
        verify(memoryRepository.saveMemory(Memory(stories: [])));
      },
    );

// TODO: figure out how to test this with the FileProvider in there

/*    blocTest<EditMemoryBloc, EditMemoryState>(
      "On successful discard, should return discarded state",
      build: () {
        when(memoryRepository.removeMemory(any))
            .thenAnswer((_) => Future.value(memory));
        return editMemoryBloc;
      },
      act: (bloc) {
        bloc.add(EditMemoryBlocDiscardMemory());
      },
      expect: <EditMemoryState>[
        EditMemoryLoading(Memory(stories: []), Memory(stories: [])),
        EditMemoryDiscarded(memory, Memory(stories: []))
      ],
      verify: (cubit) {
        verify(memoryRepository.removeMemory(Memory(stories: [])));
      },
    );

    blocTest<EditMemoryBloc, EditMemoryState>(
      "On failed delete, should return error",
      build: () {
        when(memoryRepository.removeMemory(any))
            .thenThrow(Exception("Could not remove memory"));
        return editMemoryBloc;
      },
      act: (bloc) {
        bloc.add(EditMemoryBlocDiscardMemory());
      },
      expect: <EditMemoryState>[
        EditMemoryLoading(Memory(stories: []), Memory(stories: [])),
        EditMemoryError(
            Memory(stories: []), Memory(stories: []), "Could not remove memory")
      ],
      verify: (cubit) {
        verify(memoryRepository.removeMemory(Memory(stories: [])));
      },
    ); */

    blocTest<EditMemoryBloc, EditMemoryState>(
      "On successful story add, should return memory display with the modified memory",
      build: () {
        return editMemoryBloc;
      },
      act: (bloc) {
        bloc.add(EditMemoryBlocAddStory(
            Story(data: "wow", type: StoryType.TEXT_STORY)));
      },
      expect: <EditMemoryState>[
        EditMemoryLoading(Memory(stories: []), Memory(stories: [])),
        EditMemoryDisplayed(
            Memory(stories: [Story(data: "wow", type: StoryType.TEXT_STORY)]),
            Memory(stories: []))
      ],
    );

    // blocTest<EditMemoryBloc, EditMemoryState>(
    //     "On successful save of new memory, should return EditMemoryLoaded state with the saved memory and new ID",
    //     build: () {
    //   when(memoryRepository.saveMemory(any))
    //       .thenAnswer((_) => Future.value(memory));
    //   return editMemoryBloc;
    // }, act: (bloc) {
    //   Memory mem = Memory(
    //       dateCreated: 15,
    //       dateLastEdited: 25,
    //       storyPreviewId: 10,
    //       stories: [
    //         Story(
    //             id: 10,
    //             dateCreated: 15,
    //             dateLastEdited: 25,
    //             data: "Story 10",
    //             type: StoryType.TEXT_STORY)
    //       ]);
    //   bloc.add(EditMemoryBlocSaveMemory(mem));
    // }, expect: <EditMemoryState>[
    //   EditMemoryLoading(Memory(
    //       dateCreated: 15,
    //       dateLastEdited: 25,
    //       storyPreviewId: 10,
    //       stories: [
    //         Story(
    //             id: 10,
    //             dateCreated: 15,
    //             dateLastEdited: 25,
    //             data: "Story 10",
    //             type: StoryType.TEXT_STORY)
    //       ])),
    //   EditMemoryLoaded(memory)
    // ]);

    // blocTest<EditMemoryBloc, EditMemoryState>(
    //     "On successful removal of memory, should return EditMemoryRemoved state with the removed memory",
    //     build: () {
    //   when(memoryRepository.removeMemory(any))
    //       .thenAnswer((_) => Future.value(memory));
    //   return editMemoryBloc;
    // }, act: (bloc) {
    //   bloc.add(EditMemoryBlocRemoveMemory(memory));
    // }, expect: <EditMemoryState>[
    //   EditMemoryLoading(memory),
    //   EditMemoryRemoved(memory)
    // ]);

    // blocTest<EditMemoryBloc, EditMemoryState>(
    //     "On failed removal of memory, should return EditMemoryError state with the attempted memory and the error",
    //     build: () {
    //   when(memoryRepository.removeMemory(any))
    //       .thenThrow(Exception("Could not remove memory"));
    //   return editMemoryBloc;
    // }, act: (bloc) {
    //   bloc.add(EditMemoryBlocRemoveMemory(memory));
    // }, expect: <EditMemoryState>[
    //   EditMemoryLoading(memory),
    //   EditMemoryError(memory, "Could not remove memory")
    // ]);
  });
}
