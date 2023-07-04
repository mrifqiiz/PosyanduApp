import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonTanggal extends StatelessWidget {
  final String label;
  final Function()? onTap;
  const ButtonTanggal({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          alignment: Alignment.center,
          width: 90,
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.blue),
          child: Text(label, style: GoogleFonts.lato(color: Colors.white))),
    );
  }
}
