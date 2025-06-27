import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomListtile extends StatefulWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;
  const CustomListtile(
      {super.key, required this.icon, required this.text, required this.onTap});

  @override
  State<CustomListtile> createState() => _CustomListtileState();
}

class _CustomListtileState extends State<CustomListtile> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: h * 0.0065),
      child: GestureDetector(
        onTap: widget.onTap,
        child: ListTile(
          leading: Icon(
            widget.icon,
            size: h * 0.042,
          ),
          title: Text(
            widget.text,
            style: GoogleFonts.nunito(
              textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            size: h * 0.04,
          ),
        ),
      ),
    );
  }
}
