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
    for (MCRelation mcRelation in collection.mcRelations) {
      _mcRelations.remove(mcRelation);
    }
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

    List<MCRelation> updatedRelations = [];
    // Update the MCRelations
    for (MCRelation relation in savedCollection.mcRelations) {
      // give the relations the collection id
      MCRelation editedRelation =
          MCRelation.editMCRelation(relation, collectionID: savedCollection.id);
      // check to see if relation is in list
      int indexWhere =
          _mcRelations.indexWhere((element) => element.id == editedRelation.id);
      if (indexWhere == -1) {
        // not in array; add it
        editedRelation =
            MCRelation.editMCRelation(editedRelation, id: _mcRelations.length);
        _mcRelations.add(editedRelation);
      } else {
        // in array; update it
        _mcRelations[indexWhere] = editedRelation;
      }
      updatedRelations.add(editedRelation);
    }
    savedCollection = Collection.editCollection(savedCollection,
        mcRelations: updatedRelations);

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
}
