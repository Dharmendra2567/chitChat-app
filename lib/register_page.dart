import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/Uihelper.dart';
import 'package:chat_app/login_page.dart';
import 'package:chat_app/user_modal.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? validateUsername(String? value) {
    if (value == '') {
      return "username or email required";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == '') {
      return 'Email is required';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == '') {
      return 'password required';
    }
    return null;
  }

  String? validateConfirmPass(String? value) {
    if (value == '') {
      return 'this field required';
    }
    if (value != _passwordController.text) {
      return 'Password did not match';
    }
    return null;
  }

  Future<void> signUp(String email, String password, String confirmPass) async {
    if (email.isEmpty || password.isEmpty || confirmPass.isEmpty) {
      UiHelper.CustomAlerbox(context, 'Enter Required fields');
      return;
    }

    try {
      UserCredential userCredentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredentials.user;
      if (user != null) {
        UserModel userModel = UserModel(
          uid: user.uid,
          username: _usernameController.text.trim(),
          email: email,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userModel.toJson());

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const LoginPage();
        }));
      }
    } on FirebaseAuthException catch (exp) {
      UiHelper.CustomAlerbox(context, exp.code.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: UiHelper.customTitle(),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Register',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 2,
          ),
          UiHelper.CustomTextField(_usernameController, 'Enter username',
              'Username', Icons.person, false, validateUsername),
          UiHelper.CustomTextField(_emailController, 'Enter email', 'Email',
              Icons.email, false, validateEmail),
          UiHelper.CustomTextField(_passwordController, 'Enter password',
              'Password', Icons.visibility, true, validatePassword),
          UiHelper.CustomTextField(_confirmPassController, 'Confirm password',
              'Confirm Password', Icons.visibility, true, validateConfirmPass),
          const SizedBox(height: 20),
          UiHelper.CustomButton(() {
            signUp(
                _emailController.text.toString(),
                _passwordController.text.toString(),
                _confirmPassController.text.toString());
          }, 'Register'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account?'),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                child: const Text('Login here'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
