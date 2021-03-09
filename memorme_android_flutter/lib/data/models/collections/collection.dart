import 'package:equatable/equatable.dart';
import 'package:memorme_android_flutter/data/models/sql_constants.dart';

/// A [Collection] is a collection of [MCRelation]s with an [id], [previewData], [type], [title], [dateCreated], annd [dateLastEdited]
class Collection extends Equatable {
  final int id;
  final String previewData;
  final int type;
  final String title;
  final DateTime dateCreated;
  final DateTime dateLastEdited;
  final List<MCRelation> mcRelations;

  const Collection(
      {this.id,
      this.previewData,
      this.type,
      this.title,
      this.dateCreated,
      this.dateLastEdited,
      this.mcRelations});

  /// Creates a [Collection] from an SQL [map] and a list of [mcRelations]
  factory Collection.fromMap(
      Map<String, dynamic> map, List<MCRelation> mcRelations) {
    final int collectionId = map["$row_id"];
    final String previewData = map["$preview_data"];
    final int collectionType = map["$row_type"];
    final String collectionTitle = map["$row_title"];
    final int dateCreated = map["$date_created"];
    final int dateLastEdited = map["$date_last_edited"];

    return Collection(
        id: collectionId,
        previewData: previewData,
        type: collectionType,
        title: collectionTitle,
        dateCreated: dateCreated != null
            ? DateTime.fromMillisecondsSinceEpoch(dateCreated)
            : null,
        dateLastEdited: dateLastEdited != null
            ? DateTime.fromMillisecondsSinceEpoch(dateCreated)
            : null,
        mcRelations: mcRelations);
  }

  /// Edit an existing [collection] with optional parameters
  factory Collection.editCollection(
    Collection collection, {
    int id,
    String previewData,
    int type,
    String title,
    DateTime dateCreated,
    DateTime dateLastEdited,
    List<MCRelation> mcRelations,
  }) {
    return Collection(
        id: id ?? collection.id,
        previewData: previewData ?? collection.previewData,
        type: type ?? collection.type,
        title: title ?? collection.title,
        dateCreated: dateCreated ?? collection.dateCreated,
        dateLastEdited: dateLastEdited ?? collection.dateLastEdited,
        mcRelations: mcRelations ?? collection.mcRelations);
  }

  /// Turns the [Collection] into an SQL [map]
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "$row_id": id,
      "$preview_data": previewData,
      "$row_type": type,
      "$row_title": title,
      "$date_created": dateCreated?.millisecondsSinceEpoch,
      "$date_last_edited": dateLastEdited?.millisecondsSinceEpoch
    };
    return map;
  }

  @override
  List<Object> get props => [
        id,
        previewData,
        type,
        title,
        dateCreated?.millisecondsSinceEpoch,
        dateLastEdited?.millisecondsSinceEpoch,
        mcRelations
      ];
}

/// Describes relationship between a [Collection] and a [Memory]
class MCRelation extends Equatable {
  final int id;
  final int memoryID;
  final int collectionID;
  final String relationshipData;
  final DateTime dateCreated;
  final DateTime dateLastEdited;

  const MCRelation(
      {this.id,
      this.memoryID,
      this.collectionID,
      this.relationshipData,
      this.dateCreated,
      this.dateLastEdited});

  /// Creates [MCRelation] object from an SQL [map]
  factory MCRelation.fromMap(Map<String, dynamic> map) {
    final int id = map["$row_id"];
    final int memoryFK = map["$memory_fk"];
    final int collectionFK = map["$collection_fk"];
    final String relationshipData = map["$row_data"];
    final int dateCreated = map["$date_created"];
    final int dateLastEdited = map["$date_last_edited"];

    return MCRelation(
      id: id,
      memoryID: memoryFK,
      collectionID: collectionFK,
      relationshipData: relationshipData,
      dateCreated: dateCreated != null
          ? DateTime.fromMillisecondsSinceEpoch(dateCreated)
          : null,
      dateLastEdited: dateLastEdited != null
          ? DateTime.fromMillisecondsSinceEpoch(dateLastEdited)
          : null,
    );
  }

  /// Turns [MCRelation] into an SQL [map]
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "$row_id": id,
      "$memory_fk": memoryID,
      "$collection_fk": collectionID,
      "$row_data": relationshipData,
      "$date_created": dateCreated?.millisecondsSinceEpoch,
      "$date_last_edited": dateLastEdited?.millisecondsSinceEpoch
    };
    return map;
  }

  @override
  List<Object> get props => [
        id,
        memoryID,
        collectionID,
        relationshipData,
        dateCreated?.millisecondsSinceEpoch,
        dateLastEdited?.millisecondsSinceEpoch
      ];
}
