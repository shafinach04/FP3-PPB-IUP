import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ppb_fp/pages/admin_dashboard.dart';
import 'package:ppb_fp/pages/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user logged in
          if(snapshot.hasData){
            return const AdminDashboard();
          }

          //user not logged in
          else {
            return LoginPage();
          }
        },
      ),
    );
  }
}