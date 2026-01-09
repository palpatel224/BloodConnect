import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../1_domain/entities/donor_info_entity.dart';
import '../../../1_domain/repositories/donor_info_repository.dart';
// Import the central places service
import '../../../../../core/services/places_service/places_service.dart';

part 'donor_info_event.dart';
part 'donor_info_state.dart';

class DonorInfoBloc extends Bloc<DonorInfoEvent, DonorInfoState> {
  final DonorInfoRepository _donorInfoRepository;
  final PlacesApiService _placesService;
  final FirebaseAuth _auth;
  Timer? _debounce;

  // Add this variable to track the last query and prevent duplicate searches
  String _lastSearchQuery = '';
  // Add this variable to track the last search time for manual debouncing
  DateTime _lastSearchTime = DateTime.now();

  DonorInfoBloc({
    required DonorInfoRepository donorInfoRepository,
    required PlacesApiService placesService,
    required FirebaseAuth auth,
  })  : _donorInfoRepository = donorInfoRepository,
        _placesService = placesService,
        _auth = auth,
        super(DonorInfoInitial()) {
    on<DonorInfoBloodGroupChanged>(_onBloodGroupChanged);
    on<DonorInfoDateOfBirthChanged>(_onDateOfBirthChanged);
    on<DonorInfoGenderChanged>(_onGenderChanged);
    on<DonorInfoLocationChanged>(_onLocationChanged);
    on<DonorInfoPhoneChanged>(_onPhoneChanged);
    on<DonorInfoSubmitted>(_onSubmitted);
    on<DonorInfoInitializeRequest>(_onInitialize);
    on<DonorInfoLocationSearched>(_onLocationSearched);
    on<DonorInfoLocationSelected>(_onLocationSelected);
  }

  void _onBloodGroupChanged(
    DonorInfoBloodGroupChanged event,
    Emitter<DonorInfoState> emit,
  ) {
    if (state is DonorInfoLoaded) {
      final currentState = state as DonorInfoLoaded;
      final updatedState = currentState.copyWith(
        bloodGroup: event.bloodGroup,
        isFormValid: _validateForm(
          bloodGroup: event.bloodGroup,
          dateOfBirth: currentState.dateOfBirth,
          gender: currentState.gender,
          location: currentState.location,
          phoneNumber: currentState.phoneNumber,
        ),
      );
      emit(updatedState);
    } else {
      emit(DonorInfoLoaded(
        bloodGroup: event.bloodGroup,
        isFormValid: false,
      ));
    }
  }

  void _onDateOfBirthChanged(
    DonorInfoDateOfBirthChanged event,
    Emitter<DonorInfoState> emit,
  ) {
    if (state is DonorInfoLoaded) {
      final currentState = state as DonorInfoLoaded;
      final updatedState = currentState.copyWith(
        dateOfBirth: event.dateOfBirth,
        isFormValid: _validateForm(
          bloodGroup: currentState.bloodGroup,
          dateOfBirth: event.dateOfBirth,
          gender: currentState.gender,
          location: currentState.location,
          phoneNumber: currentState.phoneNumber,
        ),
      );
      emit(updatedState);
    } else {
      emit(DonorInfoLoaded(
        dateOfBirth: event.dateOfBirth,
        isFormValid: false,
      ));
    }
  }

  void _onGenderChanged(
    DonorInfoGenderChanged event,
    Emitter<DonorInfoState> emit,
  ) {
    if (state is DonorInfoLoaded) {
      final currentState = state as DonorInfoLoaded;
      final updatedState = currentState.copyWith(
        gender: event.gender,
        isFormValid: _validateForm(
          bloodGroup: currentState.bloodGroup,
          dateOfBirth: currentState.dateOfBirth,
          gender: event.gender,
          location: currentState.location,
          phoneNumber: currentState.phoneNumber,
        ),
      );
      emit(updatedState);
    } else {
      emit(DonorInfoLoaded(
        gender: event.gender,
        isFormValid: false,
      ));
    }
  }

