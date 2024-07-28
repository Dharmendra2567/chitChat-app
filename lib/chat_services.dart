import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'message.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatServices extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String?> uploadFile(File file, String chatRoomId) async {
    try {
      String filePath = '$chatRoomId/${DateTime.now().millisecondsSinceEpoch}';
      TaskSnapshot taskSnapshot = await storage.ref(filePath).putFile(file);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  // send messages
  Future<void> sendMessage(String receiverId, String message, String receiverEmail, {String? fileUrl}) async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("User not logged in");
    }

    final String currentUserId = currentUser.uid;
    final String currentUserEmail = currentUser.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        senderId: currentUserId,
        receiverEmail: receiverEmail,
        receiverId: receiverId,
        senderEmail: currentUserEmail,
        messages: message,
        fileUrl: fileUrl,
        timestamps: timestamp);

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join(('_'));

    try {
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

  // get messages
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');
    print("Fetching messages for chatRoomId: $chatRoomId");
    return firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('message')
        .orderBy('Timestamps', descending: false)
        .snapshots();
  }
}
final chatServices = ChatServices();