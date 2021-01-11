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
                data: "Story 1",
                type: StoryType.TEXT_STORY)
          ]),
    ];
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
      expect(editMemoryBloc.state, EditMemoryInitial(Memory()));
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
          EditMemoryInitial(Memory(
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
              ])));
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
      expect(EditMemoryLoading(Memory()), EditMemoryLoading(Memory()));
      expect(
          EditMemoryLoaded(memory),
          EditMemoryLoaded(Memory(
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
              ])));
    });

    blocTest<EditMemoryBloc, EditMemoryState>(
        "On successful save of new memory, should return EditMemoryLoaded state with the saved memory and new ID",
        build: () {
      when(memoryRepository.saveMemory(any))
          .thenAnswer((_) => Future.value(memory));
      return editMemoryBloc;
    }, act: (bloc) {
      Memory mem = Memory(
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
      bloc.add(EditMemoryBlocSaveMemory(mem));
    }, expect: <EditMemoryState>[
      EditMemoryLoading(Memory(
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
          ])),
      EditMemoryLoaded(memory)
    ]);

    blocTest<EditMemoryBloc, EditMemoryState>(
        "On successful removal of memory, should return EditMemoryRemoved state with the removed memory",
        build: () {
      when(memoryRepository.removeMemory(any))
          .thenAnswer((_) => Future.value(memory));
      return editMemoryBloc;
    }, act: (bloc) {
      bloc.add(EditMemoryBlocRemoveMemory(memory));
    }, expect: <EditMemoryState>[
      EditMemoryLoading(memory),
      EditMemoryRemoved(memory)
    ]);

    blocTest<EditMemoryBloc, EditMemoryState>(
        "On failed removal of memory, should return EditMemoryError state with the attempted memory and the error",
        build: () {
      when(memoryRepository.removeMemory(any))
          .thenThrow(Exception("Could not remove memory"));
      return editMemoryBloc;
    }, act: (bloc) {
      bloc.add(EditMemoryBlocRemoveMemory(memory));
    }, expect: <EditMemoryState>[
      EditMemoryLoading(memory),
      EditMemoryError(memory, "Could not remove memory")
    ]);
  });
}
