import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackrx/Patient/cartpage.dart';
import 'package:trackrx/manufacturer/homepage.dart';
import 'package:trackrx/Patient/vitalpages/datavital.dart';
import '../scannerpages/scanqrcode.dart';
import 'askquestionpage.dart';
import 'bottomnavigationbar.dart';
import 'medicenInfo/amoxicil.dart';
import 'medicenInfo/azitromycin.dart';
import 'medicenInfo/cipro.dart';
import 'medicenInfo/dolo.dart';
import 'medicenInfo/ibupron.dart';
import 'patientmedicine.dart';

class Patient_UI extends StatefulWidget {
  const Patient_UI({super.key});

  @override
  State createState() => _Patient_UIState();
}

class _Patient_UIState extends State {
  final int _currentIndex = 0;

  List items = [
    "Check Alternatives \n of Medicine",
    "Order History & \n One-Click Reorder",
    "Order from \n your Local Pharmacy",
  ];
  List im = [
    "assets/patient/pexels-alex-green-5699515.jpg",
    "assets/patient/pexels-karolina-grabowska-4021811.jpg",
    "assets/patient/istockphoto-629758052-612x612.jpg",
  ];
  List items2 = [
    "Skin \n Care",
    "Oral \n Care",
    "Feminine \n hygine",
    "Hair \n Care",
    "Baby \n Care",
  ];
  List im2 = [
    "assets/patient/pexels-karolina-grabowska-4210659.jpg",
    "assets/patient/pexels-shiny-diamond-3762453.jpg",
    "assets/patient/pexels-ron-lach-8131580.jpg",
    "assets/patient/pexels-element5-973401.jpg",
    "assets/patient/pexels-emma-bauso-1183828-16579299.jpg",
  ];

  List items3 = [
    "Skin Care",
    "Lotion &\n Creams",
    "Baby Care",
    "Sunscreen \n Products",
    "Sanitizer &\n HandWash",
    "Eye Care",
  ];
  List im3 = [
    "assets/patient/—Pngtree—simulation skin care products_5409463.png",
    "assets/patient/—Pngtree—mock up cosmetic products for_15619191.png",
    "assets/patient/Cosmetics-Baby-Products-PNG-Download-Image.png",
    "assets/patient/sun-care-spf-50-cleanance-sunscreen.webp",
    "assets/patient/Hand-Sanitizer-Bottle-PNG-Image.png",
    "assets/patient/systane_hydration_10ml_eye_drops.png",
  ];

