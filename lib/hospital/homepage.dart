import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackrx/AuthenticationPatient/3typelogin.dart';
import 'package:trackrx/hospital/model_class/Alertlist_model.dart';
import 'package:trackrx/hospital/sales.dart';
import 'package:trackrx/manufacturer/mstatistics.dart';
import '../AuthenticationPatient/SharedPrefencepatient.dart';
import '../Patient/askquestionpage.dart';
import 'historymanufacture.dart';
import 'listpatient.dart';
import 'model_class/add_stock_model.dart';
import 'productcategory.dart';
import 'alertrequest.dart';
import 'recieveorder.dart';
import 'sendrequestpage.dart';
import 'stock_list.dart';
import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import './add_stock_model.dart';
import 'viewquestion.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State createState() => _HomePageUi();
}

class _HomePageUi extends State {
  String? hospitalId;
  bool notification = true;
  int notificationCount = 0;
  //int notificationCount=0;
  int lesscount = 30;
  // List<String> countlist = [];

  List<String> Categorylist = [
    "CardiacMedicine",
    "HighCholestrol",
    "Hypertension",
    "Osteoarthritis",
    "PainManagement"
        "EyeMedicine",
  ];

  /////////////////////////////////////////

  late Timer _timer;
  late Future<Map<String, String?>> _hospitalDetailsFuture;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _hospitalDetailsFuture = fetchHospitalDetails();

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

    //////////////////////
    Future.delayed(const Duration(seconds: 0), () async {
      await GetRequestData();
      log("notification : $notificationCount");
    });
    ////////////////////////
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

/////////GetMthod////////////////////////////////////////////////////////////////

  Future<void> GetRequestData() async {
    for (int i = 0; i < Categorylist.length; i++) {
      //log("___________________:${Categorylist[i]}");

      QuerySnapshot response =
          await FirebaseFirestore.instance.collection(Categorylist[i]).get();
      for (int j = 0; j < response.docs.length; j++) {
        //log(" Rs :${response.docs[j]['Rs']}");
        //log("================${int.parse(response.docs[j]['quantity'])}");
        if (int.parse(response.docs[j]['quantity']) < lesscount) {
          /////// alert  medicine Name added
          AlertlistModel.AlertData.add(response.docs[j]['medicineName']);
        }
      }
    }

    setState(() {});
    AlertlistModel.countmedicine = AlertlistModel.AlertData.length;
    log(":::${AlertlistModel.countmedicine}");
  }

  void remove() {
    Navigator.pop(context);
  }

  void snakbarmethod() {
    SnackBar snack = SnackBar(
      content: const Row(
        children: [
          Text(
            "Sucessfully send A Request",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          Spacer(),
          Icon(Icons.close)
        ],
      ),
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  TextEditingController medicineName = TextEditingController();
  TextEditingController delivery = TextEditingController();
  TextEditingController quantitys = TextEditingController();
  TextEditingController recevieddate = TextEditingController();

  Future<Map<String, String?>> fetchHospitalDetails() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> document =
            await FirebaseFirestore.instance
                .collection('hospital')
                .doc(currentUser.email)
                .get();

        if (document.exists) {
          final data = document.data();
          return {
            'hospitalName': data?['hospitalName'] as String?,
            'id': data?['Id'] as String?,
          };
        }
      }
    } catch (e) {
      debugPrint("Error fetching hospital details: $e");
    }
    return {'hospitalName': 'Unknown', 'id': 'Unknown'};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: FutureBuilder<Map<String, String?>>(
          future: fetchHospitalDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                "Loading...",
                style: TextStyle(color: Colors.black),
              );
            } else if (snapshot.hasError) {
              return const Text(
                "Error",
                style: TextStyle(color: Colors.red),
              );
            } else if (snapshot.hasData) {
              final hospitalName = snapshot.data?['hospitalName'] ?? "Unknown";
              hospitalId = snapshot.data?['id'] ?? "Unknown";
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$hospitalName Hospital",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "ID: $hospitalId",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 143, 139, 139),
                    ),
                  ),
                ],
              );
            } else {
              return const Text(
                "No Data",
                style: TextStyle(color: Colors.black),
              );
            }
          },
        ),
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              print("scan chya aatmadhe");
              Navigator.pushNamed(context, "/scan");
            },
            child: const Icon(
              Icons.qr_code_scanner,
              size: 20,
              color: Color.fromRGBO(5, 77, 154, 1),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              // Check if the hospitalId is fetched
              if (hospitalId != null) {
                // Navigate to ReceiveOrderPage and pass the hospitalId
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ReceiveOrderPage(
                      hospitalId: hospitalId!, // Pass the hospitalId
                    ),
                  ),
                );
              } else {
                // Optionally, show an error message if hospitalId is null
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Hospital ID is not available.")),
                );
              }
            },
            child: Column(children: [
              (AlertlistModel.countorder > 0)
                  ? Container(
                      width: 30,
                      height: 20,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 21, 164, 66),
                      ),
                      child: Center(
                        child: Text(
                          "${AlertlistModel.countorder}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      width: 30,
                      height: 20,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          "",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
              (AlertlistModel.countorder > 0)
                  ? const Icon(
                      Icons.notifications,
                      color: Color.fromARGB(255, 128, 1, 255),
                    )
                  : const Icon(Icons.notifications),
            ]),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
              onTap: () {
                //notification = true;
                AlertlistModel.countmedicine = 0;
                notificationCount = 0;
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const AlertPage();
                }));
                setState(() {});
              },
              child: Column(children: [
                (AlertlistModel.countmedicine > 0)
                    ? Container(
                        width: 30,
                        height: 20,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Center(
                          child: Text(
                            "${AlertlistModel.countmedicine}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: 30,
                        height: 20,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          //color: Colors.red,
                        ),
                        child: const Center(
                          child: Text(
                            "",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              // color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                (AlertlistModel.countmedicine > 0)
                    ? const Icon(
                        Icons.alarm,
                        color: Colors.red,
                      )
                    : const Icon(Icons.alarm),
              ])),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
              onTap: () {
                Sharedprefencepatient.StoredPData(
                    ptype: "", Email: "", isLogin: false);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const typeLoginui()));
              },
              child: const Icon(Icons.logout)),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
