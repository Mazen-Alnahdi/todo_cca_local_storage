import 'package:equatable/equatable.dart';

/// A generic interface for all use cases in the application.
///
/// It standardizes the execution of a specific business logic operation.
/// [Type] represents the return type of the use case.
/// [Params] represents the parameters required to execute the use case.
abstract class UseCase<Type, Params> {
  Future<Type> call({required Params params});
}

/// A class to be used as a parameter for use cases that do not require any parameters.
/// This provides a more explicit and type-safe alternative to using `void` or `null`.
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
