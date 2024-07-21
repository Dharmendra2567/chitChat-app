import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({ super.key});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late String username = '';
  late String email = '';
  late String lastActiveTime = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          username = userDoc['username'];
          email = userDoc['email'];
          // lastActiveTime = userDoc['lastActiveTime']; // Ensure this field exists in your Firestore document
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios)),
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
            child: Column(
              children: [
                const SizedBox(
                  height: 110,
                  width: 110,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/demo.jpg',), // Update with actual image if available
                  ),
                ),
                Text('Username: $username'),
                Text('Email: $email'),
                Text('Last Active : $lastActiveTime'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
