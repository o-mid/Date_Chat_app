extension EmptyInsertion on String {
  /// Add a value into an array at a specific index if it exist.
  /// If not, it would insert it into the array.
  /// **Used only in ordered insertion**
  void forceInsertAt(List<String> list, int index) {
    try {
      list[index] = this;
    } catch (e) {
      list.add(this);
    }
  }
}
