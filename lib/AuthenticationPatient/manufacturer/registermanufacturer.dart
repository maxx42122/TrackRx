import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Registermanufacturer extends StatefulWidget {
  const Registermanufacturer({super.key});

  @override
  State<Registermanufacturer> createState() => _RegistermanufacturerState();
}

class _RegistermanufacturerState extends State<Registermanufacturer> {
  TextEditingController EmailControl = TextEditingController();
  TextEditingController manufacturerName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController id = TextEditingController();
  TextEditingController grade = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Register Manufacturer",
            style: GoogleFonts.poppins(fontSize: 26, color: Colors.white),
          ),
        ),
        backgroundColor: const Color(0xFF76A488), // Soft green color
        elevation: 6.0,
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 40, right: 40, top: 100, bottom: 70),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 2,
                blurRadius: 5,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Register",
                      style: GoogleFonts.jost(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF76A488),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: EmailControl,
                    hintText: "Enter Email",
                    icon: Icons.email_outlined,
                  ),
                  _buildTextField(
                    controller: manufacturerName,
                    hintText: "Manufacturer Name",
                    icon: Icons.factory_outlined,
                  ),
                  _buildTextField(
                    controller: password,
                    hintText: "Password",
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  _buildTextField(
                    controller: id,
                    hintText: "ID",
                    icon: Icons.badge_outlined,
                  ),
                  _buildTextField(
                    controller: grade,
                    hintText: "Grade",
                    icon: Icons.grade_outlined,
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () async {
                      if (EmailControl.text.trim().isNotEmpty &&
                          manufacturerName.text.trim().isNotEmpty &&
                          password.text.trim().isNotEmpty &&
                          id.text.trim().isNotEmpty &&
                          grade.text.trim().isNotEmpty) {
                        try {
                          UserCredential userCredential = await _firebaseAuth
                              .createUserWithEmailAndPassword(
                                  email: EmailControl.text.trim(),
                                  password: password.text.trim());
                          log("User: $userCredential");
                          log("Sign-up successful");

                          Map<String, dynamic> data = {
                            "emailId": EmailControl.text.trim(),
                            "password": password.text.trim(),
                            "id": id.text.trim(),
                            "grade": grade.text.trim(),
                            "manufacturerName": manufacturerName.text.trim(),
                          };
                          FirebaseFirestore.instance
                              .collection("manufacturer")
                              .doc(EmailControl.text.trim())
                              .set(data);
                        } on FirebaseAuthException catch (error) {
                          log("Error: $error");
                        }
                      } else {
                        log("Please enter valid data");
                      }
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFF76A488), // Soft green
                      ),
                      child: const Center(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
          prefixIcon: Icon(icon, color: const Color(0xFF76A488)),
          filled: true,
          fillColor: const Color(0xFFF1F8E9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF76A488),
            ),
          ),
        ),
      ),
    );
  }
}










// import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import '../showsnackbar.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});
//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final TextEditingController _emailTextEditingController =
//       TextEditingController();
//   final TextEditingController _passwordTextEditingController =
//       TextEditingController();

//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   bool _showPassword = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             "Register",
//             style: TextStyle(
//               fontSize: 40,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: TextField(
//               controller: _emailTextEditingController,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//               ),
//               decoration: const InputDecoration(
//                 hintText: "Enter your email",
//                 hintStyle: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                 ),
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(
//                     color: Colors.white,
//                   ),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(15),
//             child: TextField(
//               controller: _passwordTextEditingController,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//               ),
//               obscureText: _showPassword,
//               decoration: InputDecoration(
//                   hintText: "Enter your password",
//                   border: const OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.white,
//                     ),
//                   ),
//                   hintStyle: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                   ),
//                   enabledBorder: const OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.white,
//                     ),
//                   ),
//                   suffixIcon: GestureDetector(
//                     onTap: () {
//                       _showPassword = !_showPassword;
//                       setState(() {});
//                     },
//                     child: Icon(
//                       (_showPassword) ? Icons.visibility_off : Icons.visibility,
//                       color: Colors.white,
//                     ),
//                   )),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           GestureDetector(
//             onTap: () async {
//               if (_emailTextEditingController.text.trim().isNotEmpty &&
//                   _passwordTextEditingController.text.trim().isNotEmpty) {
//                 try {
//                   UserCredential userCredential =
//                       await _firebaseAuth.createUserWithEmailAndPassword(
//                     email: _emailTextEditingController.text.trim(),
//                     password: _passwordTextEditingController.text.trim(),
//                   );
//                   log("USER CREDENTIALS : $UserCredential ");

//                   Showsnackbar.showsnackbar(
//                     message: "User Register Successfully",
//                     context: context,
//                   );
//                   Navigator.of(context).pop();
//                 } on FirebaseAuthException catch (error) {
//                   log("${error.code}");
//                   log("${error.message}");
//                   Showsnackbar.showsnackbar(
//                     message: error.message!,
//                     context: context,
//                   );
//                 }
//               } else {
//                 Showsnackbar.showsnackbar(
//                   message: "please enter valid fields",
//                   context: context,
//                 );
//               }
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30.0)),
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
//               child: const Text(
//                 "Register User",
//                 style: TextStyle(
//                   fontSize: 25,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 40,
//           ),
//         ],
//       ),
//     );
//   }
// }
