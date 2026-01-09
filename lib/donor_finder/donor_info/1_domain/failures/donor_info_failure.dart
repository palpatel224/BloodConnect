import 'package:equatable/equatable.dart';

abstract class DonorInfoFailure extends Equatable {
  final String message;
  const DonorInfoFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends DonorInfoFailure {
  const ServerFailure([super.message = 'Server error occurred']);
}

class ValidationFailure extends DonorInfoFailure {
  const ValidationFailure([super.message = 'Validation error']);
}

class PermissionFailure extends DonorInfoFailure {
  const PermissionFailure([super.message = 'Permission denied']);
}

class UnknownFailure extends DonorInfoFailure {
  const UnknownFailure([super.message = 'Unknown error occurred']);
}
