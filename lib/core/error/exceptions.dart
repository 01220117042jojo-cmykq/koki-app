
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'server_error']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'network_error']);
}

class LocationException implements Exception {
  final String message;
  const LocationException(this.message);
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
}