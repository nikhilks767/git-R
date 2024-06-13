// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String hintText;
  final Icon? prefixIcon;
  final Icon? sufffixIcon;

  CustomTextField({
    this.controller,
    this.decoration,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    required this.hintText,
    this.prefixIcon,
    this.sufffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: sufffixIcon,
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
      ),
    );
  }
}
