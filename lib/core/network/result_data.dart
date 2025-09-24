class ResultData<E, T> {
  final bool success;
  final E? error;
  final T? result;

  ResultData.success(this.result) : success = true, error = null;

  ResultData.error(this.error) : success = false, result = null;

  void process({required Function(E error) onError, required Function(T result) onSuccess}) {
    if (success && result != null) {
      onSuccess(result as T);
    } else if (error != null) {
      onError(error as E);
    }
  }
}
