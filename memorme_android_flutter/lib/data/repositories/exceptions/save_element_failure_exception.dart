/// Unable to save the element into storage; specifics in optional [message]
class SaveElementFailureException implements Exception {
  final String message;

  SaveElementFailureException(
      {this.message = "Could not save element into storage"});
}
