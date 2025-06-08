import 'dart:async';
import 'dart:developer';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackrx/AuthenticationPatient/forgotpass.dart';
import 'package:trackrx/Patient/patient.dart';
import 'package:trackrx/hospital/homepage.dart';

import '../../manufacturer/homepage.dart';
import '../SharedPrefencepatient.dart';
import '../hospital/registerui.dart';
import 'registermanufacturer.dart';

class manufacturerlogin extends StatefulWidget {
  const manufacturerlogin({super.key});

  @override
  State<manufacturerlogin> createState() => _manufacturerloginState();
}

class _manufacturerloginState extends State<manufacturerlogin> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  TextEditingController emailcontrol = TextEditingController();
  TextEditingController password = TextEditingController();

  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 4) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      } else {
        // Loop back to the first page without animation
        _currentPage = 0;
        _pageController.jumpToPage(_currentPage);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  bool _isExpanded = false;
  bool hidePassword = true;
  bool obsecure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    Image.asset(
                      "assets/manufacturer/logb1.jpg",
                      fit: BoxFit.cover,
                    ),
                    // Image.asset(
                    //   "assets/manufacturer/logb5.jpg",
                    //   fit: BoxFit.cover,
                    // ),
                    // Image.asset(
                    //   "assets/manufacturer/logb2.jpg",
                    //   fit: BoxFit.cover,
                    // ),
                    // Image.asset(
                    //   "assets/manufacturer/logb3.jpg",
                    //   fit: BoxFit.cover,
                    // ),
                    // Image.asset(
                    //   "assets/manufacturer/logb4.jpg",
                    //   fit: BoxFit.cover,
                    // ),
                  ],
                ),

                // loadingBuilder: (context, child, loadingProgress) {
                //   if (loadingProgress == null) return child;
                //   return const Center(child: CircularProgressIndicator());
                // },
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 160.0),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  //color: Colors.amber,
                  height: 450,
                  width: 350,
                  decoration: BoxDecoration(
                      color: Colors.white54,
                      border: Border.all(
                        color: _isExpanded ? Colors.black54 : Colors.blueGrey,
                        width: _isExpanded ? 5.0 : 3.0,
                      ),
                      borderRadius: BorderRadius.circular(29)),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Login ",
                        style: GoogleFonts.sanchez(
                            fontSize: 45, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextField(
                          controller: emailcontrol,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 2, 34, 61),
                                    width: 1.5),
                                borderRadius: BorderRadius.circular(10)),
                            labelText: "Emailid",
                            labelStyle:
                                GoogleFonts.aBeeZee(color: Colors.black54),
                            suffixIcon: const Icon(
                              Icons.email_outlined,
                              size: 30,
                              color: Colors.black45,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              //borderSide: BorderSide(color: Colors.black)
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextField(
                          controller: password,
                          obscureText: !hidePassword,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 2, 34, 61),
                                      width: 1.5),
                                  borderRadius: BorderRadius.circular(10)),
                              labelText: "Password",
                              labelStyle:
                                  GoogleFonts.aBeeZee(color: Colors.black54),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                                child: Icon(hidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.blue))),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? ",
                              style: TextStyle(color: Colors.black54)),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const Registermanufacturer();
                              }));
                            },
                            child: const Text(
                              "Register now!",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (emailcontrol.text.trim().isNotEmpty &&
                              password.text.trim().isNotEmpty) {
                            try {
                              UserCredential userCredential =
                                  await _firebaseAuth
                                      .signInWithEmailAndPassword(
                                          email: emailcontrol.text.trim(),
                                          password: password.text.trim());
                              log("In try Patient");
                              log("islogin:${Sharedprefencepatient.isLogin}");
                              log("c2w:$userCredential");

                              await Sharedprefencepatient.StoredPData(
                                  ptype: "patient",
                                  Email: userCredential.user!.email!,
                                  isLogin: true);
                              log("islogin:${Sharedprefencepatient.isLogin}");
                              if (Sharedprefencepatient.ptype == "patient" &&
                                  Sharedprefencepatient.isLogin == true) {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                  return const Home();
                                }));
                                AnimatedSnackBar.rectangle(
                                  'Success',
                                  'login successfully',
                                  type: AnimatedSnackBarType.success,
                                  brightness: Brightness.light,
                                ).show(
                                  context,
                                );
                              } else {
                                log("In patient else");
                              }
                            } on FirebaseAuthException catch (error) {
                              AnimatedSnackBar.rectangle(
                                'login failed',
                                'you have entered wrong field',
                                type: AnimatedSnackBarType.error,
                                brightness: Brightness.light,
                              ).show(
                                context,
                              );
                              log("Eroror is succesfully");
                              log("error:$error");
                            }
                            emailcontrol.clear();
                            password.clear();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFF4CAF50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 20, right: 20),
                            child: Text(
                              "Sig in",
                              style: GoogleFonts.bonaNova(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.of(context)
                      //         .push(MaterialPageRoute(builder: (context) {
                      //       return Registerpatient();
                      //     }));
                      //   },
                      //   child: Container(
                      //     child: Text("Create a new User >"),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return const ForgotPassword();
                          }));
                        },
                        child: Container(
                          child: const Text("Forgot Password >"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}











// import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:trackrx/AuthenticationPatient/manufacturer/registermanufacturer.dart';
// import 'package:trackrx/Patient/patient.dart';
// import 'package:trackrx/manufacturer/homepage.dart';
// import '../SharedPrefencepatient.dart';
// import '../forgotpass.dart';

// class manufacturerlogin extends StatefulWidget {
//   const manufacturerlogin({super.key});

//   @override
//   State<manufacturerlogin> createState() => _manufacturerloginState();
// }

// class _manufacturerloginState extends State<manufacturerlogin> {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   TextEditingController emailcontrol = TextEditingController();
//   TextEditingController password = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 50),
//             Text(
//               "Login as Manufacturer",
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF76A488), // Green color for branding
//               ),
//             ),
//             const SizedBox(height: 30),
//             _buildTextField(
//               controller: emailcontrol,
//               hintText: "Email ID",
//               icon: Icons.email_outlined,
//             ),
//             const SizedBox(height: 15),
//             _buildTextField(
//               controller: password,
//               hintText: "Password",
//               icon: Icons.lock_outline,
//               obscureText: true,
//             ),
//             const SizedBox(height: 25),
//             GestureDetector(
//               onTap: () async {
//                 if (emailcontrol.text.trim().isNotEmpty &&
//                     password.text.trim().isNotEmpty) {
//                   try {
//                     UserCredential userCredential =
//                         await _firebaseAuth.signInWithEmailAndPassword(
//                             email: emailcontrol.text.trim(),
//                             password: password.text.trim());
//                     log("Manufacturer logged in");

