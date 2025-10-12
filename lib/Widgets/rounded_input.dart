import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import konstanta warna dari Theme
import '../Theme/app_theme.dart';

class RoundedInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Function(String)? onChanged;

  const RoundedInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: GoogleFonts.didactGothic(color: baseColor),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.didactGothic(color: baseColor.withOpacity(0.8)),
          border: InputBorder.none,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
