import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../error/failures.dart';

/// Contract every domain use case implements.
///
/// [Result] is what the use case returns on success, [Params] is its input.
/// Use [NoParams] when a use case doesn't need any input.
abstract class UseCase<Result, Params> {
  const UseCase();

  Future<Either<Failure, Result>> call(Params params);
}

/// Synchronous counterpart of [UseCase], for use cases that don't need to
/// await anything (e.g. pure calculations over already-loaded data).
abstract class SyncUseCase<Result, Params> {
  const SyncUseCase();

  Either<Failure, Result> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
