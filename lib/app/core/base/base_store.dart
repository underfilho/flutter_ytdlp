import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

abstract class BaseStore<V> {
  final ValueNotifier<V> notifier;

  BaseStore(V initialState) : notifier = ValueNotifier<V>(initialState);

  V get state => notifier.value;

  void emit(V newState) => notifier.value = newState;

  void dispose() => notifier.dispose();
}

class StoreProvider<S extends BaseStore> extends Provider<S> {
  StoreProvider({
    super.key,
    required super.create,
  }) : super(dispose: (_, store) => store.dispose());
}

class ConsumerBuilder<S extends BaseStore, V> extends StatelessWidget {
  final Widget Function(BuildContext context, V value) builder;
  final void Function(V value)? consumer;

  const ConsumerBuilder({super.key, required this.builder, this.consumer});

  @override
  Widget build(BuildContext context) {
    final store = context.read<S>();

    return ValueListenableBuilder<V>(
      valueListenable: store.notifier as ValueListenable<V>,
      builder: (context, value, _) {
        consumeState(value);
        return builder(context, value);
      },
    );
  }

  void consumeState(V value) {
    if (consumer == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      consumer?.call(value);
    });
  }
}
