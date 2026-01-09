import 'package:bloodconnect/health_worker/donation_appointments/2_application/bloc/appointment_list_bloc.dart';
import 'package:bloodconnect/health_worker/donation_appointments/2_application/bloc/appointment_list_event.dart';
import 'package:bloodconnect/health_worker/donation_appointments/2_application/bloc/appointment_list_state.dart';
import 'package:bloodconnect/health_worker/donation_appointments/2_application/widgets/appointment_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloodconnect/core/services/places_service/places_service.dart';
import 'package:bloodconnect/service_locator.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  final TextEditingController _locationController = TextEditingController();
  final GlobalKey _locationFieldKey = GlobalKey();
  double _searchRadius = 10.0;
  String? _selectedStatusFilter;

  // Places autocomplete
  late PlacesApiService _placesService;
  List<PlaceModel> _placePredictions = [];
  bool _isLoadingPlaces = false;
  OverlayEntry? _overlayEntry;

  // Selected place information
  String? _selectedPlaceId;

  @override
  void initState() {
    super.initState();
    context.read<AppointmentListBloc>().add(const FetchAppointments());

    // Use the centralized Places API service from service locator
    _placesService = sl<PlacesApiService>();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
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
                  onTap: () {
                    _locationController.text = place.description;
                    _selectedPlaceId = place.placeId;
                    _overlayEntry?.remove();
                    _overlayEntry = null;
                    context.read<AppointmentListBloc>().add(
                          LocationChanged(
                            location: place.description,
                            placeId: place.placeId,
                          ),
                        );
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

  void _searchPlaces(String input) async {
    if (input.isEmpty) {
      _placePredictions = [];
      _overlayEntry?.remove();
      _overlayEntry = null;
      return;
    }

    setState(() {
      _isLoadingPlaces = true;
    });

    try {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching places: $e')),
      );
    }
  }

  void _performLocationSearch() {
    if (_locationController.text.isEmpty || _selectedPlaceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a location from the suggestions')),
      );
      return;
    }

    context.read<AppointmentListBloc>().add(
          SearchAppointmentsByLocation(
            location: _locationController.text,
            placeId: _selectedPlaceId!,
            radius: _searchRadius,
          ),
        );
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
                      'Filter Appointments by Distance',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
                          color: const Color(0xFFD32F2F),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _searchRadius,
                    min: 1,
                    max: 20,
                    divisions: 10,
                    activeColor: const Color(0xFFD32F2F),
                    inactiveColor: const Color(0xFFFEE8E8),
                    label: '${_searchRadius.toInt()} km',
                    onChanged: (value) {
                      setState(() {
                        _searchRadius = value;
                      });
                      context
                          .read<AppointmentListBloc>()
                          .add(RadiusChanged(_searchRadius));
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _performLocationSearch();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFD32F2F),
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

  void _applyStatusFilter(String? status) {
    setState(() {
      _selectedStatusFilter = status == _selectedStatusFilter ? null : status;
    });

    context.read<AppointmentListBloc>().add(
          FilterAppointmentsByStatus(status: _selectedStatusFilter),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32F2F),
        foregroundColor: Colors.white,
        title: const Text(
          'Donation Appointments',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context
                  .read<AppointmentListBloc>()
                  .add(const FetchAppointments());
              setState(() {
                _selectedStatusFilter = null;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildLocationSearchBar(),
          _buildStatusFilterPills(),
          Expanded(
            child: BlocBuilder<AppointmentListBloc, AppointmentListState>(
              builder: (context, state) {
                if (state is AppointmentListInitial) {
                  return const Center(
                      child: Text('No appointments loaded yet'));
                } else if (state is AppointmentListLoading) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Color(0xFFD32F2F),
                  ));
                } else if (state is AppointmentListLoaded) {
                  final appointments = state.appointments;

                  if (appointments.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.event_busy,
                            size: 80,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.isLocationSearch
                                ? 'No appointments found within ${state.radius.toInt()} km of ${state.location}'
                                : _selectedStatusFilter != null
                                    ? 'No $_selectedStatusFilter appointments available'
                                    : 'No appointments available',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      return AppointmentCard(
                        appointment: appointments[index],
                      );
                    },
                  );
                } else if (state is AppointmentListError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Color(0xFFD32F2F),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.message}',
                          style: const TextStyle(color: Color(0xFFD32F2F)),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<AppointmentListBloc>()
                                .add(const FetchAppointments());
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilterPills() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          const Text(
            'Filter by: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          _buildFilterPill('Pending', const Color(0xFFFF9800)),
          const SizedBox(width: 8),
          _buildFilterPill('Completed', const Color(0xFF4CAF50)),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String status, Color color) {
    final isSelected = _selectedStatusFilter == status;

    return GestureDetector(
      onTap: () => _applyStatusFilter(status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color,
            width: 1,
          ),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                key: _locationFieldKey,
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: 'Search by location...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: const Color(0xFFD32F2F),
                  ),
                  suffixIcon: _isLoadingPlaces
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFD32F2F),
                            ),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _locationController.clear();
                            _selectedPlaceId = null;
                            _overlayEntry?.remove();
                            _overlayEntry = null;
                          },
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFD32F2F)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: _searchPlaces,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
