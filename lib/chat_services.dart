import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'message.dart';

class ChatServices extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Instance of Firestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Send messages
  Future<void> sendMessage(String receiverId, String message, String receiverEmail) async {
    // Get current user info
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("User not logged in");
    }

    final String currentUserId = currentUser.uid;
    final String currentUserEmail = currentUser.email!;
    final Timestamp timestamp = Timestamp.now();

    // Create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      receiverEmail: receiverEmail,
      receiverId: receiverId,
      senderEmail: currentUserEmail,
      messages: message,
      timestamps: timestamp,
    );

    // Construct chat rooms
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    try {
      // Add new message to the current chatRoom
      await firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('message')
          .add(newMessage.toMap());
      print("Message sent successfully");
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  // Get messages
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');
    print("Fetching messages for chatRoomId: $chatRoomId");
    return firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('message')
        .orderBy('Timestamps', descending: false) // Ensure this matches the Firestore field name
        .snapshots();
  }
}
