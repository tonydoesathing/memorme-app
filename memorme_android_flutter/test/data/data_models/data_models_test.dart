import 'package:flutter_test/flutter_test.dart';
import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/data/models/collections/collection_type.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';

main() {
  group("Mapping >", () {
    test("Do memory maps work", () {
      Memory m = Memory(
        id: 3,
      );
      Map mappedM = m.toMap();
      Memory unmappedM = Memory.fromMap(mappedM, null);
      expect(m, unmappedM);

      m = Memory(
        id: 3,
        title: "meow",
      );
      mappedM = m.toMap();
      unmappedM = Memory.fromMap(mappedM, null);
      expect(m, unmappedM);

      m = Memory(
          id: 3,
          title: "meow",
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now());
      mappedM = m.toMap();
      unmappedM = Memory.fromMap(mappedM, null);
      expect(m, unmappedM);

      // this fails because there's a [previewStory] but [stories] is empty
      // m = Memory(
      //     id: 3,
      //     title: "meow",
      //     previewStory: Story(id: 2),
      //     dateCreated: DateTime.now(),
      //     dateLastEdited: DateTime.now(),
      //     createLocation: 5);
      // mappedM = m.toMap();
      // unmappedM = Memory.fromMap(mappedM, []);
      // expect(m, unmappedM);

      List<Story> stories = [Story(id: 1), Story(id: 2)];

      m = Memory(
          id: 3,
          title: "meow",
          previewStory: stories[0],
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now(),
          stories: stories);
      mappedM = m.toMap();
      unmappedM = Memory.fromMap(mappedM, stories);
      expect(m, unmappedM);
    });

    test("Do story maps work", () {
      Memory parent = Memory(id: 1, stories: []);
      Story s = Story(id: 1);
      parent.stories.add(s);
      Map mappedS = s.toMap(parent);
      Story unmappedS = Story.fromMap(mappedS);
      expect(s, unmappedS);
      parent.stories.removeLast();

      s = Story(
          id: 1, dateCreated: DateTime.now(), dateLastEdited: DateTime.now());
      parent.stories.add(s);
      mappedS = s.toMap(parent);
      unmappedS = Story.fromMap(mappedS);
      expect(s, unmappedS);
      parent.stories.removeLast();

      s = Story(id: 1, type: StoryType.TEXT_STORY, data: "FUCK");
      parent.stories.add(s);
      mappedS = s.toMap(parent);
      unmappedS = Story.fromMap(mappedS);
      expect(s, unmappedS);
      parent.stories.removeLast();
    });

    test("Do collection maps work", () {
      Collection c = Collection(id: 1);
      Map mappedC = c.toMap();
      Collection unmappedC = Collection.fromMap(mappedC, null);
      expect(c, unmappedC);

      c = Collection(
          id: 1, dateCreated: DateTime.now(), dateLastEdited: DateTime.now());
      mappedC = c.toMap();
      unmappedC = Collection.fromMap(mappedC, null);
      expect(c, unmappedC);

      List<MCRelation> mcRelations = [
        MCRelation(
            collectionID: 1,
            memoryID: 1,
            relationshipData: "meow",
            dateCreated: DateTime.now(),
            dateLastEdited: DateTime.now())
      ];
      c = Collection(
          id: 1,
          previewData: "FUCk",
          type: CollectionType.DECK,
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now(),
          mcRelations: mcRelations);
      mappedC = c.toMap();
      unmappedC = Collection.fromMap(mappedC, mcRelations);
      expect(c, unmappedC);
    });

    test("Do memory-collection object maps work", () {
      MCRelation mc = MCRelation(memoryID: 1, collectionID: 1);
      Map mappedMC = mc.toMap();
      MCRelation unmappedMC = MCRelation.fromMap(mappedMC);
      expect(mc, unmappedMC);

      mc = MCRelation(
          memoryID: 1,
          collectionID: 1,
          relationshipData: "baLUga",
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now());
      mappedMC = mc.toMap();
      unmappedMC = MCRelation.fromMap(mappedMC);
      expect(mc, unmappedMC);
    });
  });
}
