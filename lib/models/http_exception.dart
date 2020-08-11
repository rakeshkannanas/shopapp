class HttpException implements Exception{
  final errorString;

  HttpException(this.errorString);

  @override
  String toString() {
    // TODO: implement toString
    return errorString;
  }
}