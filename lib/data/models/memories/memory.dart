import 'package:equatable/equatable.dart';
import 'package:memorme_android_flutter/data/models/sql_constants.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';

/// A [Memory] is an organized collection of [Story]s with a [title], [dateCreated], [dateLastEdited], [id], [previewStory], and [createLocation]
class Memory extends Equatable {
  final int id;
  final String title;
  final Story previewStory;
  final DateTime dateCreated;
  final DateTime dateLastEdited;
  final int createLocation;
  final List<Story> stories;

  /// Create a memory from optional parameters; please provide an empty array for stories otheriwse shit breaks
  ///
  /// Don't provide a [previewStory] if there aren't any [stories]; there isn't a catch for this;
  /// It will just end up as null
  const Memory(
      {this.id,
      this.title,
      this.previewStory,
      this.dateCreated,
      this.dateLastEdited,
      this.createLocation,
      this.stories});

  /// edit an existing [memory] with optional parameters
  /// this is here because we shouldn't be editing final stuff
  factory Memory.editMemory(Memory memory,
      {int id,
      String title,
      Story previewStory,
      DateTime dateLastEdited,
      DateTime dateCreated,
      int createLocation,
      List<Story> stories}) {
    return Memory(
        id: id ?? memory.id,
        title: title ?? memory.title,
        previewStory: previewStory ?? memory.previewStory,
        dateCreated: dateCreated ?? memory.dateCreated,
        dateLastEdited: dateLastEdited ?? memory.dateLastEdited,
        createLocation: createLocation ?? memory.createLocation,
        stories: stories ?? memory.stories);
  }

  /// creates a [Memory] from an SQL [map] and list of stories
  factory Memory.fromMap(Map<String, dynamic> map, List<Story> stories) {
    final int memoryID = map["$row_id"];
    final String memoryTitle = map["$row_title"];
    final int previewStoryID = map["$preview_story_id"];
    final int dateCreated = map["$date_created"];
    final int dateLastEdited = map["$date_last_edited"];
    final int memoryCreateLocation = map["$location"];

    return Memory(
        id: memoryID,
        title: memoryTitle,
        previewStory: stories?.firstWhere((story) => story.id == previewStoryID,
            orElse: () =>
                null), // returns null when can't find story in the list
        dateCreated: dateCreated != null
            ? DateTime.fromMillisecondsSinceEpoch(dateCreated)
            : null,
        dateLastEdited: dateLastEdited != null
            ? DateTime.fromMillisecondsSinceEpoch(dateLastEdited)
            : null,
        createLocation: memoryCreateLocation,
        stories: stories);
  }

  /// gives an SQL [map] representation of the [Memory]
  /// Note: does not include stories
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "$row_id": id ?? null,
      "$row_title": title ?? null,
      "$preview_story_id": previewStory?.id,
      "$date_created": dateCreated?.millisecondsSinceEpoch,
      "$date_last_edited": dateLastEdited?.millisecondsSinceEpoch,
      "$location": createLocation ?? null
    };
    return map;
  }

  @override
  List<Object> get props => [
        id,
        title,
        previewStory,
        dateCreated?.millisecondsSinceEpoch,
        dateLastEdited?.millisecondsSinceEpoch,
        createLocation,
        stories
      ];
  @override
  String toString() {
    return "Memory $id: \n title: $title,\n previewStory: $previewStory,\n dateCreated: $dateCreated,\n dateLastEdited: $dateLastEdited,\n createLocation: $createLocation,\n stories:$stories";
  }
}