  TextEditingController demotextcontroller = TextEditingController();
  // List items4 = [
  //   "Sunscreen \n Products",
  //   "Sanitizer &\n HandWash",
  //   "Eye Care",
  // ];
  // List im4 = [
  //   "assets/patient/sun-care-spf-50-cleanance-sunscreen.webp",
  //   "assets/patient/Hand-Sanitizer-Bottle-PNG-Image.png",
  //   "assets/patient/systane_hydration_10ml_eye_drops.png",
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Image.asset("assets/patient/logo.png", height: 120, width: 80),
                Text(
                  "TrackRx",
                  style: GoogleFonts.quicksand(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: const Color.fromARGB(255, 0, 0, 0)),
                )
              ],
            ),
            TextField(
              controller: demotextcontroller,
              decoration: InputDecoration(
                hintText: "Search for Medicine",
                hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 80, 129, 175),
                    fontWeight: FontWeight.w200),
                filled: true,
                fillColor: const Color.fromARGB(255, 229, 238, 245),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    print("scan chya aatmadhe");
                    Navigator.pushNamed(context, "/scan");
                  },
                  child: const Icon(
                    Icons.qr_code_scanner,
                    color: Color.fromRGBO(5, 77, 154, 1),
                  ),
                ),
                // suffix: Container(

                //   width: 30,
                //   color: const Color.fromRGBO(5, 77, 154, 1),
                //   child: const Column(
                //     children: [
                //       Icon(
                //         Icons.arrow_drop_up,
                //         size: 14,
                //         color: Colors.white,
                //       ),
                //       Text(
                //         "Rx",
                //         style: TextStyle(
                //           fontSize: 12,
                //           color: Colors.white,
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),

            const Text(
              "",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),

            //////////////////////////////////////////////////////////////////////////////////////////////gridviewbuilder
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 150, // Set the height of the row
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Horizontal scrolling
                  itemCount: im.length, // The number of items
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Navigate to another page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Patientmedicine(),
                          ),
                        );
                      },
                      child: Container(
                        width: 220, // Set width for each item
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                              255, 183, 218, 210), // Background color
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            Image.asset(
                              im[index],
                              width: 250,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                            Positioned(
                              left: 5,
                              top: 100,
                              child: Text(
                                items[index], // Display item text
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 31, 29, 29),
                                  backgroundColor:
                                      Color.fromARGB(92, 220, 224, 239),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 80, // Set the height of the row
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Horizontal scrolling
                  itemCount: im2.length, // The number of items
                  itemBuilder: (context, index) {
                    return Container(
                      width: 150,
                      // Set width for each item
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            255, 183, 218, 210), // Background color
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(children: [
                        Image.asset(
                          im2[index],
                          width: 200,
                          height: 200,
                          fit: BoxFit.fill,
                        ),
                        Positioned(
                          left: 5,
                          top: 20,
                          child: Text(
                            items2[index], // Display item text
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                // backgroundColor: Color.fromARGB(92, 220, 224, 239),
                                fontSize: 16),
                          ),
                        ),
                      ]),
                    );
                  },
                ),
              ),
            ),

            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 250, // Adjust height for grid
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // 3 columns
                        childAspectRatio: 0.75, // Adjust aspect ratio as needed
                        crossAxisSpacing: 8.0, // Space between columns
                        mainAxisSpacing: .0, // Space between rows
                      ),
                      itemCount:
                          im3.length, // Number of items in the first grid
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return const cart(); // Update with your cart page
                                },
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: 100,
                                height: 100,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(255, 188, 183, 218),
                                ),
                                child: Image.asset(
                                  im3[index],
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Text(
                                items3[index],
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 31, 29, 29),
                                  backgroundColor:
                                      Color.fromARGB(92, 220, 224, 239),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            ////////////////////////////////////////////////videos and information
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Know your Product",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Top 100 most Popular Products Sold at Inventory",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Dolo()));
                            },
                            child: SizedBox(
                              width: 250,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 250,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.asset(
                                      "assets/patient/offercard1.jpg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  // const Text(
                                  //   "Dolo 650 Tablet के फायदे |Paracetamol Tablet ke U....",
                                  //   style: TextStyle(
                                  //     fontSize: 16,
                                  //     fontWeight: FontWeight.w900,
                                  //     color: Colors.black,
                                  //   ),
                                  // ),
                                  // const SizedBox(
                                  //   height: 10,
                                  // ),
                                  // const Text(
                                  //   " 461 Views",
                                  //   style: TextStyle(
                                  //     fontSize: 15,
                                  //     fontWeight: FontWeight.w700,
                                  //     color: Colors.grey,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          //////////////////// /////second cart/////////////////

                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Amoxicillin()));
                            },
                            child: Container(
                              width: 250,
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 250,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.asset(
                                      "assets/patient/Acimol.jpeg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  // const Text(
                                  //   "Nicip Plus Tablet के फायदे |Nimesulide Paracetamol.....",
                                  //   style: TextStyle(
                                  //     fontSize: 16,
                                  //     fontWeight: FontWeight.w900,
                                  //     color: Colors.black,
                                  //   ),
                                  // ),
                                  // const SizedBox(
                                  //   height: 10,
                                  // ),
                                  // const Text(
                                  //   " 461 Views",
                                  //   style: TextStyle(
                                  //     fontSize: 15,
                                  //     fontWeight: FontWeight.w700,
                                  //     color: Colors.grey,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),

                          //////Third Card///////
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Azithromycin()));
                            },
                            child: SizedBox(
                              width: 250,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 250,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.asset(
                                      "assets/patient/Azitho.jpeg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  // const Text(
                                  //   "Dolo 650 Tablet के फायदे |Paracetamol Tablet ke U....",
                                  //   style: TextStyle(
                                  //     fontSize: 16,
                                  //     fontWeight: FontWeight.w900,
                                  //     color: Colors.black,
                                  //   ),
                                  // ),
                                  // const SizedBox(
                                  //   height: 10,
                                  // ),
                                  // const Text(
                                  //   " 461 Views",
                                  //   style: TextStyle(
                                  //     fontSize: 15,
                                  //     fontWeight: FontWeight.w700,
                                  //     color: Colors.grey,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),

                          /// Fourthcard///////
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Ciprofloxacin()));
                            },
                            child: Container(
                              width: 250,
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 250,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.asset(
                                      "assets/patient/ciproper.jpeg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  // const Text(
                                  //   "Dolo 650 Tablet के फायदे |Paracetamol Tablet ke U....",
                                  //   style: TextStyle(
                                  //     fontSize: 16,
                                  //     fontWeight: FontWeight.w900,
                                  //     color: Colors.black,
                                  //   ),
                                  // ),
                                  // const SizedBox(
                                  //   height: 10,
                                  // ),
                                  // const Text(
                                  //   " 461 Views",
                                  //   style: TextStyle(
                                  //     fontSize: 15,
                                  //     fontWeight: FontWeight.w700,
                                  //     color: Colors.grey,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),

                          //// Fiveth Row///
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Ibuprofen()));
                            },
                            child: SizedBox(
                              width: 250,
                              //margin: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 250,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.asset(
                                      "assets/patient/ibuprofen.jpeg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  // const Text(
                                  //   "Dolo 650 Tablet के फायदे |Paracetamol Tablet ke U....",
                                  //   style: TextStyle(
                                  //     fontSize: 16,
                                  //     fontWeight: FontWeight.w900,
                                  //     color: Colors.black,
                                  //   ),
                                  // ),
                                  // const SizedBox(
                                  //   height: 10,
                                  // ),
                                  // const Text(
                                  //   " 461 Views",
                                  //   style: TextStyle(
                                  //     fontSize: 15,
                                  //     fontWeight: FontWeight.w700,
                                  //     color: Colors.grey,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),

            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: const EdgeInsets.all(19),

                // height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color.fromARGB(255, 20, 95, 166),
                ),
                child: GestureDetector(
                  onTap: () {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Do You have Prescription ?",
                              style: TextStyle(
                                color: Color.fromARGB(255, 226, 231, 237),
                              )),
                          Text(
                            "Order Now",
                            style: TextStyle(
                              color: Color.fromARGB(255, 117, 149, 179),
                            ),
                          )
                        ],
                      ),
                      Spacer(),
                      Icon(
                        Icons.upload_file,
                        color: Color.fromARGB(255, 237, 237, 236),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10, top: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: const Color.fromARGB(255, 20, 95, 166),
                      ),
                      height: 150,
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: const Icon(Icons.check_sharp)),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "100% \n Authentic \n Products",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, top: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: const Color.fromARGB(255, 175, 182, 188),
                      ),
                      height: 150,
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 20, 95, 166),
                                shape: BoxShape.circle),
                            child: const Icon(
                              Icons.save_alt_outlined,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Cash On Delivery\n for Pickup or\nHome Delivery",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return VitalsDataPage();
                      },
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: 410,
                  // height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: const LinearGradient(colors: [
                      Color.fromARGB(255, 155, 55, 97),
                      Color.fromARGB(255, 155, 55, 97),
                      Color.fromARGB(255, 155, 55, 97),
                      Color.fromARGB(255, 80, 29, 50)
                    ], end: Alignment.centerRight, begin: Alignment.centerLeft),
                  ),

                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Track",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Color.fromARGB(255, 226, 231, 237),
                                )),
                            Text("Your Vitals",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Color.fromARGB(255, 226, 231, 237),
                                )),
                            Text(
                              "Blood Pressure,Glucose & Weight",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 117, 149, 179),
                              ),
                            )
                          ],
                        ),
                        Spacer(),
                        Image.asset(
                          "assets/patient/stethoscope-graphic-clipart-design-free-png.webp",
                          height: 100,
                          width: 100,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: GestureDetector(
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AskQuestionHere();
                })),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Color.fromRGBO(111, 3, 205, 0.402),
                      Colors.blue,
                    ]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Text(
                          "Got any Questions?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "Ask here",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Icon(Icons.forward),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarUI(),
    );
  }
}
