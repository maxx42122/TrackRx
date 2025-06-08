import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Showstock extends StatefulWidget {
  const Showstock({super.key});

  @override
  State<Showstock> createState() => _ShowstockState();
}

class _ShowstockState extends State<Showstock> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "Register",
          style: GoogleFonts.poppins(fontSize: 30, color: Colors.white),
        )),
        backgroundColor: const Color.fromRGBO(117, 164, 136, 0.8),
      ),
    );
  }
}
