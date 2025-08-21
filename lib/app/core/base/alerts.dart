abstract class Alert {
  bool consumed = false;

  action(Function() callback) {
    if (consumed) return;
    consumed = true;
    return callback();
  }
}

class HideKeyboardAlert extends Alert {}
