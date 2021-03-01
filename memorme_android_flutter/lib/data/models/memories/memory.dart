import 'package:equatable/equatable.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';

const String memoriesTable = "Memories";
const String memoryIdColumn = "memory_id";
const String memoryDateCreatedColumn = "date_created";
const String memoryDateLastEditedColumn = "date_last_edited";
const String memoryStoryPreviewIdColumn = "story_preview_id";

/// A data representation of a memory
class Memory extends Equatable {
  final int id;
  final int dateCreated;
  final int dateLastEdited;
  final int storyPreviewId;
  final List<Story> stories;
  // TODO: add UUID when doing cloud things
  // final String uuid;

  /// takes an [id] for the memory, the [dateCreated], the [dateLastEdited], the [storyPreviewId], and a list of stories
  const Memory(
      {this.id,
      this.dateCreated,
      this.dateLastEdited,
      this.storyPreviewId,
      this.stories});

  /// creates a [Memory] from an SQL [map] with an empty list of [stories]
  factory Memory.fromMap(Map<String, dynamic> map) {
    final int id = map[memoryIdColumn];
    final int dateCreated = map[memoryDateCreatedColumn];
    final int dateLastEdited = map[memoryDateLastEditedColumn];
    final int storyPreviewId = map[memoryStoryPreviewIdColumn];
    final List<Story> stories = [];
    return Memory(
        id: id,
        dateCreated: dateCreated,
        dateLastEdited: dateLastEdited,
        storyPreviewId: storyPreviewId,
        stories: stories);
  }

  /// creates a [Memory] from an SQL [map] and list of [stories]
  factory Memory.fromMapAndList(Map<String, dynamic> map, List<Story> stories) {
    final int id = map[memoryIdColumn];
    final int dateCreated = map[memoryDateCreatedColumn];
    final int dateLastEdited = map[memoryDateLastEditedColumn];
    final int storyPreviewId = map[memoryStoryPreviewIdColumn];
    return Memory(
        id: id,
        dateCreated: dateCreated,
        dateLastEdited: dateLastEdited,
        storyPreviewId: storyPreviewId,
        stories: stories);
  }

  /// Create a new memory from an old memory and some new values
  factory Memory.editMemory(Memory memory,
      {int id,
      int dateCreated,
      int dateLastEdited,
      int storyPreviewId,
      List<Story> stories}) {
    return Memory(
        id: id == null ? memory.id : id,
        dateCreated: dateCreated == null ? memory.dateCreated : dateCreated,
        dateLastEdited:
            dateLastEdited == null ? memory.dateLastEdited : dateLastEdited,
        storyPreviewId:
            storyPreviewId == null ? memory.storyPreviewId : storyPreviewId,
        stories: stories == null ? memory.stories : stories);
  }

  /// gives an SQL [map] from the [Memory]
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      memoryDateCreatedColumn: dateCreated,
      memoryDateLastEditedColumn: dateLastEdited,
      memoryStoryPreviewIdColumn: storyPreviewId,
    };
    if (id != null) {
      map[memoryIdColumn] = id;
    }
    return map;
  }

  @override
  List<Object> get props =>
      [id, dateCreated, dateLastEdited, storyPreviewId, stories];

  @override
  String toString() {
    return "Memory $id - created:$dateCreated edited:$dateLastEdited storyPreviewId:$storyPreviewId stories:$stories";
  }
}
