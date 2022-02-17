class ChatMessage {
  String message;
  String senderId;

  ChatMessage({required this.message, required this.senderId});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(message: json['message'], senderId: json['senderId']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['senderId'] = this.senderId;
    return data;
  }
}
