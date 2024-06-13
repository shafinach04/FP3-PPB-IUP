import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
   LoginPage({super.key, required this.onTap});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final Function()? onTap;
  void SignIn(){

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
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

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    fillColor: Colors.black12,
                    filled: true,
                    hintText: 'Username',
                  ),
                ),
              ),

              SizedBox(height: 10),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    fillColor: Colors.black12,
                    filled: true,
                    hintText: 'Password',
                  ),
                ),
              ),

              SizedBox(height: 10),

              GestureDetector(
                onTap: SignIn,
                child: Container(
                  padding: EdgeInsets.all(25),
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: const Center(
                    child: Text(
                      "Sign in",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
