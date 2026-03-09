extension AppBoolExt on bool {
  /// It will  `0` on `false`,`1` on `true` as `int`
  int get value => this ? 1 : 0;
}
