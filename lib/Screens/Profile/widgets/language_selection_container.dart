import 'package:flutter/material.dart';

class LanguageSelectionContainer extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const LanguageSelectionContainer({
    super.key,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.012),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Adjust width to content
          children: [
            const Icon(
              Icons.add,
              size: 20,
            ),
            // const SizedBox(width: 8), // Space between icon and text
            Text(
              name,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
