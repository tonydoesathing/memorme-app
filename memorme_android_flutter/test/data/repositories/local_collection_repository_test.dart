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
      );

      Collection savedCollection = await repo.saveCollection(col);

      Collection expectedCollection = Collection.editCollection(
        col,
        id: 0,
      );
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
      );

      Collection savedCollection = await repo.saveCollection(col);

      Collection expectedCollection = Collection.editCollection(
        col,
        id: 0,
      );
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

    test("Should be able to save MCRelations", () async {
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
      );

      Collection savedCollection = await repo.saveCollection(col);
      expect(savedCollection, col);

      expect(await repo.fetchCollections(5, null), [col]);

      MCRelation mcRelation = MCRelation(
          memoryID: m.id,
          collectionID: savedCollection.id,
          relationshipData: 0.toString(),
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now());
      MCRelation savedMCRelation = await repo.saveMCRelation(mcRelation);

      expect(savedMCRelation, MCRelation.editMCRelation(mcRelation, id: 0));
      expect(await repo.fetchMCRelations(savedCollection, 5, null),
          [savedMCRelation]);
    });

    test("Should be able to remove MCRelations", () async {
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
      );

      Collection savedCollection = await repo.saveCollection(col);
      expect(savedCollection, col);

      expect(await repo.fetchCollections(5, null), [col]);

      MCRelation mcRelation = MCRelation(
          memoryID: m.id,
          collectionID: savedCollection.id,
          relationshipData: 0.toString(),
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now());
      MCRelation savedMCRelation = await repo.saveMCRelation(mcRelation);

      expect(savedMCRelation, MCRelation.editMCRelation(mcRelation, id: 0));
      expect(await repo.fetchMCRelations(savedCollection, 5, null),
          [savedMCRelation]);

      MCRelation removedMCRelation =
          await repo.removeMCRelation(savedMCRelation);
      expect(await repo.fetchMCRelations(savedCollection, 5, null), []);
    });

    test(
        "Should be able to fetch a page of MCRelations accord to collection type",
        () async {
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
      );

      Collection savedCollection = await repo.saveCollection(col);
      expect(savedCollection, col);

      expect(await repo.fetchCollections(5, null), [col]);

      List<MCRelation> mcRelations = [];
      for (int i = 0; i < 10; i++) {
        // gets position opposite of its id
        MCRelation mcRelation = MCRelation(
            memoryID: m.id,
            collectionID: savedCollection.id,
            relationshipData: (10 - 1 - i).toString(),
            dateCreated: DateTime.now(),
            dateLastEdited: DateTime.now());
        MCRelation savedMCRelation = await repo.saveMCRelation(mcRelation);
        mcRelations.add(savedMCRelation);
      }
      //get first 5
      List<MCRelation> fetchedMCRelations = await repo
          .fetchMCRelations(savedCollection, 5, null, ascending: true);
      List<MCRelation> sortedMCRelations = List.from(mcRelations);

      expect(sortedMCRelations == mcRelations, false);
      sortedMCRelations.sort((a, b) => int.parse(a.relationshipData)
          .compareTo(int.parse(b.relationshipData)));

      expect(fetchedMCRelations, sortedMCRelations.sublist(0, 5));

      // get next 3
      fetchedMCRelations = await repo.fetchMCRelations(
          savedCollection, 3, fetchedMCRelations.last,
          ascending: true);
      expect(fetchedMCRelations, sortedMCRelations.sublist(5, 8));

      // get last page
      fetchedMCRelations = await repo.fetchMCRelations(
          savedCollection, 5, fetchedMCRelations.last,
          ascending: true);
      expect(fetchedMCRelations, sortedMCRelations.sublist(8, 10));
    });

    test(
        "Should be able to fetch a page of MCRelations for different collections",
        () async {
      List<Story> stories = [Story(id: 1), Story(id: 2)];
      Memory m = Memory(
          id: 3,
          title: "meow",
          previewStory: stories[0],
          dateCreated: DateTime.now(),
          dateLastEdited: DateTime.now(),
          stories: stories);

      Collection col1 = Collection(
        type: CollectionType.DECK,
        title: "WOW",
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.now(),
      );

      Collection col2 = Collection(
        type: CollectionType.DECK,
        title: "WOW",
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.now(),
      );

      Collection savedCollection1 = await repo.saveCollection(col1);
      expect(savedCollection1, Collection.editCollection(col1, id: 0));

      Collection savedCollection2 = await repo.saveCollection(col2);
      expect(savedCollection2, Collection.editCollection(col2, id: 1));

      expect(await repo.fetchCollections(5, null),
          [savedCollection1, savedCollection2]);

      List<MCRelation> mcRelations1 = [];
      for (int i = 0; i < 10; i++) {
        // gets position opposite of its id
        MCRelation mcRelation = MCRelation(
            memoryID: m.id,
            collectionID: savedCollection1.id,
            relationshipData: (10 - 1 - i).toString(),
            dateCreated: DateTime.now(),
            dateLastEdited: DateTime.now());
        MCRelation savedMCRelation = await repo.saveMCRelation(mcRelation);
        mcRelations1.add(savedMCRelation);
      }
      // next collection
      List<MCRelation> mcRelations2 = [];
      for (int i = 0; i < 10; i++) {
        // gets position opposite of its id
        MCRelation mcRelation = MCRelation(
            memoryID: m.id,
            collectionID: savedCollection2.id,
            relationshipData: (10 - 1 - i).toString(),
            dateCreated: DateTime.now(),
            dateLastEdited: DateTime.now());
        MCRelation savedMCRelation = await repo.saveMCRelation(mcRelation);
        mcRelations2.add(savedMCRelation);
      }

      //get first 5
      List<MCRelation> fetchedMCRelations = await repo
          .fetchMCRelations(savedCollection1, 5, null, ascending: true);
      List<MCRelation> sortedMCRelations = List.from(mcRelations1);

      expect(sortedMCRelations == mcRelations1, false);
      sortedMCRelations.sort((a, b) => int.parse(a.relationshipData)
          .compareTo(int.parse(b.relationshipData)));

      expect(fetchedMCRelations, sortedMCRelations.sublist(0, 5));

      print(fetchedMCRelations);

      // get next 3
      fetchedMCRelations = await repo.fetchMCRelations(
          savedCollection1, 3, fetchedMCRelations.last,
          ascending: true);
      expect(fetchedMCRelations, sortedMCRelations.sublist(5, 8));

      // get last page
      fetchedMCRelations = await repo.fetchMCRelations(
          savedCollection1, 5, fetchedMCRelations.last,
          ascending: true);
      expect(fetchedMCRelations, sortedMCRelations.sublist(8, 10));

      // second collection
      //get first 5
      fetchedMCRelations = await repo
          .fetchMCRelations(savedCollection2, 5, null, ascending: true);
      sortedMCRelations = List.from(mcRelations2);

      expect(sortedMCRelations == mcRelations2, false);
      sortedMCRelations.sort((a, b) => int.parse(a.relationshipData)
          .compareTo(int.parse(b.relationshipData)));

      expect(fetchedMCRelations, sortedMCRelations.sublist(0, 5));

      print(fetchedMCRelations);
      // get next 3
      fetchedMCRelations = await repo.fetchMCRelations(
          savedCollection2, 3, fetchedMCRelations.last,
          ascending: true);
      expect(fetchedMCRelations, sortedMCRelations.sublist(5, 8));

      // get last page
      fetchedMCRelations = await repo.fetchMCRelations(
          savedCollection2, 5, fetchedMCRelations.last,
          ascending: true);
      expect(fetchedMCRelations, sortedMCRelations.sublist(8, 10));
    });
  });
}
