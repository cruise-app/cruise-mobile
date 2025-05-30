import 'package:equatable/equatable.dart';

enum MessageType {
  text,
  location,  // For location-based messages
  carOptions,
  carpool,
  safety,
  recommendation
}

enum MessageSender {
  user,
  bot
}

class Message extends Equatable {
  final String id;
  final String content;
  final MessageType type;
  final MessageSender sender;
  final DateTime timestamp;
  final Map<String, dynamic>? additionalData;
  
  const Message({
    required this.id,
    required this.content,
    required this.type,
    required this.sender,
    required this.timestamp,
    this.additionalData,
  });
  
  @override
  List<Object?> get props => [
    id, 
    content, 
    type, 
    sender, 
    timestamp,
    additionalData
  ];
}
