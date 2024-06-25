import 'package:flutter/material.dart';

class myTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  const myTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black38),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
          ),
          fillColor: Colors.black12,
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }
}