///////////////////////////////////////////////////////////////////////body
      body: FutureBuilder<Map<String, String?>>(
        future: _hospitalDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          } else if (snapshot.hasData) {
            final hospitalId = snapshot.data?['id'] ?? "Unknown";
            final hospitalName = snapshot.data?['hospitalName'] ?? "Unknown";

            return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
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
                              "assets/logo/a13.jpg",
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              "assets/logo/a14.avif",
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              "assets/logo/a15.avif",
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              "assets/logo/a17.avif",
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              "assets/logo/a18.avif",
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        // width: MediaQuery.of(context).size.width,
                        // height: 300,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            // border: Border.all(
                            //   width: 2.5,
                            //   color: Colors.blueGrey,
                            // ),

                            borderRadius: BorderRadius.circular(20)),

                        child: Container(
                          decoration: const BoxDecoration(
                              //color: Colors.white

                              //gradient: LinearGradient(begin: Alignment.topLeft, colors: [
                              // const Color.fromARGB(255, 173, 204, 219),
                              // //const Color.fromARGB(255, 177, 213, 178),
                              // const Color.fromARGB(255, 232, 240, 240),
                              // const Color.fromARGB(255, 187, 210, 222),
                              // Color.fromRGBO(72, 175, 198, 1),

                              // Colors.white54,

                              // Color.fromRGBO(72, 175, 198, 1),
                              //]),
                              ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return SendRequestPage();
                                      }));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          // color: Color.fromARGB(
                                          //     255, 213, 229, 229),
                                          // gradient: const LinearGradient(
                                          //     begin: Alignment.topLeft,
                                          //     end: Alignment.bottomRight,
                                          //     colors: [
                                          //       Color.fromARGB(
                                          //           255, 204, 220, 216),
                                          //       Color.fromARGB(
                                          //           255, 255, 255, 255)
                                          //     ]),
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 13,
                                            left: 8,
                                            right: 8,
                                            bottom: 8),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              height: 80,
                                              child: Image.asset(
                                                  "assets/logo/addstock.gif"),
                                            ),
                                            const Text(
                                              "Add Stock \nItem",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),

                                  // product Category call
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                          return const Productcategory();
                                        }),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          // color: Color.fromARGB(255, 213, 229, 229),
                                          // gradient: const LinearGradient(
                                          //     begin: Alignment.topLeft,
                                          //     end: Alignment.bottomRight,
                                          //     colors: [
                                          //       Color.fromARGB(
                                          //           255, 204, 220, 216),
                                          //       Color.fromARGB(
                                          //           255, 255, 255, 255)
                                          //     ]),
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              height: 80,
                                              child: Image.asset(
                                                  "assets/logo/kit.gif"),
                                            ),
                                            const Text(
                                              "Product\nCategory",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 13,
                                  )
                                ],
                              ),

                              ////////////////second collumn
                              ///
                              const Spacer(),

                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Column(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                            return const MedicinePieChart1();
                                          }),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            // color: Color.fromARGB(
                                            //     255, 213, 229, 229),
                                            // gradient: const LinearGradient(
                                            //     begin: Alignment.topLeft,
                                            //     end: Alignment.bottomRight,
                                            //     colors: [
                                            //       Color.fromARGB(
                                            //           255, 204, 220, 216),
                                            //       Color.fromARGB(
                                            //           255, 255, 255, 255)
                                            //     ]),
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                height: 100,
                                                child: Image.asset(
                                                    "assets/logo/gph.gif"),
                                              ),
                                              const Text(
                                                "Sales",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                            return const Listpatient();
                                          }),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            // color: Color.fromARGB(
                                            //     255, 213, 229, 229),
                                            // gradient: const LinearGradient(
                                            //     begin: Alignment.topLeft,
                                            //     end: Alignment.bottomRight,
                                            //     colors: [
                                            //       Color.fromARGB(
                                            //           255, 204, 220, 216),
                                            //       Color.fromARGB(
                                            //           255, 255, 255, 255)
                                            //     ]),
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                height: 95,
                                                child: Image.asset(
                                                  "assets/logo/pt1.gif",
                                                ),
                                              ),
                                              const Text(
                                                "Patient",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   width: 20,
                              // )
                            ],
                          ),
                        ),
                      ),
                    ),
