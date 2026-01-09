import 'package:bloodconnect/health_worker/worker_info/2_application/bloc/health_worker_info_bloc.dart';
import 'package:bloodconnect/health_worker/heatlh_worker_home_screen/2_application/screens/home_page.dart';
import 'package:bloodconnect/core/services/places_service/places_api_service.dart';
import 'package:bloodconnect/core/services/places_service/location_autocomplete_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class HealthWorkerInfo extends StatefulWidget {
  const HealthWorkerInfo({super.key});

  @override
  State<HealthWorkerInfo> createState() => _HealthWorkerInfoState();
}

class _HealthWorkerInfoState extends State<HealthWorkerInfo> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _institutionController = TextEditingController();

  double? _latitude;
  double? _longitude;
  String? _placeId;

  late PlacesApiService _placesService;

  @override
  void initState() {
    super.initState();
    _placesService = GetIt.I<PlacesApiService>();
  }

  Future<void> _getLocationCoordinates(String placeId) async {
    try {
      final coordinates = await _placesService.getPlaceDetails(placeId);
      setState(() {
        _latitude = coordinates['latitude'];
        _longitude = coordinates['longitude'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location coordinates: $e')),
      );
    }
  }

  bool _validateForm() {
    // Validate required fields
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your name')),
      );
      return false;
    }

    if (_professionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your profession')),
      );
      return false;
    }

    if (_locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your workplace location')),
      );
      return false;
    }

    if (_institutionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your institution name')),
      );
      return false;
    }

    // Check if coordinates were obtained
    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please select a location from the suggestions')),
      );
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _professionController.dispose();
    _locationController.dispose();
    _institutionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HealthWorkerInfoBloc, HealthWorkerInfoState>(
      listener: (context, state) {
        if (state is HealthWorkerInfoSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration successful')),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HealthWorkerHomePage()),
            (route) => false,
          );
        } else if (state is HealthWorkerInfoError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to',
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'BLOODCONNECT',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _professionController,
                      decoration: InputDecoration(
                        hintText: 'Profession',
                        prefixIcon: Icon(Icons.work),
                      ),
                    ),
                    SizedBox(height: 16),
                    LocationAutocompleteField(
                      controller: _locationController,
                      hintText: 'Workplace Location',
                      placesService: _placesService,
                      decoration: InputDecoration(
                        hintText: 'Workplace Location',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      onLocationSelected: (place) {
                        _placeId = place.placeId;
                        _getLocationCoordinates(place.placeId);
                      },
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _institutionController,
                      decoration: InputDecoration(
                        hintText: 'Institution Name',
                        prefixIcon: Icon(Icons.business),
                      ),
                    ),
                    SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state is HealthWorkerInfoLoading
                            ? null
                            : () {
                                if (_validateForm()) {
                                  context.read<HealthWorkerInfoBloc>().add(
                                        SubmitHealthWorkerInfo(
                                          name: _nameController.text,
                                          profession:
                                              _professionController.text,
                                          location: _locationController.text,
                                          institution:
                                              _institutionController.text,
                                          latitude: _latitude,
                                          longitude: _longitude,
                                          placeId: _placeId,
                                        ),
                                      );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ).copyWith(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.transparent),
                          overlayColor:
                              WidgetStatePropertyAll(Colors.transparent),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFF2156), Color(0xFFFF4D4D)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: state is HealthWorkerInfoLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
