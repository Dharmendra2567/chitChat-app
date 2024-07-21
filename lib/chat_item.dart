import 'package:cloud_firestore/cloud_firestore.dart';

class ChatItem {
  final String id;
  final String username;
  final String email;
  final String message;
  final String imagePath;
  final String time;

  ChatItem({
    required this.id,
    required this.username,
    required this.email,
    required this.message,
    required this.imagePath,
    required this.time,
  });
}

Stream<List<ChatItem>> fetchUsersFromFirestore() {
  return FirebaseFirestore.instance.collection('users').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      return ChatItem(
        id: doc.id,
        username: data['username'],
        email: data['email'],
        message: 'Good Morning',
        imagePath: 'assets/images/demo.jpg', // Placeholder for imagePath, you can update this later
        time: '20.00', // Placeholder for time, you can update this later
      );
    }).toList();
  });
}

