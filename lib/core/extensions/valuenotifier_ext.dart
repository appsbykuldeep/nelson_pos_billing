import 'package:flutter/material.dart';

extension ValueNotifierListOfT<T> on ValueNotifier<List<T>> {
  void add(T value) {
    this.value = [...this.value, value];
  }

  void remove(T value) {
    this.value = this.value.where((e) => e != value).toList();
  }
}