////////////////////////////////////
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () => Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return ViewQuestionsFeedback(
                              hospitalName: hospitalName);
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
                                  "Patient Questions?",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  " here",
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
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Popular Brands",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.brown,
                            ),
                          ),
                          const Text(
                            "List of Product from the Powerhouses",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 10,
                                            offset: const Offset(0, 7),
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        "assets/logo/cipla.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Cipla",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              Container(
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 10,
                                            offset: const Offset(0, 7),
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        "assets/logo/OIP.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Durex",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              ////////////////
                              Container(
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 10,
                                            offset: const Offset(0, 7),
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        "assets/logo/mankind.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Mankind",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              ////////////////////
                              Container(
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 10,
                                            offset: const Offset(0, 7),
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        "assets/logo/alkem.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Alkem",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              /////////////////////
                            ],
                          ),
                          ///////////////////////////////////////////////
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 10,
                                            offset: const Offset(0, 7),
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        "assets/logo/Abbot.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Abbott",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              ///////////////////////////

                              Container(
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 10,
                                            offset: const Offset(0, 7),
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        "assets/logo/intas.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Intas",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              //////////////////////////////

                              Container(
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 10,
                                            offset: const Offset(0, 7),
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        "assets/logo/lupin.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Intas",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              //////////////////
                              Container(
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 10,
                                            offset: const Offset(0, 7),
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        "assets/logo/torrent.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Torrent",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
////////////////////////////////////////////////////
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 10,
                                            offset: const Offset(0, 7),
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        "assets/logo/leeford.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Leeford",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              /////////////////////////////////
                              Container(
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 10,
                                            offset: const Offset(0, 7),
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        "assets/logo/aristo.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Aristo",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              ///////////////////////
                              Container(
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 10,
                                            offset: const Offset(0, 7),
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        "assets/logo/macleods.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Macleods",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              //////////////////////
                              ///
                              Container(
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 10,
                                            offset: const Offset(0, 7),
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        "assets/logo/drready.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Dr",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),

                          ////////////////
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 10,
                                            offset: const Offset(0, 7),
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        "assets/logo/Gsk.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Glaxo",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              /////////////////////
                              ///
                              Container(
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 10,
                                            offset: const Offset(0, 7),
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        "assets/logo/glenmark.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Glenmark",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              //////////////////
                              Container(
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 10,
                                            offset: const Offset(0, 7),
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        "assets/logo/usv.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Usv",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              /////////////////////////////
                              Container(
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 10,
                                            offset: const Offset(0, 7),
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        "assets/logo/ipca.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Usv",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
/////////////////////////////////////////////////////////////////////
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 10,
                                            offset: const Offset(0, 7),
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        "assets/logo/zydus.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Zydus",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              //////////////////
                              Container(
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 10,
                                            offset: const Offset(0, 7),
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        "assets/logo/himalaya.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Himalaya",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              /////////////////////////////
                              Container(
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 10,
                                            offset: const Offset(0, 7),
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        "assets/logo/micro.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Micro",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              ////////////////////////////////////

                              Container(
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 10,
                                            offset: const Offset(0, 7),
                                          ),
                                        ],
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        "assets/logo/alembic.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Alembic",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ));
          } else {
            return const Center(child: Text("No Data"));
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

          BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return const StockList();
                      }),
                    );
                  },
                  child: const Icon(Icons.storage)),
              label: "Stock"),

          //  BottomNavigationBarItem(
          //   icon:Icon(Icons.bar_chart),
          //   label: "Stock"

          // ),
          BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return StockList1();
                      }),
                    );
                  },
                  child: const Icon(Icons.history)),
              label: "History"),
        ],
      ),
    );
  }
}
