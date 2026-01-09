import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'places_models.dart';
import 'places_exceptions.dart';

class PlacesApiService {
  final http.Client _client;
  final String _sessionToken;
  final String _apiKey;

  PlacesApiService({
    http.Client? client,
    String? sessionToken,
    String? apiKey,
  })  : _client = client ?? http.Client(),
        _sessionToken = sessionToken ?? const Uuid().v4(),
        _apiKey = apiKey ?? dotenv.env['GOOGLE_MAPS_KEY'] ?? '';

  /// Get place predictions from Google Places API
  Future<List<PlaceModel>> getPlacePredictions(String input) async {
    if (input.isEmpty || _apiKey.isEmpty) {
      return [];
    }

    try {
      final url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$_apiKey&sessiontoken=$_sessionToken';

      final response = await _client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        debugPrint("Places API response received");
        return PlaceModel.parsePredictions(json);
      } else {
        debugPrint("Places API error: ${response.statusCode}");
        throw PlacesApiException(
            'Failed to load place predictions: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Places API exception: $e");
      if (e is PlacesApiException) {
        rethrow;
      }
      throw PlacesApiException(e.toString());
    }
  }

  /// Get place details from Google Places API
  Future<Map<String, double>> getPlaceDetails(String placeId) async {
    if (placeId.isEmpty || _apiKey.isEmpty) {
      throw PlacesApiException('Place ID or API key is empty');
    }

    try {
      final url =
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_apiKey&sessiontoken=$_sessionToken&fields=geometry';

      final response = await _client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] == 'OK') {
          final location = json['result']['geometry']['location'];
          return {
            'latitude': location['lat'] as double,
            'longitude': location['lng'] as double,
          };
        } else {
          throw PlacesApiException(
              'Failed to get place details: ${json['status']}');
        }
      } else {
        throw PlacesApiException(
            'Failed to load place details: ${response.statusCode}');
      }
    } catch (e) {
      if (e is PlacesApiException) {
        rethrow;
      }
      throw PlacesApiException(e.toString());
    }
  }
}
