/// Unable to remove the element from storage; specifics in optional [message]
class RemoveElementFailureException implements Exception {
  final String message;

  RemoveElementFailureException(
      {this.message = "Could not remove element from storage"});
}
