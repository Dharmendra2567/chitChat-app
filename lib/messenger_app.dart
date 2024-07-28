import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';
import 'profile.dart';
import 'chat_screen.dart';
import 'chat_item.dart';

class MessengerApp extends StatefulWidget {
  final String currentUserEmail;
  const MessengerApp({super.key, required this.currentUserEmail});

  @override
  State<MessengerApp> createState() => _MessengerAppState();
}

class _MessengerAppState extends State<MessengerApp> {
  String currentUserId='';
   String currentUserEmail ='';
  String currentUsername='';
  int _selectedItem = 0;

  void _selectItem(int index) {
    setState(() {
      _selectedItem = index;
    });
  }

  void _handleMenuOption(String option) async {
    switch (option) {
      case 'Location':
      // Handle Location
        break;
      case 'Profile':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Profile()),
        );
        break;
      case 'Logout':
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const LoginPage()));
        break;
    }
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          currentUserId = user.uid;
          currentUsername = userDoc['username'];
          currentUserEmail = userDoc['email'];
          // lastActiveTime = userDoc['lastActiveTime']; // Ensure this field exists in your Firestore document
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChitChat'),
        backgroundColor: Colors.green[700],
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuOption,
            itemBuilder: (BuildContext context) {
              return {'Location', 'Profile', 'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      backgroundColor: Colors.lightGreen[100],

      body: StreamBuilder<List<ChatItem>>(
        stream: fetchUsersFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found'));
          } else {
            List<ChatItem> chatItems = snapshot.data!;
            return ListView.builder(
              itemCount: chatItems.length,
              itemBuilder: (context, index) {
                final chatItem = chatItems[index];
                if (chatItem.email == widget.currentUserEmail) {
                  return const SizedBox.shrink(); // This ensures the current user is not displayed
                }
                return InkWell(
                  onTap: () {
                    _fetchUserData();
                    print('sender Id: $currentUserId');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreens(
                                senderId: currentUserId,
                                receiverId: chatItem.id,
                                receiverEmail: chatItem.email,
                                username: chatItem.username,
                                imageSrc: chatItem.imagePath)));
                  },
                  child: Container(
                    height: 70,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          height: 50,
                          width: 60,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(chatItem.imagePath),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(chatItem.username,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(width: 30),
                                    Text(chatItem.time,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                Text(chatItem.message,
                                    style: const TextStyle(fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          child: IconButton(
                              icon: const Icon(Icons.keyboard_arrow_right_outlined),
                              onPressed: () {}),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green[700],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_library), label: 'Shorts'),
          BottomNavigationBarItem(icon: Icon(Icons.call_sharp), label: 'Calls')
        ],
        onTap: _selectItem,
        currentIndex: _selectedItem,
        selectedItemColor: Colors.white54,
      ),
    );
  }
}
