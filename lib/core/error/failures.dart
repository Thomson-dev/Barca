import 'package:equatable/equatable.dart';

/// Base class for all domain-level failures.
///
/// Data sources throw [Exception]s (see `exceptions.dart`); repositories
/// catch those and map them to a [Failure] before returning an `Either`
/// to the domain/use case layer. Presentation code should only ever see
/// [Failure]s, never raw exceptions.
abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong on the server']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Something went wrong reading local cache']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred']);
}
