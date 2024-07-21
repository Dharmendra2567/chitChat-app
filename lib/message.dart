import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String receiverEmail;
  final String receiverId;
  final String senderEmail;
  final String messages;
  final Timestamp timestamps;

  Message({
    required this.senderId,
    required this.receiverEmail,
    required this.receiverId,
    required this.senderEmail,
    required this.messages,
    required this.timestamps,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'receiverEmail': receiverEmail,
      'messages': messages,
      'Timestamps': timestamps,
    };
  }
}
