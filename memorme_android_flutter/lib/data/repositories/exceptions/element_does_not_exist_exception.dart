/// The element does not exist in the storage mechanism
class ElementNotInStorageException implements Exception {
  static const String _message =
      "The element does not exist in the storage mechanism";

  @override
  String toString() {
    return _message;
  }
}
