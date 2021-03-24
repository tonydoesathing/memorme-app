class SearchResult {
  final Object object;
  final int points;

  SearchResult(this.object, this.points);

  factory SearchResult.copyWith(SearchResult searchResult,
      {Object object, int points}) {
    return SearchResult(
        object ?? searchResult.object, points ?? searchResult.points);
  }

  @override
  String toString() {
    return "Object: $object \n Points: $points \n";
  }
}
