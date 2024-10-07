/// 自定义异常
class AesKeyNotSetException implements Exception {
  final String message;
  AesKeyNotSetException(this.message);

  @override
  String toString() => message;
}
