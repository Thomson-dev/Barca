/// Thrown by remote data sources (e.g. a failed/unexpected API response).
class ServerException implements Exception {
  const ServerException([this.message = 'Something went wrong on the server']);

  final String message;
}

/// Thrown by local data sources (e.g. missing or corrupted cached data).
class CacheException implements Exception {
  const CacheException([this.message = 'Something went wrong reading local cache']);

  final String message;
}

/// Thrown when a network call is attempted without connectivity.
class NetworkException implements Exception {
  const NetworkException([this.message = 'No internet connection']);

  final String message;
}
