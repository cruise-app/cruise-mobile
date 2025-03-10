class Failure {
  final String message;

  Failure({required this.message});

  factory Failure.fromJson(Map<String, dynamic> json) {
    return Failure(
      message: json['error'] ?? 'Unknown error',
    );
  }
}

class ServerFailure extends Failure {
  ServerFailure({required super.message});
}

class NetworkFailure extends Failure {
  NetworkFailure({required super.message});
}

class ValidationFailure extends Failure {
  ValidationFailure({required super.message});
}
