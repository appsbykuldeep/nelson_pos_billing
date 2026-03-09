import 'dart:async';

abstract class InitializedClass {
  FutureOr<void> initialized();
}

abstract class DisposeClass {
  FutureOr<void> dispose();
}
