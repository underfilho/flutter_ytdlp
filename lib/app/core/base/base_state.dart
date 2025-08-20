import 'package:equatable/equatable.dart';
import 'failures.dart';

enum BaseStatus { initial, loading, done, failed }

class BaseState<T> extends Equatable {
  final BaseStatus status;
  final T? data;
  final Failure? failure;

  bool get isLoading => status == BaseStatus.loading;
  bool get isFailed => status == BaseStatus.failed;
  bool get isDone => status == BaseStatus.done;

  const BaseState._({
    required this.status,
    this.data,
    this.failure,
  });

  const BaseState.initial() : this._(status: BaseStatus.initial);

  const BaseState.loading() : this._(status: BaseStatus.loading);

  const BaseState.done(T data) : this._(status: BaseStatus.done, data: data);

  const BaseState.failed(Failure failure)
      : this._(status: BaseStatus.failed, failure: failure);

  @override
  List<Object?> get props => [status, data, failure];
}

class BaseVoidState extends Equatable {
  final BaseStatus status;
  final Failure? failure;

  bool get isLoading => status == BaseStatus.loading;
  bool get isFailed => status == BaseStatus.failed;
  bool get isDone => status == BaseStatus.done;

  const BaseVoidState._({
    required this.status,
    this.failure,
  });

  const BaseVoidState.initial() : this._(status: BaseStatus.initial);

  const BaseVoidState.loading() : this._(status: BaseStatus.loading);

  const BaseVoidState.done() : this._(status: BaseStatus.done);

  const BaseVoidState.failed(Failure failure)
      : this._(status: BaseStatus.failed, failure: failure);

  @override
  List<Object?> get props => [status, failure];
}
