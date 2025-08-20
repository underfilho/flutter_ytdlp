import 'dart:async';

class Debouncer<T> {
  final int milliseconds;
  Timer? _timer;
  int _requestId = 0;

  Debouncer({required this.milliseconds});

  void run(Future<T> Function() action, [void Function(T result)? onResult]) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), () async {
      final callId = ++_requestId;
      final result = await action();
      if (callId == _requestId && onResult != null) onResult(result);
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}
