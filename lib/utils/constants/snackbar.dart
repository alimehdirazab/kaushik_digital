import 'package:flutter/material.dart';

void snackbar(String text, BuildContext context, [Color color = Colors.green]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: const TextStyle(fontSize: 15, color: Colors.white),
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      // action: SnackBarAction(
      //   label: 'Undo',
      //   textColor: Colors.white,
      //   onPressed: () {
      //     // Undo logic can be added here if needed
      //   },
      // ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      duration: const Duration(seconds: 3),
    ),
  );
}
