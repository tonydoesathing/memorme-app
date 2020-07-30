import 'dart:math';

import 'package:memorme_android_flutter/models/memory.dart';
import 'package:test/test.dart';

main() {
  group("Memory data model test >", () {
    group("Stories test >", () {
      test('Story should be added to memory', () {
        Memory memory = new Memory();
        int index = memory.addStory("story");
        expect(memory.getAllStories().length, 1);
        expect(index, 0);
        expect(memory.getStory(index), "story");
      });
      test("Should add list of stories to memory", () {
        Memory memory = Memory(stories: ["memow"]);
        expect(memory.getAllStories().length, 1);
        expect(memory.getStory(0), "memow");
      });
      test('Story in memory should be edited', () {
        Memory memory = Memory();
        int index = memory.addStory("story");
        expect(memory.getAllStories().length, 1);
        expect(index, 0);
        expect(memory.getStory(index), "story");
        memory.editStory(index, "hamster");
        expect(memory.getStory(index), "hamster");
      });
      test('Cannot edit story that isnt in memory', () {
        Memory memory = Memory();
        int index = memory.addStory("story");
        expect(memory.getAllStories().length, 1);
        expect(index, 0);
        expect(memory.getStory(index), "story");
        memory.editStory(5, "hamster");
        expect(memory.getStory(index), "story");
        memory.editStory(-4, "meow");
        expect(memory.getAllStories().length, 1);
      });
      test('Cannot remove story that isnt in memory', () {
        Memory memory = Memory();
        int index = memory.addStory("story");
        expect(memory.getAllStories().length, 1);
        expect(index, 0);
        expect(memory.getStory(index), "story");
        memory.removeStory(5);
        expect(memory.getAllStories().length, 1);
        memory.removeStory(-5);
        expect(memory.getAllStories().length, 1);
      });
      test('Story should be removed from memory', () {
        Memory memory = Memory();
        int index = memory.addStory("story");
        expect(memory.getAllStories().length, 1);
        expect(index, 0);
        expect(memory.getStory(index), "story");
        memory.removeStory(index);
        expect(memory.getAllStories().length, 0);
      });
      test('null Story should not be added to memory', () {
        Memory memory = Memory();
        memory.addStory(null);
        expect(memory.getAllStories().length, 0);
      });
      test('On delete, null index story should not crash', () {
        Memory memory = Memory();
        int i = memory.addStory("meow");
        expect(memory.getAllStories().length, 1);
        memory.removeStory(null);
        expect(memory.getAllStories().length, 1);
      });
      test('On edit, null index and/or null story should not crash', () {
        Memory memory = Memory();
        int index = memory.addStory("meow");
        expect(memory.getAllStories().length, 1);
        memory.editStory(null, "newStory");
        expect(memory.getStory(index), "meow");
        expect(memory.getAllStories().length, 1);
        memory.editStory(0, null);
        expect(memory.getStory(index), "meow");
        expect(memory.getAllStories().length, 1);
        memory.editStory(null, null);
        expect(memory.getStory(index), "meow");
        expect(memory.getAllStories().length, 1);
      });
    });
    group("Media test >", () {
      test('Media URL should be added to memory', () {
        Memory memory = Memory();
        int i = memory.addMedia("meow");
        expect(memory.getAllMedia().length, 1);
        expect(memory.getMedia(i), "meow");
      });
      test("Should add list of media URL's to memory", () {
        Memory memory = Memory(media: ["memow"]);
        expect(memory.getAllMedia().length, 1);
        expect(memory.getMedia(0), "memow");
      });
      test('Media URL should be removed from memory', () {
        Memory memory = Memory();
        int i = memory.addMedia("meow");
        expect(memory.getAllMedia().length, 1);
        expect(memory.getMedia(i), "meow");
        memory.removeMedia(i);
        expect(memory.getAllMedia().length, 0);
      });
      test('On removal null media URL should not crash', () {
        Memory memory = Memory();
        int i = memory.addMedia("meow");
        expect(memory.getAllMedia().length, 1);
        expect(memory.getMedia(i), "meow");
        memory.removeMedia(null);
        expect(memory.getAllMedia().length, 1);
      });
      test('On add null media URL should not crash', () {
        Memory memory = Memory();
        int i = memory.addMedia("meow");
        expect(memory.getAllMedia().length, 1);
        expect(memory.getMedia(i), "meow");
        memory.addMedia(null);
        expect(memory.getAllMedia().length, 1);
      });
    });
  });
}
