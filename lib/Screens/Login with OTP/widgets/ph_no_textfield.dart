import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PhNoTextfield extends StatelessWidget {
  TextEditingController controller;

  PhNoTextfield({
    super.key,
    required this.controller,
  });

  String? _formatMobileNumber(String input) {
    // Remove +92 or 0 from the start
    if (input.startsWith('+92')) {
      return input.substring(3);
    } else if (input.startsWith('0')) {
      return input.substring(1);
    }
    return input;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      maxLength: 10, // Limit input to 10 digits
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Allow only numbers
      ],
      onChanged: (value) {
        final formatted = _formatMobileNumber(value);
        if (formatted != null && formatted != value) {
          controller.value = TextEditingValue(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your mobile number';
        } else if (value.length != 10) {
          return 'Mobile number must be exactly 10 digits';
        }
        return null;
      },
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[900],
        hintText: 'e.g., 3123456789',
        hintStyle: GoogleFonts.namdhinggo(
          textStyle: const TextStyle(color: Colors.grey),
        ),
        labelText: 'Enter Your Mobile Number',
        labelStyle: GoogleFonts.namdhinggo(
          textStyle: TextStyle(color: Colors.grey[400]),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE50914), width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[700]!),
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
// TextFormField(
//       maxLines: maxLines,
//       keyboardType: keyboardType,
//       obscureText: obsecureText,
//       decoration: InputDecoration(
//         labelText: labelText,
//         labelStyle: GoogleFonts.namdhinggo(
//           textStyle: TextStyle(color: labelColor),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: borderColor),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: borderColor, width: 2),
//         ),
//       ),
//       style: TextStyle(color: textColor), // Set text color to white
//      validator: (val) {
//         if (val == null || val.isEmpty) {
//           return "Enter Your $labelText";
//         }
//         return null;
//       },
//     );
