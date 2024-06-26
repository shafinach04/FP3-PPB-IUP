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
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black38),
          ),
          focusedBorder: const OutlineInputBorder(
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
