import 'package:equatable/equatable.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';

//SQL constants
const String storiesTable = "Stories";
const String storyIdColumn = "story_id";
const String storyDateCreatedColumn = "date_created";
const String storyDatedLastEditedColumn = "date_last_edited";
const String storyDataColumn = "data";
const String storyTypeColumn = "type";

/// A data representation of a story; a memory is made up of many stories
///
/// A story has an [id], the [dateCreated], the [dateLastEdited], the actual [data], and a [type]
///
/// Different stories store different [data], and the [type] tells you how to read and write it
class Story extends Equatable {
  final int id;
  final int dateCreated;
  final int dateLastEdited;
  final String data;
  final int type;
  //TODO: make UUID when doing cloud things
  //final String uuid;

  /// Creates a story with an [id], the [dateCreated], the [dateLastEdited], the actual [data], and a [type]
  ///
  /// Different stories store different [data], and the [type] tells you how to read and write it
  const Story(
      {this.id, this.dateCreated, this.dateLastEdited, this.data, this.type});

  /// Creates a [Story] from an SQL [map]
  factory Story.fromMap(Map<String, dynamic> map) {
    final int id = map[storyIdColumn];
    final int dateCreated = map[storyDateCreatedColumn];
    final int dateLastEdited = map[storyDatedLastEditedColumn];
    final String data = map[storyDataColumn];
    final int type = map[storyTypeColumn];

    return Story(
        id: id,
        dateCreated: dateCreated,
        dateLastEdited: dateLastEdited,
        data: data,
        type: type);
  }

  /// Creates a [Story] from an old story
  factory Story.editStory(Story s, String data, int lastEditedTime) {
    return Story(
        id: s.id,
        dateCreated: s.dateCreated,
        dateLastEdited: lastEditedTime,
        data: data,
        type: s.type);
  }

  /// Turns the [Story] into an SQL [map]
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      storyDateCreatedColumn: dateCreated,
      storyDatedLastEditedColumn: dateLastEdited,
      storyDataColumn: data,
      storyTypeColumn: type
    };
    if (id != null) {
      map[storyIdColumn] = id;
    }
    return map;
  }

  /// Turns the [Story] into an SQL [map] with a [memoryId]
  Map<String, dynamic> toMapWithMemoryId(int memoryId) {
    var map = toMap();
    map[memoryIdColumn] = memoryId;
    return map;
  }

  @override
  List<Object> get props => [id, dateCreated, dateLastEdited, data, type];

  @override
  String toString() {
    return "Story $id - created:$dateCreated edited:$dateLastEdited data:$data type:$type";
  }
}
