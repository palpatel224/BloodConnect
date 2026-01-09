class PlacesApiException implements Exception {
  final String message;

  PlacesApiException(this.message);

  @override
  String toString() => message;
}
