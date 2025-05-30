import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required String id,
    required String content,
    required MessageType type,
    required MessageSender sender,
    required DateTime timestamp,
    Map<String, dynamic>? additionalData,
  }) : super(
          id: id,
          content: content,
          type: type,
          sender: sender,
          timestamp: timestamp,
          additionalData: additionalData,
        );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    // Handle the Python API response format which has a 'response' key
    if (json.containsKey('response')) {
      final String responseText = json['response'];
      return MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: responseText,
        type: MessageType.text,
        sender: MessageSender.bot,
        timestamp: DateTime.now(),
        additionalData: null,
      );
    }
    
    // Handle the existing format
    return MessageModel(
      id: json['id'],
      content: json['content'],
      type: _mapMessageType(json['type']),
      sender: _mapMessageSender(json['sender']),
      timestamp: DateTime.parse(json['timestamp']),
      additionalData: json['additionalData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type.toString().split('.').last,
      'sender': sender.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'additionalData': additionalData,
    };
  }

  static MessageType _mapMessageType(String? type) {
    switch (type) {
      case 'text':
        return MessageType.text;
      case 'location':
        return MessageType.location;
      case 'carOptions':
        return MessageType.carOptions;
      case 'safety':
        return MessageType.safety;
      case 'recommendation':
        return MessageType.recommendation;
      case 'carpool':
        return MessageType.carpool;
      default:
        return MessageType.text;
    }
  }

  static MessageSender _mapMessageSender(String? sender) {
    switch (sender) {
      case 'user':
        return MessageSender.user;
      case 'bot':
        return MessageSender.bot;
      default:
        return MessageSender.bot;
    }
  }
}
