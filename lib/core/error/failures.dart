abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Please check your internet connection']);
}

class LocationFailure extends Failure {
  const LocationFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}