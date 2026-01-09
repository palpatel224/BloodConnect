import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../1_domain/entities/donor_entity.dart';
import '../../../1_domain/usecases/get_donors.dart';

part 'donor_list_event.dart';
part 'donor_list_state.dart';

class DonorListBloc extends Bloc<DonorListEvent, DonorListState> {
  final GetDonors _getDonors;
  List<DonorEntity> _allDonors = [];

  DonorListBloc({required GetDonors getDonors})
      : _getDonors = getDonors,
        super(DonorListInitial()) {
    on<LoadDonors>(_onLoadDonors);
    on<RefreshDonors>(_onRefreshDonors);
    on<SearchDonors>(_onSearchDonors);
  }

  Future<void> _onLoadDonors(
    LoadDonors event,
    Emitter<DonorListState> emit,
  ) async {
    emit(DonorListLoading());
    try {
      _allDonors = await _getDonors();
      emit(DonorListLoaded(donors: _allDonors));
    } catch (e) {
      emit(DonorListError(message: e.toString()));
    }
  }

  Future<void> _onRefreshDonors(
    RefreshDonors event,
    Emitter<DonorListState> emit,
  ) async {
    try {
      _allDonors = await _getDonors();
      emit(DonorListLoaded(donors: _allDonors));
    } catch (e) {
      emit(DonorListError(message: e.toString()));
    }
  }

  void _onSearchDonors(
    SearchDonors event,
    Emitter<DonorListState> emit,
  ) {
    if (state is DonorListLoaded) {
      final query = event.query.toLowerCase();
      final bloodType = event.bloodType;

      // Start with all donors
      List<DonorEntity> filteredDonors = _allDonors;

      // First filter by blood type if specified
      if (bloodType.isNotEmpty) {
        filteredDonors = filteredDonors
            .where((donor) => donor.bloodType == bloodType)
            .toList();
      }

      // Then apply search query if it exists - searching only by name
      if (query.isNotEmpty) {
        filteredDonors = filteredDonors
            .where((donor) => donor.name.toLowerCase().contains(query))
            .toList();
      }

      emit(DonorListLoaded(donors: filteredDonors));
    }
  }
}
