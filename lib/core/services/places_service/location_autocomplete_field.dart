import 'dart:async';
import 'package:flutter/material.dart';
import 'places_api_service.dart';
import 'places_models.dart';

class LocationAutocompleteField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final InputDecoration? decoration;
  final Function(PlaceModel) onLocationSelected;
  final PlacesApiService? placesService;
  final Duration debounceTime;

  const LocationAutocompleteField({
    super.key,
    this.controller,
    this.hintText = 'Enter location',
    this.decoration,
    required this.onLocationSelected,
    this.placesService,
    this.debounceTime = const Duration(milliseconds: 500),
  });

  @override
  State<LocationAutocompleteField> createState() =>
      _LocationAutocompleteFieldState();
}

class _LocationAutocompleteFieldState extends State<LocationAutocompleteField> {
  late final TextEditingController _controller;
  late final PlacesApiService _placesService;
  List<PlaceModel> _predictions = [];
  bool _isLoading = false;
  bool _showSuggestions = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _placesService = widget.placesService ?? PlacesApiService();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(widget.debounceTime, () async {
      if (query.isNotEmpty) {
        setState(() {
          _isLoading = true;
          _showSuggestions = true;
        });

        try {
          final predictions = await _placesService.getPlacePredictions(query);
          setState(() {
            _predictions = predictions;
            _isLoading = false;
          });
        } catch (e) {
          setState(() {
            _predictions = [];
            _isLoading = false;
          });
          // You can show an error snackbar here if needed
        }
      } else {
        setState(() {
          _predictions = [];
          _showSuggestions = false;
        });
      }
    });
  }

  void _selectPlace(PlaceModel place) {
    _controller.text = place.description;
    widget.onLocationSelected(place);
    setState(() {
      _showSuggestions = false;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          decoration: widget.decoration ??
              InputDecoration(
                hintText: widget.hintText,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          setState(() {
                            _predictions = [];
                            _showSuggestions = false;
                          });
                        },
                      )
                    : null,
              ),
          onChanged: _onSearchChanged,
          onTap: () {
            if (_controller.text.isNotEmpty) {
              setState(() {
                _showSuggestions = true;
              });
            }
          },
        ),
        if (_showSuggestions)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: _isLoading
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    )
                  : _predictions.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.center,
                          child: Text(
                            'No locations found',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        )
                      : ListView.separated(
                          physics: const ClampingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount:
                              _predictions.length > 5 ? 5 : _predictions.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            color: Colors.grey.shade200,
                          ),
                          itemBuilder: (context, index) {
                            final place = _predictions[index];
                            return ListTile(
                              dense: true,
                              title: Text(place.description),
                              leading: Icon(
                                Icons.location_on_outlined,
                                color: Theme.of(context).primaryColor,
                              ),
                              onTap: () => _selectPlace(place),
                            );
                          },
                        ),
            ),
          ),
      ],
    );
  }
}