//                     await Sharedprefencepatient.StoredPData(
//                         ptype: "manufacturer",
//                         Email: userCredential.user!.email!,
//                         isLogin: true);

//                     if (Sharedprefencepatient.ptype == "manufacturer" &&
//                         Sharedprefencepatient.isLogin == true) {
//                       Navigator.of(context).pushReplacement(
//                           MaterialPageRoute(builder: (context) {
//                         return Home();
//                       }));
//                     } else {
//                       log("Invalid login attempt");
//                     }
//                   } on FirebaseAuthException catch (error) {
//                     log("Error during login: $error");
//                   }
//                   emailcontrol.clear();
//                   password.clear();
//                 }
//               },
//               child: Container(
//                 width: double.infinity,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: Color(0xFF76A488), // Green color
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Center(
//                   child: Text(
//                     "Login",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             GestureDetector(
//               onTap: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) {
//                     return Registermanufacturer();
//                   }),
//                 );
//               },
//               child: Text(
//                 "Don't have an account? Register here",
//                 style: TextStyle(
//                   color: Color(0xFF76A488), // Green color for register text
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             GestureDetector(
//               onTap: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) {
//                     return ForgotPassword();
//                   }),
//                 );
//               },
//               child: Text(
//                 "Forgot Password?",
//                 style: TextStyle(
//                   color: Color(0xFF76A488), // Green color for forgot password
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hintText,
//     required IconData icon,
//     bool obscureText = false,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: obscureText,
//       style: const TextStyle(fontSize: 16, color: Colors.black87),
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: const TextStyle(color: Colors.black38),
//         prefixIcon: Icon(
//           icon,
//           color: Color(0xFF76A488), // Green color for the icon
//         ),
//         filled: true,
//         fillColor: Color(0xFFF1F8E9), // Light green background for input fields
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(
//             color: Color(0xFF76A488), // Green border when focused
//             width: 2,
//           ),
//         ),
//       ),
//     );
//   }
// }








// import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:trackrx/Patient/patient.dart';
// import 'package:trackrx/manufacturer/homepage.dart';

// import '../manufacturer/registerui.dart';
// import '2sessiondata.dart';
// import '../showsnackbar.dart';

// class LoginScreen2 extends StatefulWidget {
//   const LoginScreen2({super.key});
//   @override
//   State<LoginScreen2> createState() => _LoginScreen2State();
// }

// class _LoginScreen2State extends State<LoginScreen2> {
//   final TextEditingController _emailTextEditingController =
//       TextEditingController();
//   final TextEditingController _passwordtextEditingController =
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
//             "Login",
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
//                     // borderSide: BorderSide(
//                     //   color: Color.fromARGB(255, 252, 3, 3),
//                     // ),
//                     ),
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
//               controller: _passwordtextEditingController,
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
//                   _passwordtextEditingController.text.trim().isNotEmpty) {
//                 try {
//                   UserCredential userCredential =
//                       await _firebaseAuth.signInWithEmailAndPassword(
//                     email: _emailTextEditingController.text,
//                     password: _passwordtextEditingController.text,
//                   );
//                   log("CEW :UserCredentials: ${userCredential.user!.email!}");

//                   await SessionData2.storeSessionData2(
//                     loginData2: true,
//                     emailId2: userCredential.user!.email!,
//                   );

//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(
//                       builder: (context) {
//                         return Home(
//                           email2: userCredential.user!.email!,
//                         );
//                       },
//                     ),
//                   );
//                 } on FirebaseAuthException catch (error) {
//                   log("C2W : ERROR :${error.code}");
//                   log("C2W : ERROR :${error.message}");
//                   Showsnackbar.showsnackbar(
//                     message: error.code,
//                     context: context,
//                   );
//                 }
//               }
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30.0)),
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
//               child: const Text(
//                 "Login",
//                 style: TextStyle(
//                   fontSize: 25,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 40,
//           ),
//           GestureDetector(
//             onTap: () {
//               Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) {
//                   return const RegisterScreen();
//                 },
//               ));
//             },
//             child: const Text(
//               "Create new account ? Register",
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
