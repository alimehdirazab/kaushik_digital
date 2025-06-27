import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DateOfBirthPicker extends StatelessWidget {
  final void Function()? onTap;
  final TextEditingController controller;

  const DateOfBirthPicker(
      {super.key, required this.onTap, required this.controller});

  // final TextEditingController _dobController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TextField(
        controller: controller,
        readOnly: true, // Prevent manual editing
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          labelText: 'Date of Birth',
          labelStyle: GoogleFonts.namdhinggo(textStyle: const TextStyle()),
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_month_outlined),
        ),
        onTap: () => onTap, // Open date picker
      ),
    );
  }
}
