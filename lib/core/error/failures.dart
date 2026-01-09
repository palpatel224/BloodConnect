import 'package:equatable/equatable.dart';

/// Base Failure class that all specific failures should extend
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;
  final Exception? exception;

  const Failure({
    required this.message,
    this.statusCode,
    this.exception,
  });

  @override
  List<Object?> get props => [message, statusCode, exception];

  @override
  String toString() => message;
}

/// Server failures - for any API or backend service failures
class ServerFailure extends Failure {
  const ServerFailure(
    String message, {
    super.statusCode,
    super.exception,
  }) : super(message: message);
}

/// Cache failures - for local storage or cache-related issues
class CacheFailure extends Failure {
  const CacheFailure(String message, {super.exception})
      : super(message: message);
}

/// Network failures - specifically for connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure(String message, {super.exception})
      : super(message: message);
}

/// Authentication failures - for login, registration, and authentication issues
class AuthFailure extends Failure {
  const AuthFailure(String message, {super.exception})
      : super(message: message);
}

/// Validation failures - for form validation and data validation issues
class ValidationFailure extends Failure {
  final Map<String, String>? validationErrors;

  const ValidationFailure(
    String message, {
    this.validationErrors,
    super.exception,
  }) : super(message: message);

  @override
  List<Object?> get props => [...super.props, validationErrors];
}

/// Permission failures - for permission-related issues (location, camera, etc.)
class PermissionFailure extends Failure {
  const PermissionFailure(String message, {super.exception})
      : super(message: message);
}

/// Format failures - for data format issues
class FormatFailure extends Failure {
  const FormatFailure(String message, {super.exception})
      : super(message: message);
}

/// Location failures - specifically for location service issues
class LocationFailure extends Failure {
  const LocationFailure(String message, {super.exception})
      : super(message: message);
}

/// Database failures - for database-related issues
class DatabaseFailure extends Failure {
  const DatabaseFailure(String message, {super.exception})
      : super(message: message);
}

/// Unknown failures - when the cause cannot be determined
class UnknownFailure extends Failure {
  const UnknownFailure(
      [String message = 'An unknown error occurred', Exception? exception])
      : super(message: message, exception: exception);
}
