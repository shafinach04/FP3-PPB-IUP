import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ppb_fp/components/my_textfield.dart';
import 'package:ppb_fp/components/sign_in_button.dart';
import 'package:ppb_fp/pages/home_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  // final Function()? onTap;
  void signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: usernameController.text,
      password: passwordController.text,
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            children: [
              IconButton(
                  onPressed: () {
                    _navigateToHome(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
              const Icon(
                Icons.person,
                size: 200,
              ),
              const SizedBox(height: 25),
              const Center(
                child: Text(
                  'Welcome back! ready to clock in?',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              myTextField(
                controller: usernameController,
                hintText: 'username',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              myTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              signInButton(onTap: signIn)
            ],
          ),
        ),
      ),
    );
  }
}
