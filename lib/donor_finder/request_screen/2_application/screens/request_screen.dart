import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widget/blood_type_grid.dart';
import '../widget/units_selector.dart';
import '../widget/urgency_level_selector.dart';
import 'bloc/request_screen_bloc.dart';

import '../../../../core/services/places_service/places_service.dart';
import '../../../../service_locator.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  // Remove the class-level BLoC instance

  String _selectedBloodType = '';
  int _units = 1;
  String _selectedUrgency = 'Medium';
  bool _isEmergency = false;
  bool _agreeToTerms = false;
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _additionalInfoController =
      TextEditingController();

  String? _selectedPlaceId;
  double? _latitude;
  double? _longitude;

  @override
  void dispose() {
    // Remove the BLoC close call
    _patientNameController.dispose();
    _hospitalController.dispose();
    _reasonController.dispose();
    _contactController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  void _onLocationSelected(PlaceModel place) {
    _selectedPlaceId = place.placeId;
    _latitude = place.latitude;
    _longitude = place.longitude;

    if (_latitude == null || _longitude == null) {
      _getPlaceDetails(place.placeId);
    }
  }

  Future<void> _getPlaceDetails(String placeId) async {
    try {
      final placesService = sl<PlacesApiService>();
      final coordinates = await placesService.getPlaceDetails(placeId);

      setState(() {
        _latitude = coordinates['latitude'];
        _longitude = coordinates['longitude'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching location details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Remove the BlocProvider.value and just use BlocConsumer directly
    return BlocConsumer<RequestScreenBloc, RequestScreenState>(
      listener: (context, state) {
        if (state is RequestScreenSuccess) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Request Submitted'),
              content: const Text(
                  'Your blood request has been submitted successfully and is pending approval.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if (state is RequestScreenFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Request Blood',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Patient Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Patient Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _patientNameController,
                        decoration: InputDecoration(
                          hintText: 'Enter patient name',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Blood Type Required',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      BloodTypeGrid(
                        selectedBloodType: _selectedBloodType,
                        onBloodTypeSelected: (type) {
                          setState(() {
                            _selectedBloodType = type;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Units Required',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      UnitsSelector(
                        units: _units,
                        onUnitsChanged: (value) {
                          setState(() {
                            _units = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Request Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Hospital/Location',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LocationAutocompleteField(
                        controller: _hospitalController,
                        hintText: 'Enter hospital or location',
                        onLocationSelected: _onLocationSelected,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Urgency Level',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      UrgencyLevelSelector(
                        selectedUrgency: _selectedUrgency,
                        onUrgencySelected: (urgency) {
                          setState(() {
                            _selectedUrgency = urgency;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Reason for Request',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _reasonController,
                        decoration: InputDecoration(
                          hintText: 'Enter reason for blood request',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Contact Number',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _contactController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Enter contact number',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Additional Information (Optional)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _additionalInfoController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText:
                              'Enter any additional details that might help donors',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Mark as Emergency',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Emergency requests are highlighted and sent as notifications to nearby donors',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _isEmergency,
                              onChanged: (value) {
                                setState(() {
                                  _isEmergency = value;
                                });
                              },
                              activeColor: Colors.red,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _agreeToTerms,
                              onChanged: (value) {
                                setState(() {
                                  _agreeToTerms = value ?? false;
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                text:
                                    'I confirm that this is a genuine request and agree to the ',
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: 'terms and conditions',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed:
                              _agreeToTerms && state is! RequestScreenLoading
                                  ? _submitRequest
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _agreeToTerms
                                ? Colors.red
                                : Colors.grey.shade400,
                            disabledBackgroundColor: Colors.grey.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: state is RequestScreenLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  'Submit Request',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (state is RequestScreenLoading)
                Container(
                  color: Colors.black.withOpacity(0.1),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _submitRequest() {
    if (_selectedBloodType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a blood type')),
      );
      return;
    }

    if (_patientNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter patient name')),
      );
      return;
    }

    if (_hospitalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter hospital/location')),
      );
      return;
    }

    if (_reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter reason for request')),
      );
      return;
    }

    if (_contactController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter contact number')),
      );
      return;
    }

    // Use context.read to access the BLoC from the widget tree
    context.read<RequestScreenBloc>().add(
          RequestScreenSubmitRequested(
            patientName: _patientNameController.text,
            bloodType: _selectedBloodType,
            units: _units,
            hospital: _hospitalController.text,
            urgencyLevel: _selectedUrgency,
            reason: _reasonController.text,
            contactNumber: _contactController.text,
            additionalInfo: _additionalInfoController.text,
            isEmergency: _isEmergency,
            latitude: _latitude,
            longitude: _longitude,
            placeId: _selectedPlaceId,
          ),
        );
  }
}
