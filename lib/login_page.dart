import 'package:chat_app/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/messenger_app.dart';
import 'package:flutter/material.dart';

import 'Uihelper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? validateUsername(String? value) {
    return null;
  }

  String? validatePassword(String? value) {
    return null;
  }

  SignIn(String username, String password) async {
    if (username == '' && password == '') {
      UiHelper.CustomAlerbox(context, "Invalid username and password");
    } else {
      UserCredential? userCredentials;
      try {
        userCredentials = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: username, password: password)
            .then((value) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return MessengerApp(
              currentUserEmail: username,
            );
          }));
          return null;
        });
      } on FirebaseAuthException catch (exp) {
        UiHelper.CustomAlerbox(context, exp.code.toString());
      }
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
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Login',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 2,
          ),
          UiHelper.CustomTextField(_usernameController, 'enter username',
              'Username', Icons.person, false, validateUsername),
          UiHelper.CustomTextField(_passwordController, 'enter password',
              'Password', Icons.visibility, true, validatePassword),
          const SizedBox(
            height: 20,
          ),
          UiHelper.CustomButton(() {
            SignIn(_usernameController.text.toString(),
                _passwordController.text.toString());
          }, 'Login'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account,"),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()));
                  },
                  child: const Text('Create new Account'))
            ],
          )
        ],
      ),
    );
  }
}
