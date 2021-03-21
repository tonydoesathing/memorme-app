import 'package:memorme_android_flutter/data/models/collections/collection.dart';
import 'package:memorme_android_flutter/data/repositories/collection_repository.dart';

import 'exceptions/element_does_not_exist_exception.dart';

class LocalCollectionRepository implements CollectionRepository {
  List<Collection> _collections = [];
  List<MCRelation> _mcRelations = [];

  @override
  Future<Collection> fetch(int id) async {
    return _collections.firstWhere(
      (element) => element.id == id,
      orElse: () {
        throw ElementNotInStorageException();
      },
    );
  }

  @override
  Future<List<Collection>> fetchCollections(
      int pageSize, Collection lastCollection,
      {bool ascending = false}) async {
    // sort the collections in ascending or descending order based on dateLastEdited
    _collections.sort((a, b) => ascending
        ? a.dateLastEdited.compareTo(b.dateLastEdited)
        : -1 * a.dateLastEdited.compareTo(b.dateLastEdited));

    int indexOfLastCollection = _collections.indexOf(lastCollection);
    if (indexOfLastCollection == -1 && lastCollection != null) {
      throw ElementNotInStorageException();
    }

    int offset = lastCollection == null ? 0 : indexOfLastCollection + 1;
    if (offset + pageSize > _collections.length) {
      // not enough memories left for entire page size;
      // just reutrn up to last value
      return _collections.sublist(offset);
    }
    // return entire pageSize
    return _collections.sublist(offset, offset + pageSize);
  }

  @override
  Future<Collection> removeCollection(Collection collection) async {
    // remove mcRelations
    _mcRelations.removeWhere((element) {
      return element.collectionID == collection.id;
    });
    bool removed = _collections.remove(collection);
    if (!removed) {
      throw ElementNotInStorageException();
    }
    return collection;
  }

  @override
  Future<Collection> saveCollection(Collection collection) async {
    Collection savedCollection = collection;

    // give the collection an id if it doesn't have one
    if (savedCollection.id == null) {
      savedCollection =
          Collection.editCollection(savedCollection, id: _collections.length);
    }

    // check to see if collection is in list and add it if it isn't
    int indexWhere =
        _collections.indexWhere((element) => element.id == savedCollection.id);
    if (indexWhere == -1) {
      _collections.add(savedCollection);
    } else {
      // update it if it is
      _collections[indexWhere] = savedCollection;
    }

    return savedCollection;
  }

  @override
  Future<List<MCRelation>> fetchMCRelations(
      Collection collection, int pageSize, MCRelation lastMCRelation,
      {bool ascending = false}) async {
    // sort the mcRelations in ascending or descending order based on the collection type
    // for deck, sort according to relationshipData
    List<MCRelation> collectionsMCRelations = List.from(
        _mcRelations.where((element) => element.collectionID == collection.id));
    collectionsMCRelations.sort((a, b) => ascending
        ? int.parse(a.relationshipData).compareTo(int.parse(b.relationshipData))
        : -1 *
            int.parse(a.relationshipData)
                .compareTo(int.parse(b.relationshipData)));

    int indexOfLastMCRelation = collectionsMCRelations.indexOf(lastMCRelation);
    if (indexOfLastMCRelation == -1 && lastMCRelation != null) {
      throw ElementNotInStorageException();
    }

    int offset = lastMCRelation == null ? 0 : indexOfLastMCRelation + 1;
    if (offset + pageSize > collectionsMCRelations.length) {
      // not enough mcRelations left for entire page size;
      // just reutrn up to last value
      return collectionsMCRelations.sublist(offset);
    }
    // return entire pageSize
    return collectionsMCRelations.sublist(offset, offset + pageSize);
  }

  @override
  Future<MCRelation> saveMCRelation(MCRelation mcRelation) async {
    MCRelation savedMCRelation = mcRelation;
    // give id if it doesn't have one
    if (savedMCRelation.id == null) {
      savedMCRelation =
          MCRelation.editMCRelation(savedMCRelation, id: _mcRelations.length);
    }
    // if mcRelation in list, update it
    int indexWhere =
        _mcRelations.indexWhere((element) => element.id == savedMCRelation.id);
    if (indexWhere == -1) {
      _mcRelations.add(savedMCRelation);
    } else {
      // update it if it is
      _mcRelations[indexWhere] = savedMCRelation;
    }

    return savedMCRelation;
  }

  @override
  Future<MCRelation> removeMCRelation(MCRelation mcRelation) async {
    bool removed = _mcRelations.remove(mcRelation);
    if (!removed) {
      throw ElementNotInStorageException();
    }
    return mcRelation;
  }
}
