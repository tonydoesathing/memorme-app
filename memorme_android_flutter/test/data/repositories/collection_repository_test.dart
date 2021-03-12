import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/data/models/collections/collection_type.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:memorme_android_flutter/data/repositories/local_collection_repository.dart';
import 'package:test/test.dart';

main() {
  group("Local Collection Data Repository Test >", () {
    LocalCollectionRepository repo;

    setUp(() {
      repo = LocalCollectionRepository();
    });

    test("Should start off with empty repo", () async {
      List<Collection> collections = await repo.fetchCollections(5, null);
      expect(collections, []);
    });

    test("Should be able to save a collection", () async {
      expect(await repo.fetchCollections(5, null), []);
      List<Story> stories = [Story(id: 1), Story(id: 2)];
      Memory m = Memory(
          id: 3,
          title: "meow",
          previewStory: stories[0],
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now(),
          stories: stories);

      Collection col = Collection(
        id: 0,
        type: CollectionType.DECK,
        title: "WOW",
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.now(),
        mcRelations: [
          MCRelation(
              id: 0,
              memoryID: 3,
              collectionID: 0,
              relationshipData: "0",
              dateCreated: DateTime.now(),
              dateLastEdited: DateTime.now())
        ],
      );

      Collection savedCollection = await repo.saveCollection(col);
      expect(savedCollection, col);

      expect(await repo.fetchCollections(5, null), [col]);
    });

    test(
        "Saving collection without ID should give ID to collection and its MCData",
        () async {
      expect(await repo.fetchCollections(5, null), []);
      List<Story> stories = [Story(id: 1), Story(id: 2)];
      Memory m = Memory(
          id: 3,
          title: "meow",
          previewStory: stories[0],
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now(),
          stories: stories);

      Collection col = Collection(
        type: CollectionType.DECK,
        title: "WOW",
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.now(),
        mcRelations: [
          MCRelation(
              memoryID: 3,
              relationshipData: "0",
              dateCreated: DateTime.now(),
              dateLastEdited: DateTime.now())
        ],
      );

      Collection savedCollection = await repo.saveCollection(col);

      Collection expectedCollection =
          Collection.editCollection(col, id: 0, mcRelations: [
        MCRelation.editMCRelation(col.mcRelations[0], id: 0, collectionID: 0)
      ]);
      expect(savedCollection, expectedCollection);

      expect(await repo.fetchCollections(5, null), [expectedCollection]);
    });

    test("Should be able to fetch a collection", () async {
      expect(await repo.fetchCollections(5, null), []);
      List<Story> stories = [Story(id: 1), Story(id: 2)];
      Memory m = Memory(
          id: 3,
          title: "meow",
          previewStory: stories[0],
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now(),
          stories: stories);

      Collection col = Collection(
        id: 0,
        type: CollectionType.DECK,
        title: "WOW",
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.now(),
        mcRelations: [
          MCRelation(
              id: 0,
              memoryID: 3,
              collectionID: 0,
              relationshipData: "0",
              dateCreated: DateTime.now(),
              dateLastEdited: DateTime.now())
        ],
      );

      Collection savedCollection = await repo.saveCollection(col);
      expect(savedCollection, col);
    });

    test("Should be able to remove a collection", () async {
      List<Story> stories = [Story(id: 1), Story(id: 2)];
      Memory m = Memory(
          id: 3,
          title: "meow",
          previewStory: stories[0],
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now(),
          stories: stories);

      Collection col = Collection(
        type: CollectionType.DECK,
        title: "WOW",
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.now(),
        mcRelations: [
          MCRelation(
              memoryID: 3,
              relationshipData: "0",
              dateCreated: DateTime.now(),
              dateLastEdited: DateTime.now())
        ],
      );

      Collection savedCollection = await repo.saveCollection(col);

      Collection expectedCollection =
          Collection.editCollection(col, id: 0, mcRelations: [
        MCRelation.editMCRelation(col.mcRelations[0], id: 0, collectionID: 0)
      ]);
      expect(savedCollection, expectedCollection);

      Collection removedCollection =
          await repo.removeCollection(savedCollection);
      expect(await repo.fetchCollections(5, null), []);
    });

    test("Should be able to pageinate collections", () async {
      List<Story> stories = [Story(id: 1), Story(id: 2)];
      Memory m = Memory(
          id: 3,
          title: "meow",
          previewStory: stories[0],
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now(),
          stories: stories);

      List<Collection> collections = [];
      for (int i = 0; i < 10; i++) {
        Collection col = Collection(
          type: CollectionType.DECK,
          title: "WOW",
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now(),
          mcRelations: [
            MCRelation(
                memoryID: 3,
                relationshipData: "0",
                dateCreated: DateTime.now(),
                dateLastEdited: DateTime.now())
          ],
        );
        col = await repo.saveCollection(col);
        collections.add(col);
      }

      collections
          .sort((a, b) => -1 * a.dateLastEdited.compareTo(b.dateLastEdited));

      expect(await repo.fetchCollections(10, null), collections);
      expect(await repo.fetchCollections(2, collections[1]),
          collections.sublist(2, 4));
      collections.sort((a, b) => a.dateLastEdited.compareTo(b.dateLastEdited));
      expect(await repo.fetchCollections(2, collections[1], ascending: true),
          collections.sublist(2, 4));
    });
  });
}
