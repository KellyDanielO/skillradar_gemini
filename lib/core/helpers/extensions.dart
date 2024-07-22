extension NullCheck on Object? {
  bool get isNull => this == null || this == 'null';
}