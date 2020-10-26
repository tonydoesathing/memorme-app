class Memory {
  List<String> _media;
  List<String> _stories;

  Memory({List<String> media, List<String> stories}) {
    if (media == null) {
      _media = [];
    } else {
      _media = media;
    }
    if (stories == null) {
      _stories = [];
    } else {
      _stories = stories;
    }
  }

  ///Adds a [story] to the [_stories] list and returns its index
  int addStory(String story) {
    if (story != null) {
      _stories.add(story);
      return _stories.length - 1;
    }
    return -1;
  }

  ///Edit the story at [index] to be [newStory]
  void editStory(int index, String newStory) {
    if (index != null && newStory != null) {
      if (_stories.length > index && index >= 0) {
        _stories[index] = newStory;
      }
    }
  }

  ///Gets the story at index [i] in [_stories]
  String getStory(int i) {
    if (i != null) {
      if (_stories.length > i && i >= 0) {
        return _stories[i];
      }
    }
  }

  ///Remove the story at index [i] from [_stories]
  removeStory(int i) {
    if (i != null) {
      if (_stories.length > i && i >= 0) {
        _stories.removeAt(i);
      }
    }
  }

  ///Returns the list of [_stories]
  List<String> getAllStories() {
    return this._stories;
  }

  ///Add a media URL [m] to the [_media] list
  int addMedia(String m) {
    if (m != null) {
      _media.add(m);
      return _media.length - 1;
    }
  }

  ///Removes the media URL at index [i] from the [_media] list
  removeMedia(int i) {
    if (i != null) {
      if (_media.length > i && i >= 0) {
        _media.removeAt(i);
      }
    }
  }

  ///Gets the media URL at index [i] in the [_media] list
  String getMedia(int i) {
    if (i != null) {
      if (_media.length > i && i >= 0) {
        return _media[i];
      }
    }
  }

  ///Returns the list of [_media]
  List<String> getAllMedia() {
    return this._media;
  }
}
