import 'package:equatable/equatable.dart';
import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/sql_constants.dart';

/// A [Story] is a piece of media with an [id], [row_type], [dateCreated], [dateLastEdited], [data], and [position]
/// It exists within a [Memory].
class Story extends Equatable {
  final int id;
  final DateTime dateCreated;
  final DateTime dateLastEdited;
  final String data;
  final int type;
  final int position;

  const Story(
      {this.id,
      this.dateCreated,
      this.dateLastEdited,
      this.data,
      this.type,
      this.position});

  /// Creates a [Story] from an SQL [map]
  factory Story.fromMap(Map<String, dynamic> map) {
    final int storyID = map["$row_id"];
    final int dateCreated = map["$date_created"];
    final int dateLastEdited = map["$date_last_edited"];
    final String storyData = map["$row_data"];
    final int storyType = map["$row_type"];
    final int storyPosition = map["$story_position"];

    return Story(
      id: storyID,
      dateCreated: dateCreated != null
          ? DateTime.fromMillisecondsSinceEpoch(dateCreated)
          : null,
      dateLastEdited: dateCreated != null
          ? DateTime.fromMillisecondsSinceEpoch(dateLastEdited)
          : null,
      data: storyData,
      type: storyType,
      position: storyPosition,
    );
  }

  /// edit an existing [story] with optional parameters
  factory Story.editStory(
    Story story, {
    int id,
    DateTime dateCreated,
    DateTime dateLastEdited,
    String storyData,
    int storyType,
    int storyPosition,
  }) {
    return Story(
        id: id ?? story.id,
        dateCreated: dateCreated ?? story.dateCreated,
        dateLastEdited: dateLastEdited ?? story.dateLastEdited,
        data: storyData ?? story.data,
        type: storyType ?? story.type,
        position: storyPosition ?? story.position);
  }

  /// Turns the [Story] and its [parent] into an SQL [map]
  Map<String, dynamic> toMap(Memory parent) {
    var map = <String, dynamic>{
      "$row_id": id,
      "$memory_fk": parent.id,
      "$date_created": dateCreated?.millisecondsSinceEpoch,
      "$date_last_edited": dateLastEdited?.millisecondsSinceEpoch,
      "$row_data": data,
      "$row_type": type,
      "$story_position": position
    };
    return map;
  }

  @override
  List<Object> get props => [
        id,
        dateCreated?.millisecondsSinceEpoch,
        dateLastEdited?.millisecondsSinceEpoch,
        data,
        type,
        position
      ];
}
