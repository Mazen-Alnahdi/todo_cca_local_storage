/// Represents an exception that occurs during a server-side operation.
///
/// This custom exception is used to signal issues related to network requests
/// or API failures, such as a 404 Not Found or 500 Internal Server Error.
class ServerException implements Exception {
  /// An optional message providing more details about the error.
  final String? message;

  /// Creates a [ServerException] with an optional error [message].
  ServerException([this.message]);

  @override
  String toString() {
    if (message == null) return "ServerException";
    return "ServerException: $message";
  }
}
