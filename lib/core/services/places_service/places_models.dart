class PlaceModel {
  final String placeId;
  final String description;
  final double? latitude;
  final double? longitude;

  const PlaceModel({
    required this.placeId,
    required this.description,
    this.latitude,
    this.longitude,
  });

  // Factory method for creating from autocomplete prediction JSON
  factory PlaceModel.fromPredictionJson(Map<String, dynamic> json) {
    return PlaceModel(
      placeId: json['place_id'] as String,
      description: json['description'] as String,
    );
  }

  // Factory method for creating from place details JSON
  factory PlaceModel.fromPlaceDetailsJson(Map<String, dynamic> json) {
    final location = json['geometry']['location'];
    return PlaceModel(
      placeId: json['place_id'] as String,
      description: json['formatted_address'] as String,
      latitude: location['lat'] as double,
      longitude: location['lng'] as double,
    );
  }

  // Parse a list of autocomplete predictions
  static List<PlaceModel> parsePredictions(Map<String, dynamic> json) {
    final predictions = json['predictions'] as List;
    return predictions
        .map((prediction) => PlaceModel.fromPredictionJson(prediction))
        .toList();
  }

  // Parse place details response
  static PlaceModel parsePlaceDetails(Map<String, dynamic> json) {
    final result = json['result'];
    return PlaceModel.fromPlaceDetailsJson(result);
  }

  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
