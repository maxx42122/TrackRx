import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Registerpatient extends StatefulWidget {
  const Registerpatient({super.key});

  @override
  State<Registerpatient> createState() => _RegisterpatientState();
}

final ImagePicker imagePicker = ImagePicker();
XFile? selectfile;

class _RegisterpatientState extends State<Registerpatient> {
  TextEditingController emailController = TextEditingController();
  TextEditingController patientNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Register Patient",
            style: GoogleFonts.poppins(fontSize: 30, color: Colors.white),
          ),
        ),
        backgroundColor: const Color.fromRGBO(100, 150, 90, 1.0),
        elevation: 4.0, // Added elevation to appBar for depth
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                  // child: Text(
                  //   "Create Account",
                  //   style: GoogleFonts.jost(
                  //       fontSize: 25, fontWeight: FontWeight.bold),
                  // ),
                  ),
              GestureDetector(
                onTap: () async {
                  selectfile = await imagePicker.pickImage(
                    source: ImageSource.gallery,
                  );
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: selectfile != null
                            ? FileImage(File(selectfile!.path))
                            : null,
                        backgroundColor: Colors.white,
                        child: selectfile == null
                            ? const Icon(
                                Icons.account_circle,
                                size: 100,
                                color: Colors.grey,
                              )
                            : null, // Circle Avatar background
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              _buildTextField(emailController, "Enter Email",
                  icon: Icons.email),
              _buildTextField(patientNameController, "Patient Name",
                  icon: Icons.person),
              _buildTextField(passwordController, "Password",
                  icon: Icons.lock, obscureText: true),
              _buildTextField(ageController, "Age",
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.number),
              _buildTextField(genderController, "Gender",
                  icon: Icons.accessibility),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _registerPatient,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.shade400.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      )
                    ], // Added shadow to button
                  ),
                  child: const Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {IconData? icon,
      bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black26),
          prefixIcon: icon != null ? Icon(icon, color: Colors.green) : null,
          filled: true,
          fillColor: const Color(
              0xFFF1F8E9), // Light green background for input fields
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        keyboardType: keyboardType,
      ),
    );
  }

  void _registerPatient() async {
    if (emailController.text.trim().isEmpty ||
        patientNameController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        ageController.text.trim().isEmpty ||
        genderController.text.trim().isEmpty) {
      _showSnackBar("All fields are required!");
      return;
    }

    if (selectfile == null) {
      _showSnackBar("Please select an image!");
      return;
    }

    try {
      // Create user in Firebase Authentication
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      log("User registered: ${userCredential.user?.uid}");

      // Upload the image to Firebase Storage
      String fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
      Reference storageRef =
          FirebaseStorage.instance.ref().child("patients/$fileName");

      UploadTask uploadTask = storageRef.putFile(File(selectfile!.path));

      // Wait for the upload to complete and get the download URL
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      log("Image uploaded: $imageUrl");

      // Save patient data to Firestore
      Map<String, dynamic> data = {
        "email": emailController.text.trim(),
        "name": patientNameController.text.trim(),
        "password": passwordController.text.trim(),
        "age": ageController.text.trim(),
        "gender": genderController.text.trim(),
        "imageUrl": imageUrl,
      };

      await FirebaseFirestore.instance
          .collection("user")
          .doc(emailController.text.trim())
          .set(data);

      _showSnackBar("Registration successful!");
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (error) {
      log("Error: $error");
      _showSnackBar(error.message ?? "Registration failed.");
    } catch (e) {
      log("Unexpected error: $e");
      _showSnackBar("An error occurred during registration.");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.green, // Green color for success
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(20),
      elevation: 10,
    ));
  }
}
