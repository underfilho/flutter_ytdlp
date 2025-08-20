import 'package:flutter/widgets.dart';

abstract class BaseStore<T> {
  final ValueNotifier<T> notifier;

  BaseStore(T initialState) : notifier = ValueNotifier<T>(initialState);

  T get state => notifier.value;

  void emit(T newState) => notifier.value = newState;

  void dispose() => notifier.dispose();
}
