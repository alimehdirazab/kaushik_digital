import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextInputType? keyboardType;
  final bool obsecureText;
  final int maxLines;
  TextEditingController controller;
  final Color borderColor;
  final Color labelColor;
  final Color textColor;
  final bool isEmail;
  final String emailValidationmsg;
  final bool isPassword;

  CustomTextField(
      {super.key,
      required this.labelText,
      required this.controller,
      this.obsecureText = false,
      this.maxLines = 1,
      this.borderColor = Colors.black,
      this.labelColor = Colors.black,
      this.textColor = Colors.black,
      this.keyboardType = TextInputType.text,
      this.isEmail = false, // Default value is false
      this.isPassword = false,
      this.emailValidationmsg =
          "Enter a valid email or phone number" // Default value is false
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obsecureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.namdhinggo(
          textStyle: TextStyle(
            color: labelColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      style: TextStyle(
        color: textColor,
        decoration: TextDecoration.none, // Removes underline from the text
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return labelText; // Return error if field is empty
        }

        // Reassign `val` with its trimmed version
        val = val.trim();

        if (isEmail) {
          // Email and phone number validation logic
          final emailRegex = RegExp(
              r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$'); // No spaces allowed
          final allowedDomains = [
            'gmail.com',
            'yahoo.com',
            'outlook.com',
            'hotmail.com',
            'icloud.com',
            'aol.com',
            'example.com',
            'mail.com',
          ];

          final phoneRegex = RegExp(
              r'^\d{10,15}$'); // Accepts phone numbers with 10 to 15 digits

          if (emailRegex.hasMatch(val)) {
            // If it matches email, validate domain
            final domain = val.split('@').last;
            if (!allowedDomains.contains(domain)) {
              return "Enter an email with a valid domain (e.g., gmail.com)";
            }
            return null; // Valid email
          } else if (phoneRegex.hasMatch(val)) {
            // If it matches phone number, return valid
            return null; // Valid phone number
          } else {
            // Neither valid email nor valid phone
            return emailValidationmsg;
          }
        } else if (isPassword) {
          // Password validation logic
          if (val.length < 6) {
            return "Password must be at least 6 characters";
          }
        }

        return null; // No validation errors
      },
    );
  }
}



 // validator: (val) {
        //   if (val == null || val.isEmpty) {
        //     return labelText; // Return error if field is empty
        //   }
        //   if (isEmail) {
        //     final trimmedValue = val.trim(); // Remove leading and trailing spaces

        //     final emailRegex = RegExp(
        //         r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$'); // No spaces allowed
        //     final allowedDomains = [
        //       'gmail.com',
        //       'yahoo.com',
        //       'outlook.com',
        //       'hotmail.com',
        //       'icloud.com',
        //       'aol.com',
        //       'example.com',
        //       'mail.com',
        //     ];

        //     final phoneRegex = RegExp(
        //         r'^\d{10,15}$'); // Accepts phone numbers with 10 to 15 digits

        //     if (emailRegex.hasMatch(trimmedValue)) {
        //       // If it matches email, validate domain
        //       final domain = trimmedValue.split('@').last;
        //       if (!allowedDomains.contains(domain)) {
        //         return "Enter an email with a valid domain (e.g., gmail.com)";
        //       }
        //       return null; // Valid email
        //     } else if (phoneRegex.hasMatch(trimmedValue)) {
        //       // If it matches phone number, return valid
        //       return null; // Valid phone number
        //     } else {
        //       // Neither valid email nor valid phone
        //       return "Enter a valid email or phone number";
        //     }

        //   } else if (isPassword) {
        //     if (val.trim().length < 6) {
        //       return "Password must be at least 6 characters";
        //     }
        //   }
        //   return null;
        // },

        //   final emailRegex =
        //       RegExp(r'^\s*[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\s*$');
        //   if (!emailRegex.hasMatch(val)) {
        //     return "Enter a valid email address";
        //   }
        // }
        // if (isEmail) {
        //   final emailRegex =
        //       RegExp(r'^\s*[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\s*$');
        //   final allowedDomains = ['gmail.com', 'yahoo.com', 'outlook.com','hotmail.com','icloud.com','aol.com','mail.com'];

        //   if (!emailRegex.hasMatch(val)) {
        //     return "Enter a valid email address";
        //   }

        //   final domain = val.split('@').last.trim(); // Extract domain part
        //   if (!allowedDomains.contains(domain)) {
        //     return "Enter an email with a valid domain (e.g., gmail.com)";
        // }

        // Set text color
        // validator: (val) {
        //   if (val == null || val.isEmpty) {
        //     return "Enter Your $labelText";
        //   }
        //   return null;
        // }


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
