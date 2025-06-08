// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:trackrx/AuthenticationPatient/hospital/1login_hospital.dart';
// import 'package:trackrx/AuthenticationPatient/manufacturer/login_manufacture.dart';
// import 'package:trackrx/AuthenticationPatient/patient/loginpageui.dart';

// class typeLoginui extends StatefulWidget {
//   const typeLoginui({super.key});

//   @override
//   State<typeLoginui> createState() => _typeLoginuiState();
// }

// class _typeLoginuiState extends State<typeLoginui> {
//   @override
//   Widget build(BuildContext context) {
//     log("------------------------------------IN TYPE LOGIN UI----------------------------------");
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 20,
//             ),
//             Image.network(
//                 "https://tse2.mm.bing.net/th?id=OIP.GHgaKiq-VldXLUA3fwtnBgHaE7&pid=Api&P=0&h=180"),
//             const Spacer(),
//             const SizedBox(
//               height: 50,
//             ),
//             const Text(
//               "I Am",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.of(context)
//                     .pushReplacement(MaterialPageRoute(builder: (context) {
//                   return const manufacturerlogin();
//                 }));
//               },
//               child: Container(
//                 padding: const EdgeInsets.all(10),
//                 width: MediaQuery.of(context).size.width,
//                 height: 140,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     gradient: const LinearGradient(colors: [
//                       Color.fromRGBO(205, 197, 187, 0.039),
//                       Colors.white,
//                     ]),
//                     border: Border.all()),
//                 child: Row(
//                   children: [
//                     const Text(
//                       "Manufacture",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w800,
//                         color: Colors.blue,
//                       ),
//                     ),
//                     const Spacer(),
//                     Container(
//                       width: 100,
//                       height: 140,
//                       decoration: const BoxDecoration(),
//                       clipBehavior: Clip.antiAlias,
//                       child: Image.network(
//                         "https://tse2.mm.bing.net/th?id=OIP.7YV4kkY2NBYAZPrzuekTHgHaHo&pid=Api&P=0&h=180",
//                         fit: BoxFit.cover,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.of(context)
//                     .pushReplacement(MaterialPageRoute(builder: (context) {
//                   return const hospitallogin();
//                 }));
//               },
//               child: Container(
//                 padding: const EdgeInsets.all(10),
//                 width: MediaQuery.of(context).size.width,
//                 height: 140,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     gradient: const LinearGradient(colors: [
//                       Color.fromRGBO(205, 197, 187, 0.039),
//                       Colors.white,
//                     ]),
//                     border: Border.all()),
//                 child: Row(
//                   children: [
//                     const Text(
//                       "Hospital/Inventory",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w800,
//                         color: Colors.blue,
//                       ),
//                     ),
//                     const Spacer(),
//                     Container(
//                       width: 100,
//                       height: 140,
//                       decoration: const BoxDecoration(
//                           // borderRadius: BorderRadius.circular(50),
//                           // shape: BoxShape.circle
//                           // boxShadow: [BoxShadow(color: Colors.grey, blurRadius:8)]
//                           // color:Color.fromRGBO(205, 197, 187, 0.039),

//                           ),
//                       clipBehavior: Clip.antiAlias,
//                       child: Image.network(
//                         "https://tse1.mm.bing.net/th?id=OIP.6dx6XunK8RYFX-o1iu0B3AHaHS&pid=Api&P=0&h=180",
//                         fit: BoxFit.cover,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.of(context)
//                     .pushReplacement(MaterialPageRoute(builder: (context) {
//                   return const Patientlogin();
//                 }));
//               },
//               child: Container(
//                 padding: const EdgeInsets.all(10),
//                 width: MediaQuery.of(context).size.width,
//                 height: 140,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     gradient: const LinearGradient(colors: [
//                       Color.fromRGBO(205, 197, 187, 0.039),
//                       Colors.white,
//                     ]),
//                     border: Border.all()),
//                 child: Row(
//                   children: [
//                     const Text(
//                       "Patient",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w800,
//                         color: Colors.blue,
//                       ),
//                     ),
//                     const Spacer(),
//                     Container(
//                       width: 100,
//                       height: 140,
//                       decoration: const BoxDecoration(
//                           // borderRadius: BorderRadius.circular(50),
//                           // shape: BoxShape.circle
//                           // boxShadow: [BoxShadow(color: Colors.grey, blurRadius:8)]
//                           // color:Color.fromRGBO(205, 197, 187, 0.039),

//                           ),
//                       clipBehavior: Clip.antiAlias,
//                       child: Image.network(
//                         "https://tse2.mm.bing.net/th?id=OIP.4HQYWHOkX0hJF0vLivAlsgHaHa&pid=Api&P=0&h=180",
//                         fit: BoxFit.cover,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// // }import 'dart:async';
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:trackrx/AuthenticationPatient/hospital/1login_hospital.dart';
import 'package:trackrx/AuthenticationPatient/manufacturer/login_manufacture.dart';
import 'package:trackrx/AuthenticationPatient/patient/loginpageui.dart';

class typeLoginui extends StatefulWidget {
  const typeLoginui({super.key});

  @override
  State<typeLoginui> createState() => _typeLoginuiState();
}

class _typeLoginuiState extends State<typeLoginui> {
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      } else {
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

  Widget buildOption({
    required String title,
    required String imageUrl,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE1E9F5), Color(0xFFF8FBFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(2, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.blueAccent,
              size: 35,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A237E),
                ),
              ),
            ),
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(imageUrl),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3B5998), Color(0xFF192A56)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 150),
              Container(
                height: 300,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    Image.asset(
                      "assets/manufacturer/manufacturee.gif",
                      fit: BoxFit.cover,
                    ),
                    Image.network(
                      "https://thumbs.dreamstime.com/b/dreamstime-template-198954292.jpg",
                      fit: BoxFit.contain,
                    ),
                    Image.network(
                      "https://as2.ftcdn.net/v2/jpg/06/54/63/01/1000_F_654630110_SZ33nkULv94UswqjVxusC0GIOBmijZ8d.jpg",
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Text(
                "Who Are You?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: Colors.black45,
                      offset: Offset(2, 3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              buildOption(
                title: "Manufacturer",
                imageUrl:
                    "https://clipground.com/images/factory-icon-clipart-7.png",
                icon: Icons.factory_outlined,
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const manufacturerlogin()),
                  );
                },
              ),
              buildOption(
                title: "Hospital/Inventory",
                imageUrl:
                    "https://thumbs.dreamstime.com/b/dreamstime-template-198954292.jpg",
                icon: Icons.local_hospital_outlined,
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const hospitallogin()),
                  );
                },
              ),
              buildOption(
                title: "Patient",
                imageUrl:
                    "https://as2.ftcdn.net/v2/jpg/06/54/63/01/1000_F_654630110_SZ33nkULv94UswqjVxusC0GIOBmijZ8d.jpg",
                icon: Icons.person_outline,
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const Patientlogin()),
                  );
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
