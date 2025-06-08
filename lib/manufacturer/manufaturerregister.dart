import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController categorycontroller = TextEditingController();
  bool hide = true;
  List<String> dropcategory = [
    "Tablets",
    'Syrups',
    'Injectables',
    'Ointments',
    'Other Medical Supplies'
  ];
  String? dropcvalue;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(
      //       child: Text(
      //     "Register",
      //     style: GoogleFonts.poppins(fontSize: 30, color: Colors.white),
      //   )),
      //   backgroundColor: const Color.fromRGBO(117, 164, 136, 0.8),
      // ),
      body: Stack(
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
                    Image.asset(
                      "assets/manufacturer/logb5.jpg",
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      "assets/manufacturer/logb2.jpg",
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      "assets/manufacturer/logb3.jpg",
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      "assets/manufacturer/logb4.jpg",
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                // loadingBuilder: (context, child, loadingProgress) {
                //   if (loadingProgress == null) return child;
                //   return const Center(child: CircularProgressIndicator());
                // },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 40, right: 40, top: 200, bottom: 70),
            child: Container(
              //width: 300,
              //height: 500,
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Register",
                          style: GoogleFonts.jost(
                              fontSize: 35, fontWeight: FontWeight.bold),
                        ),
                      ),
                      //const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          decoration: InputDecoration(
                              //hintText: "Enter Email",
                              label: const Text("Enter Email"),
                              hintStyle: const TextStyle(color: Colors.black26),
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.black))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          decoration: InputDecoration(
                              //hintText: "Phone No",
                              label: const Text("Phone No"),
                              prefixIcon:
                                  const Icon(Icons.phone_android_outlined),
                              hintStyle: const TextStyle(color: Colors.black26),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.black))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          decoration: InputDecoration(
                              //prefixIcon: Icon(Icons.verified_user),
                              //hintText: "Name of User",
                              label: const Text("Name of User"),
                              hintStyle: const TextStyle(color: Colors.black26),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.black))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          obscureText: hide,
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    hide = hide ? false : true;
                                    setState(() {});
                                  },
                                  child: const Icon(
                                      Icons.remove_red_eye_outlined)),
                              //hintText: "Create Password",
                              label: const Text("Create Password"),
                              hintStyle: const TextStyle(color: Colors.black26),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.black))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          obscureText: hide,
                          decoration: InputDecoration(
                            labelText: categorycontroller.text,
                            labelStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w800),
                            hintStyle: const TextStyle(color: Colors.black26),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                            suffixIcon: DropdownButton(
                                value: dropcvalue,
                                items: dropcategory
                                    .map((String value) => DropdownMenuItem(
                                        value: value, child: Text(value)))
                                    .toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropcvalue = newValue;
                                    categorycontroller.text = dropcvalue!;
                                  });
                                }),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Center(
                          child: Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromRGBO(117, 164, 136, 0.8),
                            ),
                            child: const Center(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontSize: 23, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
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
    );
  }
}
