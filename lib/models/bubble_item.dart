class BubbleItem {
  String? id;
  String type;
  String payload;
  bool received;
  BubbleItem(
      {required this.type,
      this.id,
      required this.payload,
      this.received = false});
}
