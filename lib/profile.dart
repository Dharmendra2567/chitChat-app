import 'package:chat_app/chat_services.dart'; // Correct import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<Profile> {
  late String userId = '';
  late String username = '';
  late String email = '';
  late String lastActiveTime = '';
  String? fileUrl; // Nullable String for file URL

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          username = userDoc['username'];
          email = userDoc['email'];
          // Fetch the profile image URL if it exists
          fileUrl = userDoc['profileImageUrl'];
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File file = File(image.path);
      // Upload the image to Firebase Storage and get the download URL
      String? url = await _uploadFile(file, 'users_pic/$userId/profile.jpg');
      if (url != null) {
        // Update the Firestore document with the new image URL
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'profileImageUrl': url,
        });
        setState(() {
          fileUrl = url;
        });
      }
    }
  }

  Future<String?> _uploadFile(File file, String path) async {
    try {
      // Reference to the Firebase Storage location
      final storageRef = FirebaseStorage.instance.ref().child(path);
      // Upload the file
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      // Get the download URL
      String fileURL = await taskSnapshot.ref.getDownloadURL();
      return fileURL;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
            style: IconButton.styleFrom(foregroundColor: Colors.white),
          )
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                SizedBox(
                  height: 110,
                  width: 110,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: fileUrl != null
                        ? NetworkImage(fileUrl!)
                        : AssetImage('assets/images/demo.jpg') as ImageProvider, // Fallback to asset image
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      radius: 18,
                      child: Icon(Icons.camera_alt, size: 20, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            username,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
          ),
          Text(email),
          Text('Last Active: $lastActiveTime'),
          SizedBox(height: 10),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10), // Set padding
            child: const ListTile(
              leading: Icon(Icons.info_outline),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'about',
                    style: TextStyle(fontSize: 12),
                  ),
                  Text("Be your Best")
                ],
              ),
              trailing: Icon(Icons.edit),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10), // Set padding
            color: Colors.grey[300], // Set background color
            child: const ListTile(
              contentPadding: EdgeInsets.all(5), // Optional: Additional padding inside the ListTile
              title: Text('Backup & Restore',style: TextStyle(fontSize: 18)),
              trailing: Icon(Icons.arrow_forward_ios_sharp),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10), // Set padding
            color: Colors.grey[300], // Set background color
            child: const ListTile(
              contentPadding: EdgeInsets.all(5), // Optional: Additional padding inside the ListTile
              title: Text('Storage',style: TextStyle(fontSize: 18),),
              trailing: Icon(Icons.arrow_forward_ios_sharp),
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(10),
            // height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(width: 2, color: Colors.grey)),
            child: Center(
              child: Text('Logout',),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.all(10),
            // height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(width: 2, color: Colors.grey)),
            child: Center(
              child: Text('Delete account',style: TextStyle(color: Colors.red),),
            ),
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }
}
