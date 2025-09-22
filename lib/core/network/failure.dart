class Failure implements Exception {
  final String message;
  final dynamic data;

  Failure(this.message, {this.data});

  @override
  String toString() => 'Failure: $message';
}

class ConnectionException extends Failure {
  ConnectionException(super.message);
}

class ServerException extends Failure {
  ServerException(super.message);
}
