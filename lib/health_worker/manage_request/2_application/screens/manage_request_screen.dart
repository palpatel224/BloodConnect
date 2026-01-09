import 'package:bloodconnect/donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';
import 'package:bloodconnect/health_worker/manage_request/2_application/screens/bloc/manage_request_screen_bloc.dart';
import 'package:bloodconnect/health_worker/manage_request/2_application/widgets/blood_request_card.dart';
import 'package:bloodconnect/health_worker/manage_request/2_application/widgets/filter_pills.dart';
import 'package:bloodconnect/health_worker/manage_request/2_application/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageRequestScreen extends StatefulWidget {
  const ManageRequestScreen({super.key});

  @override
  State<ManageRequestScreen> createState() => _ManageRequestScreenState();
}

class _ManageRequestScreenState extends State<ManageRequestScreen> {
  final TextEditingController _searchController = TextEditingController();
  RequestStatus _selectedFilter = RequestStatus.pending;

  @override
  void initState() {
    super.initState();
    context
        .read<ManageRequestScreenBloc>()
        .add(LoadRequests(status: _selectedFilter));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32F2F),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Manage Blood Requests',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          RequestSearchBar(
            controller: _searchController,
            onChanged: (value) {
              context
                  .read<ManageRequestScreenBloc>()
                  .add(SearchRequestsEvent(query: value));
            },
          ),

          // Filter Pills
          FilterPills(
            selectedFilter: _selectedFilter.toString().split('.').last,
            onFilterSelected: (filter) {
              setState(() {
                _selectedFilter = RequestStatus.values.firstWhere(
                  (e) => e.toString().split('.').last == filter,
                  orElse: () => RequestStatus.pending,
                );
              });
              context
                  .read<ManageRequestScreenBloc>()
                  .add(LoadRequests(status: _selectedFilter));
            },
          ),

          // Requests List
          Expanded(
            child:
                BlocBuilder<ManageRequestScreenBloc, ManageRequestScreenState>(
              builder: (context, state) {
                if (state is ManageRequestScreenLoading) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Color(0xFFD32F2F),
                  ));
                } else if (state is ManageRequestScreenLoaded) {
                  if (state.requests.isEmpty) {
                    return Center(
                      child: Text(
                          'No ${_selectedFilter.toString().split('.').last.toLowerCase()} requests found'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.requests.length,
                    itemBuilder: (context, index) {
                      return BloodRequestCard(request: state.requests[index]);
                    },
                  );
                } else if (state is ManageRequestScreenError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return const Center(child: Text('No requests found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Model class for blood request
class BloodRequest {
  final String id;
  final String patientName;
  final String bloodType;
  final String hospital;
  final String requestDate;
  final int unitsNeeded;
  final String requestedBy;
  final String notes;
  final String status;

  BloodRequest({
    required this.id,
    required this.patientName,
    required this.bloodType,
    required this.hospital,
    required this.requestDate,
    required this.unitsNeeded,
    required this.requestedBy,
    required this.notes,
    required this.status,
  });
}
