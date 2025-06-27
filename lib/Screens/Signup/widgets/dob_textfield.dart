import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class DobTextfield extends StatelessWidget {
  TextEditingController controller;

  DobTextfield({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        TextInputFormatter.withFunction((oldValue, newValue) {
          // Automatically format input as DD/MM/YY
          final text = newValue.text;
          final buffer = StringBuffer();
          for (int i = 0; i < text.length; i++) {
            buffer.write(text[i]);
            // Insert '/' after 2nd and 4th digits
            if ((i + 1) % 2 == 0 && i != text.length - 1 && i < 4) {
              buffer.write('/');
            }
          }
          return TextEditingValue(
            text: buffer.toString(),
            selection:
                TextSelection.collapsed(offset: buffer.toString().length),
          );
        }),
      ],
      maxLength: 8, // Maximum length: DD/MM/YY
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter Your Date of Birth';
        }
        final parts = value.split('/');
        if (parts.length != 3 ||
            parts.any((part) => part.isEmpty) ||
            parts[0].length != 2 ||
            parts[1].length != 2 ||
            parts[2].length != 2) {
          return 'Invalid format. Use DD/MM/YY';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'e.g., 09/12/24',
        hintStyle: GoogleFonts.namdhinggo(
          textStyle: const TextStyle(color: Colors.grey),
        ),
        labelText: 'Date of Birth',
        labelStyle: GoogleFonts.namdhinggo(
          textStyle: const TextStyle(color: Colors.white),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