  void _onLocationChanged(
    DonorInfoLocationChanged event,
    Emitter<DonorInfoState> emit,
  ) {
    if (state is DonorInfoLoaded) {
      final currentState = state as DonorInfoLoaded;

      if (event.location.isEmpty) {
        emit(currentState.copyWith(
          location: '',
          locationPredictions: [],
          isSearching: false,
        ));
      } else {
        emit(currentState.copyWith(
          location: event.location,
          isFormValid: _validateForm(
            bloodGroup: currentState.bloodGroup,
            dateOfBirth: currentState.dateOfBirth,
            gender: currentState.gender,
            location: event.location,
            phoneNumber: currentState.phoneNumber,
          ),
        ));
      }
    } else {
      emit(DonorInfoLoaded(
        location: event.location,
        isFormValid: false,
      ));
    }
  }

  void _onPhoneChanged(
    DonorInfoPhoneChanged event,
    Emitter<DonorInfoState> emit,
  ) {
    if (state is DonorInfoLoaded) {
      final currentState = state as DonorInfoLoaded;
      final updatedState = currentState.copyWith(
        phoneNumber: event.phoneNumber,
        isFormValid: _validateForm(
          bloodGroup: currentState.bloodGroup,
          dateOfBirth: currentState.dateOfBirth,
          gender: currentState.gender,
          location: currentState.location,
          phoneNumber: event.phoneNumber,
        ),
      );
      emit(updatedState);
    } else {
      emit(DonorInfoLoaded(
        phoneNumber: event.phoneNumber,
        isFormValid: false,
      ));
    }
  }

  void _onInitialize(
    DonorInfoInitializeRequest event,
    Emitter<DonorInfoState> emit,
  ) async {
    emit(DonorInfoLoading());

    final result = await _donorInfoRepository.getDonorInfo(event.userId);

    result.fold(
      (failure) => emit(DonorInfoLoaded()),
      (donorInfo) => emit(DonorInfoLoaded(
        bloodGroup: donorInfo.bloodType,
        dateOfBirth: donorInfo.dateOfBirth,
        location: donorInfo.address,
        phoneNumber: donorInfo.phoneNumber,
        isFormValid: true,
      )),
    );
  }

  void _onLocationSearched(
    DonorInfoLocationSearched event,
    Emitter<DonorInfoState> emit,
  ) async {
    // Cancel any existing timer to be safe
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    final currentState =
        state is DonorInfoLoaded ? state as DonorInfoLoaded : DonorInfoLoaded();

    // Clear predictions if query is empty
    if (event.query.isEmpty) {
      emit(currentState.copyWith(
        locationPredictions: [],
        isSearching: false,
      ));
      return;
    }

    // Manual debounce logic
    final now = DateTime.now();
    if (event.query == _lastSearchQuery &&
        now.difference(_lastSearchTime).inMilliseconds < 700) {
      return;
    }

    _lastSearchQuery = event.query;
    _lastSearchTime = now;

    // Show searching indicator
    emit(currentState.copyWith(isSearching: true));

    try {
      // Use the centralized PlacesApiService directly
      final predictions = await _placesService.getPlacePredictions(event.query);

      // Make sure we're using the latest state (it might have changed)
      final updatedCurrentState =
          state is DonorInfoLoaded ? state as DonorInfoLoaded : currentState;

      emit(updatedCurrentState.copyWith(
        locationPredictions: predictions,
        isSearching: false,
      ));
    } catch (e) {
      debugPrint('Exception in location search: $e');
      if (!isClosed) {
        emit(DonorInfoError('Search failed: $e'));
        emit(currentState.copyWith(isSearching: false));
      }
    }
  }

