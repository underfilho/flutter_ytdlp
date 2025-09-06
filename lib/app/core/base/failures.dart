import 'alerts.dart';

abstract class Failure extends Alert {}

class UnknownFailure extends Failure {}

class NotFoundFailure extends Failure {}

class ConnectionFailure extends Failure {}

class TimeoutFailure extends Failure {}
