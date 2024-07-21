import 'package:chat_app/Uihelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:intl/intl.dart';
import 'chat_services.dart';

class ChatScreens extends StatefulWidget {
  final String senderId;
  final String receiverId;
  final String receiverEmail;
  final String username;
  final String imageSrc;

  const ChatScreens({
    super.key,
    required this.senderId,
    required this.receiverId,
    required this.receiverEmail,
    required this.username,
    required this.imageSrc,
  });

  @override
  State<ChatScreens> createState() => _ChatScreensState();
}

class _ChatScreensState extends State<ChatScreens> {
  final TextEditingController _messageController = TextEditingController();
  final ChatServices chatServices = ChatServices();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _showEmojiPicker = false;

  Future<void> _openCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await chatServices.sendMessage(
        widget.receiverId,
        _messageController.text,
        widget.receiverEmail,
      );
      _messageController.clear();
    }

    if (_image != null) {
      // Add logic to upload and send image message
      setState(() {
        _image = null;
      });
    }
  }

  Widget _buildChatBubble(String message,String time, bool isSentByMe) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isSentByMe ? Colors.lightGreen[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: UiHelper.customMessageBox(message, time),
      ),
    );
  }

  Widget _buildChatBubbleWithImage(File image, bool isSentByMe) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isSentByMe ? Colors.lightGreen[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.file(
          image,
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 88,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            children: [
              const Icon(Icons.arrow_back, color: Colors.black),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(widget.imageSrc),
              ),
            ],
          ),
        ),
        titleSpacing: -7,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.username,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Text(
              'Last seen today at 5:00 pm',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.lightGreen[100],
      ),
      body: Column(
        children: [
          // Display messages here
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: chatServices.getMessages(widget.senderId, widget.receiverId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages'));
                }
                List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshot.data!.docs;
                print("Number of messages: ${docs.length}");
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot messageDoc = docs[index];
                    Map<String, dynamic> messageData = messageDoc.data() as Map<String, dynamic>;
                    String message = messageData['messages'] ?? '';
                    Timestamp timestamp = messageData['Timestamps'];
                    DateTime dateTime = timestamp.toDate();
                    String time = DateFormat('h:mm a').format(dateTime);
                    bool isSentByCurrentUser = messageData['senderId'] == widget.senderId;

                    print("Message: $message, Sent by me: $isSentByCurrentUser");
                    return _buildChatBubble(message,time, isSentByCurrentUser);
                  },
                );
              },
            ),
          ),


          // Preview of image before sending
          if (_image != null)
            Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Image.file(
                _image!,
                fit: BoxFit.cover,
              ),
            ),
          // Input box design
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showEmojiPicker = !_showEmojiPicker;
                                });
                              },
                              child: const Icon(Icons.emoji_emotions, color: Colors.grey),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                decoration: const InputDecoration(
                                  hintText: 'Type a message',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const Icon(Icons.attach_file, color: Colors.grey),
                            const SizedBox(width: 8.0),
                            GestureDetector(
                              onTap: _openCamera,
                              child: const Icon(Icons.camera_alt, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    CircleAvatar(
                      backgroundColor: Colors.lightGreen[100],
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
                if (_showEmojiPicker)
                  SizedBox(
                    height: 250,
                    child: EmojiPicker(
                      onEmojiSelected: (category, emoji) {
                        _messageController.text += emoji.emoji;
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
