import 'package:equatable/equatable.dart';
import 'package:memorme_android_flutter/data/models/sql_constants.dart';

/// A Collection of [Memories]
class Collection extends Equatable {
  final String previewData;
  final int collectionType;
  final String collectionTitle;
  final int dateCreated;
  final int dateLastEdited;

  const Collection(this.previewData, this.collectionType, this.collectionTitle,
      this.dateCreated, this.dateLastEdited);

  /// Creates a [Collection] from an SQL [map]
  factory Collection.fromMap(Map<String, dynamic> map) {
    final String previewData = map["$preview_data"];
    final int collectionType = map["$type"];
    final String collectionTitle = map["$title"];
    final int dateCreated = map["$date_created"];
    final int dateLastEdited = map["$date_last_edited"];

    return Collection(previewData, collectionType, collectionTitle, dateCreated,
        dateLastEdited);
  }

  /// Turns the [Collection] into an SQL [map]
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "$preview_data": previewData,
      "$type": collectionType,
      "$title": collectionTitle,
      "$date_created": dateCreated,
      "$date_last_edited": dateLastEdited
    };
    return map;
  }

  @override
  List<Object> get props => [
        previewData,
        collectionType,
        collectionTitle,
        dateCreated,
        dateLastEdited
      ];
}

/// Describes relationship between a [Collection] and a [Memory]
class MCData extends Equatable {
  final int memoryFK;
  final int collectionFK;
  final String relationshipData;
  final int dateCreated;
  final int dateLastEdited;

  const MCData(this.memoryFK, this.collectionFK, this.relationshipData,
      this.dateCreated, this.dateLastEdited);

  /// Creates [MCData] object from an SQL [map]
  factory MCData.fromMap(Map<String, dynamic> map) {
    final int memoryFK = map["$memory_fk"];
    final int collectionFK = map["$collection_fk"];
    final String relationshipData = map["$data"];
    final int dateCreated = map["$date_created"];
    final int dateLastEdited = map["$date_last_edited"];

    return MCData(
        memoryFK, collectionFK, relationshipData, dateCreated, dateLastEdited);
  }

  /// Turns [MCData] into an SQL [map]
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "$memory_fk": memoryFK,
      "$collection_fk": collectionFK,
      "$data": relationshipData,
      "$date_created": dateCreated,
      "$date_last_edited": dateLastEdited
    };
    return map;
  }

  @override
  List<Object> get props =>
      [memoryFK, collectionFK, relationshipData, dateCreated, dateLastEdited];
}
