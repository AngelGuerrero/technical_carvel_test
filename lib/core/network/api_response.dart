sealed class ApiResponse<T> {
  const ApiResponse();
}

class ApiSuccess<T> extends ApiResponse<T> {
  final T data;
  const ApiSuccess(this.data);
}

class ApiError<T> extends ApiResponse<T> {
  final String message;
  final int? statusCode;
  const ApiError(this.message, [this.statusCode]);
}

class ApiLoading<T> extends ApiResponse<T> {
  const ApiLoading();
}

