class Failure {
  const Failure(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection'])
      : super(code: 'network');
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timed out'])
      : super(code: 'timeout');
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error'])
      : super(code: 'server');
}

class EmptyFailure extends Failure {
  const EmptyFailure([super.message = 'No profiles found'])
      : super(code: 'empty');
}

class ParseFailure extends Failure {
  const ParseFailure([super.message = 'Invalid response from server'])
      : super(code: 'parse');
}
