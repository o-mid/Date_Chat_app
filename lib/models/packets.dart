class MessageRequest {
  final String type;
  String message;
  final String senderId;

  MessageRequest(
      {required this.type, required this.message, required this.senderId});

  MessageRequest.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        message = json['message'],
        senderId = json['senderId'];

  Map<String, dynamic> toJson() => {
        'type': type,
        'message': message,
        'senderId': senderId,
      };
}
