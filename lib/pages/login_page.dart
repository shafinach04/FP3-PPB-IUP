import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ppb_fp/components/my_textfield.dart';
import 'package:ppb_fp/components/sign_in_button.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  // final Function()? onTap;
  void signIn () async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Icon(
                Icons.person,
                size: 200,
              ),
              SizedBox(height: 25),

              Text(
                'Welcome back! ready to clock in?',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),

              SizedBox(height: 25,),

              myTextField(
                controller: usernameController,
                hintText: 'username',
                obscureText: false,
              ),

              SizedBox(height: 10),

              myTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
              ),

              SizedBox(height: 10),

              signInButton(
                  onTap: signIn
              )

            ],
          ),
        ),
      ),
    );
  }
}
