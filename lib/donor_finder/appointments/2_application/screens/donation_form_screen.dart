import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:bloodconnect/service_locator.dart';
import 'package:bloodconnect/donor_finder/appointments/2_application/screens/bloc/appointments_bloc.dart';
import 'package:bloodconnect/core/services/places_service/places_models.dart';
import 'package:bloodconnect/core/services/places_service/places_api_service.dart';
import 'dart:async';

class DonationFormScreen extends StatefulWidget {
  const DonationFormScreen({super.key});

  @override
  _DonationFormScreenState createState() => _DonationFormScreenState();
}

class _DonationFormScreenState extends State<DonationFormScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  final TextEditingController _donorIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Selected values
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  double _latitude = 0.0;
  double _longitude = 0.0;
  String? _selectedHospitalId;

  // Blood types
  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  // AppointmentBloc
  late final AppointmentsBloc _appointmentsBloc;
  bool _isSubmitting = false;

  // Places autocomplete
  late PlacesApiService _placesService;

  @override
  void initState() {
    super.initState();
    _appointmentsBloc = sl<AppointmentsBloc>();
    _placesService = sl<PlacesApiService>();
  }

  // Show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE60000),
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Show time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE60000),
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Format date for display
  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  // Format time for display
  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('h:mm a').format(dt);
  }

  // Get location coordinates for a place
  Future<void> _getPlaceCoordinates(String placeId) async {
    try {
      final coordinates = await _placesService.getPlaceDetails(placeId);
      setState(() {
        _latitude = coordinates['latitude'] ?? 0.0;
        _longitude = coordinates['longitude'] ?? 0.0;
      });
    } catch (e) {
      debugPrint('Error getting place coordinates: $e');
      // Show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location coordinates: $e')),
      );
    }
  }

  // Submit form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null ||
          _selectedTime == null ||
          _hospitalController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all required fields')),
        );
        return;
      }

      // Check if we have coordinates
      if (_latitude == 0.0 && _longitude == 0.0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Hospital location coordinates are missing. Please select a hospital from the suggestions.')),
        );
        return;
      }

      _appointmentsBloc.add(CreateAppointmentEvent(
        donorId: _donorIdController.text,
        name: _nameController.text,
        bloodType: _bloodTypeController.text,
        phoneNumber: _phoneController.text,
        appointmentDate: _selectedDate!,
        appointmentTime: _selectedTime!,
        hospital: _hospitalController.text,
        notes: _notesController.text,
        latitude: _latitude,
        longitude: _longitude,
      ));

      setState(() {
        _isSubmitting = true;
      });
    }
  }

  @override
  void dispose() {
    _donorIdController.dispose();
    _nameController.dispose();
    _bloodTypeController.dispose();
    _phoneController.dispose();
    _hospitalController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hint,
    bool required = true,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    bool readOnly = false,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              if (required)
                const Text(
                  ' *',
                  style: TextStyle(
                    color: Color(0xFFE60000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              filled: true,
              fillColor: Colors.grey[50],
              suffixIcon: suffixIcon,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xFFE60000), width: 1),
              ),
            ),
            keyboardType: keyboardType,
            maxLines: maxLines,
            validator: validator ??
                (value) {
                  if (required && (value == null || value.isEmpty)) {
                    return 'This field is required';
                  }
                  return null;
                },
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimePicker() {
    return Row(
      children: [
        // Date Picker
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Text(
                      ' *',
                      style: TextStyle(
                        color: Color(0xFFE60000),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          _selectedDate != null
                              ? _formatDate(_selectedDate!)
                              : 'Select Date',
                          style: TextStyle(
                            color: _selectedDate != null
                                ? const Color(0xFF333333)
                                : Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Time Picker
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      'Time',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Text(
                      ' *',
                      style: TextStyle(
                        color: Color(0xFFE60000),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _selectTime(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          _selectedTime != null
                              ? _formatTime(_selectedTime!)
                              : 'Select Time',
                          style: TextStyle(
                            color: _selectedTime != null
                                ? const Color(0xFF333333)
                                : Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBloodTypeDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                'Blood Type',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              Text(
                ' *',
                style: TextStyle(
                  color: Color(0xFFE60000),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _bloodTypeController.text.isEmpty
                    ? null
                    : _bloodTypeController.text,
                icon: const Icon(Icons.arrow_drop_down),
                isExpanded: true,
                hint: const Text('Select Blood Type'),
                style: const TextStyle(color: Color(0xFF333333), fontSize: 14),
                items:
                    _bloodTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _bloodTypeController.text = newValue;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _appointmentsBloc,
      child: BlocListener<AppointmentsBloc, AppointmentsState>(
        listener: (context, state) {
          if (state is AppointmentCreated) {
            setState(() {
              _isSubmitting = false;
            });
            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            // Show success dialog and navigate back
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Appointment Scheduled'),
                content: const Text(
                    'Your blood donation appointment has been scheduled successfully. You will receive a confirmation shortly.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFE60000)),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else if (state is AppointmentCreationFailed) {
            setState(() {
              _isSubmitting = false;
            });
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AppointmentsLoading) {
            setState(() {
              _isSubmitting = true;
            });
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Scheduling your appointment...'),
                duration: Duration(days: 365), // Keep it visible
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          body: SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                  color: Colors.white,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Color(0xFF333333)),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Text(
                          'Schedule Blood Donation',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Form
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        // Form title
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline,
                                  color: Colors.red[700], size: 24),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Please complete the form below to schedule your blood donation appointment.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFB71C1C),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Personal Information section
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildInputField(
                          label: 'Donor ID',
                          controller: _donorIdController,
                          hint: 'Enter your donor ID if you have one',
                          required: false,
                        ),
                        _buildInputField(
                          label: 'Full Name',
                          controller: _nameController,
                          hint: 'Enter your full name',
                        ),
                        _buildBloodTypeDropdown(),
                        _buildInputField(
                          label: 'Phone Number',
                          controller: _phoneController,
                          hint: 'Enter your phone number',
                          keyboardType: TextInputType.phone,
                        ),

                        const SizedBox(height: 10),

                        // Appointment Details section
                        const Text(
                          'Appointment Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildDateTimePicker(),

                        // Use Places Autocomplete Widget for Hospital
                        PlacesAutocompleteWidget(
                          label: 'Hospital',
                          controller: _hospitalController,
                          placeholder: 'Search for hospital or blood bank',
                          icon: Icons.local_hospital,
                          isHospital: true,
                          onPlaceSelected: (placeId, lat, lng) {
                            setState(() {
                              _selectedHospitalId = placeId;
                              _latitude = lat;
                              _longitude = lng;
                            });
                          },
                        ),

                        _buildInputField(
                          label: 'Additional Notes',
                          controller: _notesController,
                          hint:
                              'Any medical conditions or special requirements?',
                          required: false,
                          maxLines: 3,
                        ),

                        // Health Declaration section
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Health Declaration',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'By scheduling this appointment, you confirm that:',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[700]),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '• You are between 18-65 years of age\n'
                                '• Your weight is at least 45 kg\n'
                                '• You have not donated blood in the last 3 months\n'
                                '• You are in good health and feeling well\n'
                                '• You have had something to eat in the last 3 hours',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Submit Button
                        ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE60000),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            disabledBackgroundColor: Colors.grey[400],
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Schedule Appointment',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlacesAutocompleteWidget extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String placeholder;
  final IconData icon;
  final bool isHospital;
  final Function(String, double, double)? onPlaceSelected;

  const PlacesAutocompleteWidget({
    super.key,
    required this.label,
    required this.controller,
    required this.placeholder,
    required this.icon,
    this.isHospital = false,
    this.onPlaceSelected,
  });

  @override
  _PlacesAutocompleteWidgetState createState() =>
      _PlacesAutocompleteWidgetState();
}

class _PlacesAutocompleteWidgetState extends State<PlacesAutocompleteWidget> {
  late PlacesApiService _placesService;
  final GlobalKey _fieldKey = GlobalKey();
  bool _loading = false;
  OverlayEntry? _overlayEntry;
  List<PlaceModel> _predictions = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _placesService = sl<PlacesApiService>();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (value.isNotEmpty) {
        setState(() {
          _loading = true;
        });
        try {
          final results = await _placesService.getPlacePredictions(value);
          setState(() {
            _predictions = results;
            _loading = false;
          });
          _showOverlay();
        } catch (e) {
          setState(() {
            _loading = false;
          });
          debugPrint('Error searching places: $e');
        }
      } else {
        _clearOverlay();
      }
    });
  }

  void _showOverlay() {
    _clearOverlay();
    final RenderBox renderBox =
        _fieldKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5,
        width: size.width,
        child: Material(
          elevation: 4.0,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: _predictions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_predictions[index].description),
                onTap: () async {
                  widget.controller.text = _predictions[index].description;
                  _clearOverlay();

                  // Get coordinates for the selected place
                  if (widget.onPlaceSelected != null) {
                    try {
                      final coordinates = await _placesService
                          .getPlaceDetails(_predictions[index].placeId);
                      widget.onPlaceSelected!(
                          _predictions[index].placeId,
                          coordinates['latitude'] ?? 0.0,
                          coordinates['longitude'] ?? 0.0);
                    } catch (e) {
                      debugPrint('Error getting place coordinates: $e');
                    }
                  }
                },
              );
            },
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _clearOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const Text(
                ' *',
                style: TextStyle(
                  color: Color(0xFFE60000),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            key: _fieldKey,
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              filled: true,
              fillColor: Colors.grey[50],
              suffixIcon: _loading
                  ? const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CircularProgressIndicator(strokeWidth: 2.0),
                    )
                  : Icon(widget.icon, color: Colors.grey[600]),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xFFE60000), width: 1),
              ),
            ),
            onChanged: _onChanged,
          ),
        ],
      ),
    );
  }
}
