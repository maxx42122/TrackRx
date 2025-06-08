// import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:trackrx/AuthenticationPatient/forgotpass.dart';
// import 'package:trackrx/Patient/patient.dart';
// import 'package:trackrx/hospital/homepage.dart';

// import '../SharedPrefencepatient.dart';
// import '../hospital/registerui.dart';
// import 'registerpatient.dart';

// class Patientlogin extends StatefulWidget {
//   const Patientlogin({super.key});

//   @override
//   State<Patientlogin> createState() => _PatientloginState();
// }

// class _PatientloginState extends State<Patientlogin> {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   TextEditingController emailcontrol = TextEditingController();
//   TextEditingController password = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Padding(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: [
//           const SizedBox(
//             height: 50,
//           ),
//           const Text(
//             "Login ",
//             style: TextStyle(fontSize: 20),
//           ),
//           const SizedBox(
//             height: 30,
//           ),
//           TextField(
//             controller: emailcontrol,
//             decoration: const InputDecoration(
//                 border: OutlineInputBorder(), hintText: "Emailid"),
//           ),
//           const SizedBox(
//             height: 15,
//           ),
//           TextField(
//             controller: password,
//             decoration: const InputDecoration(
//                 border: OutlineInputBorder(), hintText: "password"),
//           ),
//           const SizedBox(
//             height: 15,
//           ),
//           GestureDetector(
//             onTap: () async {
//               if (emailcontrol.text.trim().isNotEmpty &&
//                   password.text.trim().isNotEmpty) {
//                 try {
//                   UserCredential userCredential =
//                       await _firebaseAuth.signInWithEmailAndPassword(
//                           email: emailcontrol.text.trim(),
//                           password: password.text.trim());
//                   log("In try Patient");
//                   log("islogin:${Sharedprefencepatient.isLogin}");
//                   log("c2w:$userCredential");

//                   await Sharedprefencepatient.StoredPData(
//                       ptype: "patient",
//                       Email: userCredential.user!.email!,
//                       isLogin: true);
//                   log("islogin:${Sharedprefencepatient.isLogin}");
//                   if (Sharedprefencepatient.ptype == "patient" &&
//                       Sharedprefencepatient.isLogin == true) {
//                     Navigator.of(context)
//                         .pushReplacement(MaterialPageRoute(builder: (context) {
//                       return Patient_UI();
//                     }));
//                   } else {
//                     log("In patient else");
//                   }
//                 } on FirebaseAuthException catch (error) {
//                   log("Eroror is succesfully");
//                   log("error:$error");
//                 }
//                 emailcontrol.clear();
//                 password.clear();
//               }
//             },
//             child: Container(
//               width: 80,
//               height: 40,
//               color: Colors.blue,
//               child: const Center(
//                 child: Text(
//                   "login",
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           GestureDetector(
//             onTap: () {
//               Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//                 return Registerpatient();
//               }));
//             },
//             child: Container(
//               child: Text("Create a new User >"),
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           GestureDetector(
//             onTap: () {
//               Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//                 return ForgotPassword();
//               }));
//             },
//             child: Container(
//               child: Text("Forgot Password"),
//             ),
//           )
//         ],
//       ),
//     ));
//   }
// }

import 'dart:async';
import 'dart:developer';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackrx/AuthenticationPatient/forgotpass.dart';
import 'package:trackrx/Patient/patient.dart';
import 'package:trackrx/hospital/homepage.dart';

import '../SharedPrefencepatient.dart';
import '../hospital/registerui.dart';
import 'registerpatient.dart';

class Patientlogin extends StatefulWidget {
  const Patientlogin({super.key});

  @override
  State<Patientlogin> createState() => _PatientloginState();
}

class _PatientloginState extends State<Patientlogin> {
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
                    // Image.asset(
                    //   "assets/manufacturer/logb1.jpg",
                    //   fit: BoxFit.cover,
                    // ),
                    // Image.asset(
                    //   "assets/manufacturer/logb5.jpg",
                    //   fit: BoxFit.cover,
                    // ),
                    // Image.asset(
                    //   "assets/manufacturer/logb2.jpg",
                    //   fit: BoxFit.cover,
                    // ),
                    Image.asset(
                      "assets/manufacturer/logb3.jpg",
                      fit: BoxFit.cover,
                    ),
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
                                return Registerpatient();
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
                                  return const Patient_UI();
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
                            color: const Color.fromRGBO(117, 164, 136, 1.0),
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
                          child: const Text("Forgot Password>"),
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
