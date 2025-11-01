import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_exception.dart';

class ApiClient {
  final http.Client _client;
  final Duration timeout;
  final Map<String, String> defaultHeaders;

  ApiClient({
    http.Client? client,
    this.timeout = const Duration(seconds: 30),
    Map<String, String>? headers,
  })  : _client = client ?? http.Client(),
        defaultHeaders = headers ?? {'Content-Type': 'application/json'};

  Future<dynamic> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = _buildUri(url, queryParams);
      final response = await _client
          .get(
            uri,
            headers: _mergeHeaders(headers),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw TimeoutException('Request timeout');
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  Future<dynamic> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final uri = Uri.parse(url);
      final response = await _client
          .post(
            uri,
            headers: _mergeHeaders(headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw TimeoutException('Request timeout');
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  Future<dynamic> put(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final uri = Uri.parse(url);
      final response = await _client
          .put(
            uri,
            headers: _mergeHeaders(headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw TimeoutException('Request timeout');
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  Future<dynamic> delete(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(url);
      final response = await _client
          .delete(
            uri,
            headers: _mergeHeaders(headers),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw TimeoutException('Request timeout');
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  Uri _buildUri(String url, Map<String, dynamic>? queryParams) {
    final uri = Uri.parse(url);
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams.map(
        (key, value) => MapEntry(key, value.toString()),
      ));
    }
    return uri;
  }

  Map<String, String> _mergeHeaders(Map<String, String>? headers) {
    return {...defaultHeaders, if (headers != null) ...headers};
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      try {
        return jsonDecode(response.body);
      } catch (e) {
        return response.body;
      }
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw ServerException(
        'Client error: ${response.reasonPhrase}',
        response.statusCode,
      );
    } else if (response.statusCode >= 500) {
      throw ServerException(
        'Server error: ${response.reasonPhrase}',
        response.statusCode,
      );
    } else {
      throw ApiException(
        'Unexpected status code: ${response.statusCode}',
        response.statusCode,
      );
    }
  }

  void dispose() {
    _client.close();
  }
}

