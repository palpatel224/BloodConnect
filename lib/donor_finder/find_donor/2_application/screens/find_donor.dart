
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/request_card.dart';
import 'bloc/find_request_bloc.dart';
import '../../../../core/services/places_service/places_service.dart';
import '../../../../service_locator.dart';

class FindDonor extends StatefulWidget {
  const FindDonor({super.key});

  @override
  State<FindDonor> createState() => _FindDonorState();
}

class _FindDonorState extends State<FindDonor> {
  final TextEditingController _locationController = TextEditingController();
  final GlobalKey _locationFieldKey = GlobalKey();
  String _selectedBloodGroup = 'All';
  double _searchRadius = 10.0;
  final List<String> _bloodGroups = [
    'All',
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  final ScrollController _scrollController = ScrollController();

  // Form validation state
  bool _locationError = false;

  // Selected place information
  String? _selectedPlaceId;

  // Places autocomplete
  late PlacesApiService _placesService;
  List<PlaceModel> _placePredictions = [];
  bool _isLoadingPlaces = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    context.read<FindRequestBloc>().add(LoadRequests());

    // Use the centralized Places API service from service locator
    _placesService = sl<PlacesApiService>();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Filter Blood Requests',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Blood Group',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedBloodGroup,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: _bloodGroups.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedBloodGroup = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text(
                        'Distance',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${_searchRadius.toInt()} km',
                        style: TextStyle(
                          color: Colors.red[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _searchRadius,
                    min: 0,
                    max: 20,
                    divisions: 10,
                    activeColor: Colors.red[600],
                    inactiveColor: Colors.red[200],
                    label: '${_searchRadius.toInt()} km',
                    onChanged: (value) {
                      setState(() {
                        _searchRadius = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _performSearch();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        child: Text('Apply Filters'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _performSearch() {
    setState(() {
      _locationError = _locationController.text.isEmpty;
    });

    if (!_locationError) {
      context.read<FindRequestBloc>().add(
            SearchRequests(
              bloodGroup:
                  _selectedBloodGroup == 'All' ? '' : _selectedBloodGroup,
              location: _locationController.text,
              placeId: _selectedPlaceId ?? '',
              radius: _searchRadius,
            ),
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a location'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showPlaceSuggestions(List<PlaceModel> predictions) {
    _overlayEntry?.remove();
    _overlayEntry = null;

    if (predictions.isEmpty) return;

    final RenderBox? textFieldRenderBox =
        _locationFieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (textFieldRenderBox == null) return;

    final size = textFieldRenderBox.size;
    final offset = textFieldRenderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5,
        width: size.width,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.3,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: predictions.length,
              itemBuilder: (context, index) {
                final place = predictions[index];
                return ListTile(
                  title: Text(place.description),
                  subtitle: Text(place.placeId),
                  onTap: () {
                    _locationController.text = place.description;
                    _selectedPlaceId = place.placeId;
                    _overlayEntry?.remove();
                    _overlayEntry = null;
                    setState(() {
                      _placePredictions = [];
                      _locationError = false;
                    });
                    context
                        .read<FindRequestBloc>()
                        .add(LocationChanged(place.description, place.placeId));
                  },
                );
              },
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Future<void> _searchPlaces(String input) async {
    if (input.isEmpty) {
      setState(() {
        _placePredictions = [];
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
      return;
    }

    setState(() {
      _isLoadingPlaces = true;
    });

    try {
      // Use the centralized places service directly
      final predictions = await _placesService.getPlacePredictions(input);
      setState(() {
        _placePredictions = predictions;
        _isLoadingPlaces = false;
      });
      _showPlaceSuggestions(predictions);
    } catch (e) {
      setState(() {
        _isLoadingPlaces = false;
      });
      debugPrint('Error searching places: $e');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _locationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FindRequestBloc, FindRequestState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.red[600],
            title: const Text(
              'Blood Requests',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        key: _locationFieldKey,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _locationError
                                ? Colors.red
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: TextField(
                          controller: _locationController,
                          decoration: InputDecoration(
                            hintText: 'Enter hospital name',
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Colors.red[600],
                              ),
                              onPressed: _performSearch,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _locationError = value.isEmpty;
                              if (value.isEmpty) {
                                _selectedPlaceId = null;
                              }
                            });
                            _searchPlaces(value);
                            context
                                .read<FindRequestBloc>()
                                .add(LocationChanged(value, null));
                          },
                          onSubmitted: (_) => _performSearch(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      elevation: 1,
                      child: InkWell(
                        onTap: _showFilterBottomSheet,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.filter_list,
                            color: Colors.red[600],
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state is FindRequestLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is FindRequestError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (state is FindRequestLoaded) {
                      if (state.requests.isEmpty) {
                        return const Center(
                          child: Text('No blood requests found'),
                        );
                      } else {
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: state.requests.length,
                          itemBuilder: (context, index) {
                            final request = state.requests[index];

                            // Calculate mock distance based on index
                            String mockDistance = "${((index + 1) * 3)} km";

                            // Add mock timePosted only for odd indexes to simulate variety
                            String? timePosted =
                                index % 2 == 1 ? "${index + 1} days ago" : null;

                            return RequestCard(
                              patientName: request.patientName,
                              bloodType: request.bloodType,
                              units: request.units,
                              hospital: request.hospital,
                              requestStatus: request.requestStatus,
                              reason: request.reason,
                              distance: mockDistance,
                              timePosted: timePosted,
                              urgencyLevel: request.urgencyLevel,
                              contactNumber: request.contactNumber,
                              onSharePressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Sharing ${request.patientName}')),
                                );
                              },
                              onApplyPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Applying for ${request.patientName}')),
                                );
                              },
                            );
                          },
                        );
                      }
                    } else {
                      return const Center(
                        child: Text('Search for blood requests'),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
