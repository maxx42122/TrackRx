import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

class Registerhospital extends StatefulWidget {
  const Registerhospital({super.key});

  @override
  State<Registerhospital> createState() => _RegisterhospitalState();
}

class _RegisterhospitalState extends State<Registerhospital>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController hospitalNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    hospitalNameController.dispose();
    passwordController.dispose();
    idController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register Hospital",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 4.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Text(
                "Create an Account",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: emailController,
                        hintText: "Enter Email",
                        icon: Icons.email_outlined,
                      ),
                      _buildTextField(
                        controller: hospitalNameController,
                        hintText: "Hospital Name",
                        icon: Icons.local_hospital_outlined,
                      ),
                      _buildTextField(
                        controller: passwordController,
                        hintText: "Password",
                        icon: Icons.lock_outline,
                        obscureText: true,
                      ),
                      _buildTextField(
                        controller: idController,
                        hintText: "Hospital ID",
                        icon: Icons.badge_outlined,
                      ),
                      _buildTextField(
                        controller: addressController,
                        hintText: "Address",
                        icon: Icons.location_on_outlined,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _Registerhospital,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 6,
                ),
                icon: const Icon(
                  Icons.check_circle_outline,
                  size: 28,
                  color: Colors.white,
                ),
                label: const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 16, color: Color(0xFF424242)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black38),
          prefixIcon:
              Icon(icon, color: const Color.fromRGBO(117, 164, 136, 1.0)),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color.fromRGBO(117, 164, 136, 1.0),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _Registerhospital() async {
    if (emailController.text.trim().isNotEmpty &&
        hospitalNameController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty &&
        idController.text.trim().isNotEmpty &&
        addressController.text.trim().isNotEmpty) {
      try {
        UserCredential userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        log("User: $userCredential");
        log("Sign-up successful");

        Map<String, dynamic> data = {
          "emailId": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "Id": idController.text.trim(),
          "address": addressController.text.trim(),
          "hospitalName": hospitalNameController.text.trim(),
        };

        await FirebaseFirestore.instance
            .collection("hospital")
            .doc(emailController.text.trim())
            .set(data);

        _showAnimatedSnackBar(
            "Registration Successful!", AnimatedSnackBarType.success);
        Navigator.of(context).pop();
      } on FirebaseAuthException catch (error) {
        _showAnimatedSnackBar("Registration Failed: ${error.message}",
            AnimatedSnackBarType.error);
      }
    } else {
      _showAnimatedSnackBar(
          "Please fill in all fields.", AnimatedSnackBarType.warning);
    }
  }

  void _showAnimatedSnackBar(String message, AnimatedSnackBarType type) {
    AnimatedSnackBar.material(
      message,
      duration: const Duration(seconds: 3),
      type: type,
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
    ).show(context);
  }
}
