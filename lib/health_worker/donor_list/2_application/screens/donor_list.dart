import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/donor_list_bloc.dart';
import '../widgets/donor_card_widget.dart';

class DonorList extends StatefulWidget {
  const DonorList({super.key});

  @override
  State<DonorList> createState() => _DonorListState();
}

class _DonorListState extends State<DonorList> {
  final TextEditingController _searchController = TextEditingController();
  final SearchType _selectedSearchType = SearchType.all;
  String _selectedBloodType = '';

  final List<String> _bloodTypes = [
    'All',
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  @override
  void initState() {
    super.initState();
    // Load donors when the widget is initialized
    context.read<DonorListBloc>().add(LoadDonors());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32F2F),
        foregroundColor: Colors.white,
        title: const Text(
          "Donor List",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Colors.grey[50],
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search by name',
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15),
                            ),
                            onChanged: (value) {
                              context.read<DonorListBloc>().add(
                                    SearchDonors(
                                      query: value,
                                      searchType: _selectedSearchType,
                                      bloodType: _selectedBloodType,
                                    ),
                                  );
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            context.read<DonorListBloc>().add(
                                  SearchDonors(
                                    query: '',
                                    bloodType: _selectedBloodType,
                                  ),
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Blood Group',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _bloodTypes.map((bloodType) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildBloodTypeChip(bloodType),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Donor List
            Expanded(
              child: BlocBuilder<DonorListBloc, DonorListState>(
                builder: (context, state) {
                  return _buildDonorList(state);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonorList(DonorListState state) {
    if (state is DonorListLoading) {
      return const Center(
          child: CircularProgressIndicator(
        color: Color(0xFFD32F2F),
      ));
    } else if (state is DonorListLoaded) {
      if (state.donors.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 60,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              const Text(
                'No donors found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _searchController.text.isNotEmpty
                    ? 'Try a different search term'
                    : 'No donor records available',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          context.read<DonorListBloc>().add(RefreshDonors());
          _searchController.clear();
        },
        child: ListView.builder(
          itemCount: state.donors.length,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemBuilder: (context, index) {
            final donor = state.donors[index];
            return DonorCardWidget(donor: donor);
          },
        ),
      );
    } else if (state is DonorListError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading donors',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<DonorListBloc>().add(LoadDonors());
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    } else {
      return const Center(
          child: CircularProgressIndicator(
        color: Color(0xFFD32F2F),
      ));
    }
  }

  Widget _buildBloodTypeChip(String bloodType) {
    final isSelected = _selectedBloodType == bloodType ||
        (bloodType == 'All' && _selectedBloodType.isEmpty);
    final textColor = isSelected ? Colors.white : Colors.black87;

    return FilterChip(
      selected: isSelected,
      backgroundColor: Colors.white,
      selectedColor: Colors.red,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.red : Colors.grey.shade300,
        ),
      ),
      label: Text(
        bloodType,
        style: TextStyle(
          color: textColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onSelected: (selected) {
        setState(() {
          // Set the selected blood type
          if (bloodType == 'All') {
            _selectedBloodType = '';
          } else {
            _selectedBloodType = selected ? bloodType : '';
          }
        });

        // Immediately filter donors by blood type
        context.read<DonorListBloc>().add(
              SearchDonors(
                query: _searchController.text,
                bloodType: bloodType == 'All' ? '' : bloodType,
              ),
            );
      },
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
