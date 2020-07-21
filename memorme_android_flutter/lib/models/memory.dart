class Memory {
  final List<String> media;
  final List<String> stories;

  Memory({this.media = const [], this.stories = const []});

  //add a story to the stories list
  addStory(String story) {
    stories.add(story);
  }

  addMedia(String m) {
    media.add(m);
  }

  removeStory(int i) {
    if (stories.length - 1 > i) {
      stories.remove(i);
    }
  }

  removeMedia(int i) {
    if (media.length - 1 > i) {
      media.remove(i);
    }
  }
}
