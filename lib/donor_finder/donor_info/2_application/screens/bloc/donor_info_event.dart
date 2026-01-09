part of 'donor_info_bloc.dart';

@immutable
sealed class DonorInfoEvent {}

class DonorInfoBloodGroupChanged extends DonorInfoEvent {
  final String bloodGroup;
  DonorInfoBloodGroupChanged(this.bloodGroup);
}

class DonorInfoDateOfBirthChanged extends DonorInfoEvent {
  final DateTime dateOfBirth;
  DonorInfoDateOfBirthChanged(this.dateOfBirth);
}

class DonorInfoGenderChanged extends DonorInfoEvent {
  final String gender;
  DonorInfoGenderChanged(this.gender);
}

class DonorInfoLocationChanged extends DonorInfoEvent {
  final String location;
  DonorInfoLocationChanged(this.location);
}

class DonorInfoPhoneChanged extends DonorInfoEvent {
  final String phoneNumber;
  DonorInfoPhoneChanged(this.phoneNumber);
}

class DonorInfoSubmitted extends DonorInfoEvent {}

class DonorInfoInitializeRequest extends DonorInfoEvent {
  final String userId;
  DonorInfoInitializeRequest(this.userId);
}

// New Events for Places
class DonorInfoLocationSearched extends DonorInfoEvent {
  final String query;
  DonorInfoLocationSearched(this.query);
}

class DonorInfoLocationSelected extends DonorInfoEvent {
  final String placeId;
  final String description;
  DonorInfoLocationSelected(this.placeId, this.description);
}
