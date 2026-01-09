import 'package:equatable/equatable.dart';

abstract class WorkerInfoFailure extends Equatable {
  final String message;
  const WorkerInfoFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends WorkerInfoFailure {
  const ServerFailure([super.message = 'Server error occurred']);
}

class ValidationFailure extends WorkerInfoFailure {
  const ValidationFailure([super.message = 'Validation error']);
}

class PermissionFailure extends WorkerInfoFailure {
  const PermissionFailure([super.message = 'Permission denied']);
}

class UnknownFailure extends WorkerInfoFailure{
  const UnknownFailure([super.message = 'Unknown error occurred']);
}
