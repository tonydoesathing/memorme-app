import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:memorme_android_flutter/data/models/stories/story_type.dart';
import 'package:memorme_android_flutter/data/repositories/collection_repository.dart';
import 'package:memorme_android_flutter/data/repositories/collection_repository_event.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository.dart';
import 'package:memorme_android_flutter/data/repositories/memory_repository_event.dart';

class AnalyticsProvider {
  static final AnalyticsProvider _singleton = AnalyticsProvider._internal();

  AnalyticsProvider._internal();

  factory AnalyticsProvider() {
    return _singleton;
  }

  final FirebaseAnalytics analytics = FirebaseAnalytics();

  bool _listening = false;
  void registerRepositoryEvents(CollectionRepository collectionRepository,
      MemoryRepository memoryRepository) {
    if (!_listening) {
      _listening = true;
      collectionRepository.repositoryEventStream.listen((event) {
        if (event is CollectionRepositoryAddCollection) {
          AnalyticsProvider().analytics.logEvent(
            name: "collection_added",
            parameters: {
              "number_of_memories": event.mcRelations.length,
              "had_title": !(event.addedCollection.title == null ||
                  event.addedCollection.title.length == 0)
            },
          );
        } else if (event is CollectionRepositoryUpdateCollection) {
          AnalyticsProvider().analytics.logEvent(
            name: "collection_edited",
            parameters: {
              "number_of_memories": event.mcRelations.length,
              "had_title": !(event.updatedCollection.title == null ||
                  event.updatedCollection.title.length == 0)
            },
          );
        } else if (event is CollectionRepositoryRemoveCollection) {
          AnalyticsProvider().analytics.logEvent(
            name: "collection_removed",
            parameters: {
              "had_title": !(event.removedCollection.title == null ||
                  event.removedCollection.title.length == 0)
            },
          );
        }
      });
      memoryRepository.repositoryEventStream.listen((event) {
        if (event is MemoryRepositoryAddMemory) {
          int numPictureStories = 0;
          event.addedMemory.stories.forEach((element) {
            if (element.type == StoryType.PICTURE_STORY) {
              numPictureStories++;
            }
          });
          int numTextStories = 0;
          event.addedMemory.stories.forEach((element) {
            if (element.type == StoryType.TEXT_STORY) {
              numTextStories++;
            }
          });
          AnalyticsProvider().analytics.logEvent(
            name: "memory_added",
            parameters: {
              "number_of_picture_stories": numPictureStories,
              "number_of_text_stories": numTextStories,
              "had_title": !(event.addedMemory.title == null ||
                  event.addedMemory.title.length == 0)
            },
          );
        } else if (event is MemoryRepositoryUpdateMemory) {
          int numPictureStories = 0;
          event.updatedMemory.stories.forEach((element) {
            if (element.type == StoryType.PICTURE_STORY) {
              numPictureStories++;
            }
          });
          int numTextStories = 0;
          event.updatedMemory.stories.forEach((element) {
            if (element.type == StoryType.TEXT_STORY) {
              numTextStories++;
            }
          });
          AnalyticsProvider().analytics.logEvent(
            name: "memory_updated",
            parameters: {
              "number_of_picture_stories": numPictureStories,
              "number_of_text_stories": numTextStories,
              "time_since_creation": DateTime.now()
                  .difference(event.updatedMemory.dateCreated)
                  .inMilliseconds,
              "had_title": !(event.updatedMemory.title == null ||
                  event.updatedMemory.title.length == 0)
            },
          );
        } else if (event is MemoryRepositoryRemoveMemory) {
          int numPictureStories = 0;
          event.removedMemory.stories.forEach((element) {
            if (element.type == StoryType.PICTURE_STORY) {
              numPictureStories++;
            }
          });
          int numTextStories = 0;
          event.removedMemory.stories.forEach((element) {
            if (element.type == StoryType.TEXT_STORY) {
              numTextStories++;
            }
          });
          AnalyticsProvider().analytics.logEvent(
            name: "memory_removed",
            parameters: {
              "number_of_picture_stories": numPictureStories,
              "number_of_text_stories": numTextStories,
              "time_alive": DateTime.now()
                  .difference(event.removedMemory.dateCreated)
                  .inMilliseconds,
              "had_title": !(event.removedMemory.title == null ||
                  event.removedMemory.title.length == 0)
            },
          );
        }
      });
    }
  }
}
