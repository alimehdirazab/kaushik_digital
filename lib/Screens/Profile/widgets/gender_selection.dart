import 'package:flutter/material.dart';

class GenderSelection extends StatelessWidget {
  final String name;
  final Color bgcolor;
  final Color textColor;
  final void Function() onTap;
  const GenderSelection({
    super.key,
    required this.name,
    required this.onTap,
    this.bgcolor = Colors.transparent,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.015),
        decoration: BoxDecoration(
            color: bgcolor,
            border: Border.all(),
            borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500, color: textColor),
          ),
        ),
      ),
    );
  }
}
