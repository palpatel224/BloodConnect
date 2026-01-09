// ignore_for_file: use_build_context_synchronously
// Replaced old Place import with centralized Places service
import 'package:bloodconnect/core/services/places_service/places_service.dart';
import 'package:bloodconnect/donor_finder/donor_info/2_application/screens/bloc/donor_info_bloc.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/2_application/screens/health_questionnaire_screen.dart';
import 'package:bloodconnect/donor_finder/health_questionnaire/2_application/screens/bloc/health_questionnaire_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloodconnect/service_locator.dart' as di;

class DonorInformationScreen extends StatefulWidget {
  const DonorInformationScreen({super.key});

  @override
  State<DonorInformationScreen> createState() => _DonorInformationScreenState();
}

class _DonorInformationScreenState extends State<DonorInformationScreen>
    with AutomaticKeepAliveClientMixin {
  // Controllers
  TextEditingController locationController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  // Focus nodes
  final FocusNode _locationFocusNode = FocusNode();

  // Flag to track if user is actively selecting a location
  bool _isSelectingLocation = false;

  @override
  bool get wantKeepAlive => true; // Keep this widget alive when navigating

  @override
  void initState() {
    super.initState();
    // Initialize with current user data if available
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<DonorInfoBloc>().add(DonorInfoInitializeRequest(user.uid));
    }

    // Listen to changes in location text field to trigger search
    locationController.addListener(_onLocationChanged);

    // Setup focus listener to show/hide predictions
    _locationFocusNode.addListener(() {
      if (_locationFocusNode.hasFocus) {
        setState(() {
          _isSelectingLocation = true;
        });
      }
    });
  }

  void _onLocationChanged() {
    if (_isSelectingLocation) {
      final query = locationController.text;
      context.read<DonorInfoBloc>().add(DonorInfoLocationSearched(query));
    }
  }

  @override
  void dispose() {
    // Clean up controllers and focus nodes
    locationController.removeListener(_onLocationChanged);
    locationController.dispose();
    phoneController.dispose();
    _locationFocusNode.dispose();
    super.dispose();
  }

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now()
          .subtract(const Duration(days: 365 * 18)), // Default to 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      context.read<DonorInfoBloc>().add(DonorInfoDateOfBirthChanged(picked));
    }
  }

  // Updated to use PlaceModel instead of Place
  void _selectPlace(PlaceModel place) {
    setState(() {
      _isSelectingLocation = false;
    });
    context.read<DonorInfoBloc>().add(
          DonorInfoLocationSelected(place.placeId, place.description),
        );
    _locationFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Donor Information',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.error),
      ),
      body: BlocConsumer<DonorInfoBloc, DonorInfoState>(
        listener: (context, state) {
          // Show snackbar for errors
          if (state is DonorInfoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }

          // Show submission status
          if (state is DonorInfoSubmissionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }

          // Navigate on success
          if (state is DonorInfoSubmissionSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (_) => di.sl<HealthQuestionnaireBloc>(),
                  child: const HealthQuestionnaireScreen(),
                ),
              ),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          // Update controllers when state changes
          if (state is DonorInfoLoaded) {
            if (state.location != null &&
                locationController.text != state.location) {
              locationController.text = state.location!;
            }
            if (state.phoneNumber != null &&
                phoneController.text != state.phoneNumber) {
              phoneController.text = state.phoneNumber!;
            }
          }

          return Container(
            color: Colors.white,
            child: SafeArea(
              child: GestureDetector(
                onTap: () {
                  if (_isSelectingLocation) {
                    setState(() {
                      _isSelectingLocation = false;
                    });
                    _locationFocusNode.unfocus();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Blood group field
                        Text(
                          'Blood group',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: state is DonorInfoLoaded
                                ? state.bloodGroup
                                : null,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              border: InputBorder.none,
                            ),
                            hint: Text('Select'),
                            isExpanded: true,
                            icon: Icon(Icons.keyboard_arrow_down),
                            items: [
                              'A+',
                              'A-',
                              'B+',
                              'B-',
                              'AB+',
                              'AB-',
                              'O+',
                              'O-'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                context.read<DonorInfoBloc>().add(
                                      DonorInfoBloodGroupChanged(value),
                                    );
                              }
                            },
                          ),
                        ),

                        SizedBox(height: 24),

                        // Date of Birth field
                        Text(
                          'Date of Birth',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              border: InputBorder.none,
                              hintText: (state is DonorInfoLoaded &&
                                      state.dateOfBirth != null)
                                  ? '${state.dateOfBirth!.day}/${state.dateOfBirth!.month}/${state.dateOfBirth!.year}'
                                  : 'Select date',
                              suffixIcon: Icon(
                                Icons.calendar_today,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                            readOnly: true,
                            onTap: () => _selectDate(context),
                          ),
                        ),

                        SizedBox(height: 24),

                        // Gender field
                        Text(
                          'Gender',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonFormField<String>(
                            value:
                                state is DonorInfoLoaded ? state.gender : null,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              border: InputBorder.none,
                            ),
                            hint: Text('Select'),
                            isExpanded: true,
                            icon: Icon(Icons.keyboard_arrow_down),
                            items:
                                ['Male', 'Female', 'Other'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                context.read<DonorInfoBloc>().add(
                                      DonorInfoGenderChanged(value),
                                    );
                              }
                            },
                          ),
                        ),

                        SizedBox(height: 24),

                        // Location field with Places Autocomplete
                        Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: TextField(
                                controller: locationController,
                                focusNode: _locationFocusNode,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  border: InputBorder.none,
                                  hintText: 'Enter your address',
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (state is DonorInfoLoaded &&
                                          state.isSearching)
                                        Container(
                                          width: 20,
                                          height: 20,
                                          margin: EdgeInsets.only(right: 8),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                          ),
                                        ),
                                      Icon(
                                        Icons.location_on,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                    ],
                                  ),
                                ),
                                onChanged: (value) {
                                  context.read<DonorInfoBloc>().add(
                                        DonorInfoLocationChanged(value),
                                      );
                                },
                                onTap: () {
                                  setState(() {
                                    _isSelectingLocation = true;
                                  });
                                },
                              ),
                            ),

                            // Display location coordinates if available
                            if (state is DonorInfoLoaded &&
                                state.latitude != null &&
                                state.longitude != null)
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4.0, left: 8.0),
                                child: Text(
                                  'Coordinates: ${state.latitude!.toStringAsFixed(4)}, ${state.longitude!.toStringAsFixed(4)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),

                            // Place predictions dropdown - now inline in the scroll view
                            if (_isSelectingLocation &&
                                state is DonorInfoLoaded &&
                                state.locationPredictions.isNotEmpty)
                              Container(
                                margin: EdgeInsets.only(top: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                constraints: BoxConstraints(
                                  maxHeight: 200,
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: state.locationPredictions.length,
                                  itemBuilder: (context, index) {
                                    final place =
                                        state.locationPredictions[index];
                                    return ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      leading: Icon(
                                        Icons.location_on_outlined,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                      title: Text(
                                        place.description,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      onTap: () => _selectPlace(place),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),

                        SizedBox(height: 24),

                        // Phone number field
                        Text(
                          'Phone number',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              context.read<DonorInfoBloc>().add(
                                    DonorInfoPhoneChanged(value),
                                  );
                            },
                          ),
                        ),

                        SizedBox(height: 32),

                        // Done button
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: state is DonorInfoSubmissionInProgress
                                  ? null // Disable button during submission
                                  : () {
                                      context.read<DonorInfoBloc>().add(
                                            DonorInfoSubmitted(),
                                          );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ).copyWith(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.transparent),
                                overlayColor:
                                    WidgetStatePropertyAll(Colors.transparent),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient:
                                      state is DonorInfoSubmissionInProgress
                                          ? LinearGradient(
                                              colors: [
                                                Colors.grey,
                                                Colors.grey.shade600
                                              ],
                                            )
                                          : LinearGradient(
                                              colors: [
                                                Color(0xFFFF2156),
                                                Color(0xFFFF4D4D)
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: state is DonorInfoSubmissionInProgress
                                      ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          'DONE',
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
                        ),

                        // Add extra space at the bottom for better scrolling
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
