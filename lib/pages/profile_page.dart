import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? userEmail = user?.email;

    return Scaffold(
      body: Center(
        child: userEmail != null ? Text(userEmail) : const CircularProgressIndicator(),
      ),
    );
  }
}
