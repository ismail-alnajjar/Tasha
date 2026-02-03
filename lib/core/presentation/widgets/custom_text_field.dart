import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool filled;
  final Color? fillColor;
  final double borderRadius;
  final Color? borderColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? prefixIconColor;

  const CustomTextField({
    super.key,
    this.controller,
    required this.label,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.filled = true,
    this.fillColor,
    this.borderRadius = 12.0,
    this.borderColor,
    this.textColor,
    this.hintColor,
    this.prefixIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: textColor ?? Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: hintColor ?? Colors.grey),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: prefixIconColor ?? Colors.grey)
            : null,
        fillColor: fillColor,
        filled: filled,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 24,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: borderColor != null
              ? BorderSide(color: borderColor!)
              : BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: borderColor != null
              ? BorderSide(color: borderColor!)
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(
            color: Color(0xFFEE8C2B),
            width: 1,
          ), // Primary Orange from design
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
    );
  }
}
