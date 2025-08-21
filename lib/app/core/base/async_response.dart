import 'package:dartz/dartz.dart';
import 'failures.dart';

typedef AsyncResult<T> = Future<Either<Failure, T>>;
typedef AsyncCall = Future<Option<Failure>>;

extension EitherUtils<T> on Either<Failure, T> {
  T get value => this.right;
  T? get valueNullable => _rightNullable;
  Failure get failure => this.left;
}

extension GenericEitherUtils<L, R> on Either<L, R> {
  R get right => _rightNullable!;
  R? get _rightNullable => fold((_) => null, (r) => r);
  L get left => _leftNullable!;
  L? get _leftNullable => fold((l) => l, (r) => null);
}

extension OptionUtils on Option<Failure> {
  Failure get failure => fold(() => null, (f) => f)!;
}
