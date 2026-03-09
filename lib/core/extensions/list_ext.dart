extension AppIterableOrNullExt<T> on Iterable<T>? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

extension AppListOfNullString<String> on Iterable<String>? {}

extension AppIterableExt<T> on Iterable<T> {
  /// Splits the elements into lists of the specified [size].
  ///
  /// You can specify an optional [fill] function that produces values
  /// that fill up the last chunk to match the chunk size.
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3, 4, 5, 6].chunkList(2);        // [[1, 2], [3, 4], [5, 6]]
  /// [1, 2, 3].chunkList(2);                 // [[1, 2], [3]]
  /// [1, 2, 3].chunkList(2, fill: () => 99); // [[1, 2], [3, 99]]
  /// ```
  Iterable<List<T>> chunkList(int size, {T Function()? fill}) {
    ArgumentError.checkNotNull(size, 'chunkSize');
    if (size <= 0) {
      throw ArgumentError('chunkSize must be positive integer greater than 0.');
    }

    if (isEmpty) {
      return const Iterable.empty();
    }

    final countOfChunks = (length / size.toDouble()).ceil();

    return Iterable.generate(countOfChunks, (int index) {
      final chunk = skip(index * size).take(size).toList();

      if (fill != null) {
        while (chunk.length < size) {
          chunk.add(fill());
        }
      }

      return chunk;
    });
  }

  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  T? lastOnNotEmpty() {
    if (isEmpty) return null;
    return last;
  }

  T? findOrFallBackFirst(bool Function(T element) test) {
    return firstWhereOrNull(test) ?? firstOrNull;
  }
}

extension AppListExt<T> on List<T> {
  Iterable<List<T>> databaseBatchChunk(List<T> data, int dataLength) sync* {
    const batchSize = 2000;

    for (var i = 0; i < dataLength; i += batchSize) {
      yield data.skip(i).take(batchSize).toList();
    }
  }
}

extension AppListStringExt on List<String> {
  String joinForTitle() {
    if (length > 2) {
      final last = removeLast();
      return "${join(", ")} & $last";
    }
    if (length == 2) {
      return "${this[0]} & ${this[1]}";
    }
    return join(", ");
  }
}