  void _onLocationSelected(
    DonorInfoLocationSelected event,
    Emitter<DonorInfoState> emit,
  ) async {
    final currentState =
        state is DonorInfoLoaded ? state as DonorInfoLoaded : DonorInfoLoaded();

    emit(currentState.copyWith(
      location: event.description,
      isSearching: true,
      locationPredictions: [],
    ));

    try {
      // Use the centralized PlacesApiService directly
      final coordinates = await _placesService.getPlaceDetails(event.placeId);

      emit(currentState.copyWith(
        location: event.description,
        latitude: coordinates['latitude'],
        longitude: coordinates['longitude'],
        locationPredictions: [],
        isSearching: false,
        isFormValid: _validateForm(
          bloodGroup: currentState.bloodGroup,
          dateOfBirth: currentState.dateOfBirth,
          gender: currentState.gender,
          location: event.description,
          phoneNumber: currentState.phoneNumber,
        ),
      ));
    } catch (e) {
      emit(DonorInfoError(e.toString()));
      emit(currentState.copyWith(isSearching: false));
    }
  }

  void _onSubmitted(
    DonorInfoSubmitted event,
    Emitter<DonorInfoState> emit,
  ) async {
    if (state is DonorInfoLoaded) {
      final currentState = state as DonorInfoLoaded;

      if (currentState.bloodGroup == null || currentState.bloodGroup!.isEmpty) {
        emit(DonorInfoError('Please select a blood group'));
        return;
      }

      if (currentState.dateOfBirth == null) {
        emit(DonorInfoError('Please select your date of birth'));
        return;
      }

      if (currentState.location == null || currentState.location!.isEmpty) {
        emit(DonorInfoError('Please enter your location'));
        return;
      }

      if (currentState.phoneNumber == null ||
          currentState.phoneNumber!.isEmpty) {
        emit(DonorInfoError('Please enter your phone number'));
        return;
      }

      if (currentState.phoneNumber != null &&
          currentState.phoneNumber!.length < 10) {
        emit(DonorInfoError('Please enter a valid phone number'));
        return;
      }

      final today = DateTime.now();
      final age = today.year -
          currentState.dateOfBirth!.year -
          (today.month < currentState.dateOfBirth!.month ||
                  (today.month == currentState.dateOfBirth!.month &&
                      today.day < currentState.dateOfBirth!.day)
              ? 1
              : 0);

      if (age < 18) {
        emit(DonorInfoError('You must be at least 18 years old to register'));
        return;
      }

      emit(DonorInfoSubmissionInProgress());

      try {
        final user = _auth.currentUser;
        if (user == null) {
          emit(DonorInfoError('User not authenticated'));
          return;
        }

        final donorInfo = DonorInfo(
          userId: user.uid,
          name: user.displayName ?? 'Unknown',
          dateOfBirth: currentState.dateOfBirth!,
          bloodType: currentState.bloodGroup!,
          address: currentState.location!,
          phoneNumber: currentState.phoneNumber!,
          latitude: currentState.latitude,
          longitude: currentState.longitude,
        );

        final result = await _donorInfoRepository.saveDonorInfo(donorInfo);

        result.fold(
          (failure) {
            emit(DonorInfoSubmissionFailure(failure.message));
          },
          (_) {
            emit(DonorInfoSubmissionSuccess());
          },
        );
      } catch (e) {
        emit(DonorInfoSubmissionFailure('An error occurred: ${e.toString()}'));
      }
    } else {
      emit(DonorInfoError('Please fill all required fields'));
    }
  }

  bool _validateForm({
    String? bloodGroup,
    DateTime? dateOfBirth,
    String? gender,
    String? location,
    String? phoneNumber,
  }) {
    if (bloodGroup == null || bloodGroup.isEmpty) return false;
    if (dateOfBirth == null) return false;
    if (location == null || location.isEmpty) return false;
    if (phoneNumber == null || phoneNumber.isEmpty) return false;

    if (phoneNumber.length < 10) return false;

    return true;
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
