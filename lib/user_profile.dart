import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_services.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

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
          const SizedBox(
            height: 110,
            width: 110,
            child: CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/demo.jpg'), // Update with actual image if available
            ),
          ),
          Text(
            username,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
          ),
          Text(email),
          Text('Last Active: $lastActiveTime'),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(11)),
                  child: const Column(
                    children: [
                      Icon(Icons.call, size: 35),
                      Text('Audio'),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    // color:Colors.grey[350],
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(11)),
                  child: const Column(
                    children: [
                      Icon(Icons.videocam, size: 35),
                      Text('Video'),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10), // Set padding
            child: ListTile(
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
            ),
          ),
          SizedBox(height: 10),
          //media and files
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10), // Set padding
            color: Colors.grey[400], // Set background color
            child: ListTile(
              contentPadding: EdgeInsets.all(5), // Optional: Additional padding inside the ListTile
              title: Text('Media & files'),
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
              child: Text('Report user',),
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
              child: Text('Block this account',style: TextStyle(color: Colors.red),),
            ),
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }
}
