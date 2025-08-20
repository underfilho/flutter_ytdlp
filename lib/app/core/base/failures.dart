abstract class Failure {}

class UnknownFailure implements Failure {}

class NotFoundFailure implements Failure {}

class ConnectionFailure implements Failure {}

class TimeoutFailure implements Failure {}

class HttpFailure implements Failure {
  final int code;

  const HttpFailure(this.code);
}

class UserNotLogged implements Failure {}
