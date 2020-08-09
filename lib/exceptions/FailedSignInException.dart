class FailedSignInException implements Exception {
  final String cause;

  FailedSignInException({this.cause});
}
