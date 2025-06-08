import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackrx/manufacturer/Profilemanufacturer.dart';
import 'package:trackrx/manufacturer/manufacturerpage/takerequest.dart';
import 'package:trackrx/manufacturer/mstatistics.dart';
import 'piechart.dart';
import 'historyoforder.dart';
import 'manufacturerpage/prepareorder.dart';
import 'stockmanufacturer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ///////////////////////////////////////////////////////////////////////////////
  TextEditingController medicenameController = TextEditingController();
  TextEditingController productidcontroller = TextEditingController();
  TextEditingController manufacturedatecontroller = TextEditingController();
  TextEditingController expirydatecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController quantitycontroller = TextEditingController();
  ////////////////////////////////////////////////////////////////////////////////
  TextEditingController categorycontoller = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<String> droplist = <String>['One', 'Two', 'Three', 'Four'];
  String? dropvalue;
//////////////////////////////////////////////////////////////////////////////////////////////

  Future<List<String>> fetchHospitalIds() async {
    try {
      // Query the "Hospitalorder" collection to get all hospital IDs
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Hospitalorder').get();

      // Extract document IDs (which represent hospitalIds)
      List<String> hospitalIds = snapshot.docs.map((doc) => doc.id).toList();

      log("HOSPITAL ID :- $hospitalIds");
      return hospitalIds;
    } catch (e) {
      print("Error fetching hospital IDs: $e");
      return [];
    }
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////fetch manufaturer id
  String? manufacturerId; // To store the fetched ID

  // Function to fetch manufacturer ID
  Future<void> fetchManufacturerId() async {
    try {
      // Get the current user's email
      User? currentUser = FirebaseAuth.instance.currentUser;
      String? userEmail = currentUser?.email;

      if (userEmail == null) {
        throw Exception("User is not logged in");
      }

      // Fetch the document using the email as the document ID
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('manufacturer')
          .doc(userEmail)
          .get();

      if (snapshot.exists) {
        // Extract the 'id' field
        String? fetchedId = snapshot.get('id');
        log("Manufacturer ID: $fetchedId");

        setState(() {
          manufacturerId = fetchedId; // Update the state with the fetched ID
        });
      } else {
        log("No document found for email: $userEmail");
      }
    } catch (e) {
      log("Error fetching manufacturer ID: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchManufacturerId(); // Fetch the ID on page load
  }

  /// Function to search medicines by `productId` (Firestore document ID)
  Future<Map<String, dynamic>?> searchMedicineById(String productId) async {
    try {
      // Fetch the document by ID (productId)
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('medicine')
          .doc(productId)
          .get();

      if (snapshot.exists) {
        // Return the document data
        return snapshot.data() as Map<String, dynamic>;
      } else {
        print("No medicine found with Product ID: $productId");
        return null;
      }
    } catch (e) {
      print("Error fetching medicine: $e");
      return null;
    }
  }

  /// Display search results in a dialog
  void showSearchResultsById(BuildContext context, String query) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Search Results",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: FutureBuilder<Map<String, dynamic>?>(
            // Replace with your search function
            future: searchMedicineById(query),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (snapshot.data == null) {
                return const Center(
                    child: Text("No medicine found with this Product ID"));
              } else {
                var medicine = snapshot.data!;
                return AnimatedScale(
                  duration: const Duration(milliseconds: 300),
                  scale: 1.0, // Keep this at 1.0 for a smooth scale animation
                  child: Card(
                    elevation:
                        8, // Increased elevation for a stronger shadow effect
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15), // Rounded corners
                    ),
                    color: Colors.teal.shade50, // Light teal background color
                    shadowColor:
                        Colors.teal.withOpacity(0.5), // Custom shadow color
                    child: ListTile(
                      leading: medicine['imageUrl'] != null
                          ? Image.network(
                              medicine['imageUrl'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.medication, size: 50),
                      title: Text(
                        medicine['medicenName'] ?? 'Unknown Name',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Product ID: $query\n"
                        "Category: ${medicine['category'] ?? 'N/A'}\n"
                        "Quantity: ${medicine['quantity'] ?? 'N/A'}\n"
                        "Manufacture Date: ${medicine['mdate'] ?? 'N/A'}\n"
                        "Expiry Date: ${medicine['edate'] ?? 'N/A'}",
                      ),
                      onTap: () {
                        Navigator.pop(context); // Close dialog on tap
                      },
                    ),
                  ),
                );
              }
            },
          ),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 190,
                ),
                child: Container(
                  color: const Color.fromARGB(87, 40, 102, 177),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        ////////////////////////////////////////////////////////////////////////////////////
                        ///\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PrepareOrder(
                                      hospitalId: '',
                                      orderId: '',
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 5),
                                child: Container(
                                  height: 200,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 63, 63, 104)
                                            .withOpacity(
                                                0.9), // Shadow color with transparency
                                        spreadRadius: 0.1, // Spread radius
                                        blurRadius:
                                            2, // Blur radius for a softer shadow
                                        offset: const Offset(7,
                                            7), // Horizontal and vertical offset
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 15),
                                    child: Column(
                                      children: [
                                        Container(
                                            height: 120,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: const Color.fromARGB(
                                                  255, 73, 162, 162),
                                            ),
                                            child: Image.asset(
                                                "assets/manufacturer/wh.gif")),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              "Prepare order",
                                              style: GoogleFonts.almarai(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
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
                            //////////////////////////////////////////////////////////////////////////////////
                            const Spacer(),
                            /////////////////////////////////////////////////////////////////////////////////
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return const OrderHistoryPage();
                                }));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, right: 5),
                                child: Container(
                                  height: 200,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 63, 63, 104)
                                            .withOpacity(
                                                0.9), // Shadow color with transparency
                                        spreadRadius: 0.1, // Spread radius
                                        blurRadius:
                                            2, // Blur radius for a softer shadow
                                        offset: const Offset(7,
                                            7), // Horizontal and vertical offset
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 14),
                                    child: Column(
                                      children: [
                                        Container(
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: const Color.fromARGB(
                                                  255, 73, 162, 162),
                                            ),
                                            child: Image.asset(
                                              "assets/manufacturer/history.gif",
                                              height: 160,
                                              width: 160,
                                            )),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              "History",
                                              style: GoogleFonts.almarai(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
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
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        // FutureBuilder to fetch hospital IDs dynamically

                        ////////////////////////////////////////////////////////////////////////////////
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const MedicineBarChart();
                                    },
                                  ),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 15),
                                child: Container(
                                  height: 200,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 63, 63, 104)
                                            .withOpacity(
                                                0.9), // Shadow color with transparency
                                        spreadRadius: 0.1, // Spread radius
                                        blurRadius:
                                            2, // Blur radius for a softer shadow
                                        offset: const Offset(7,
                                            7), // Horizontal and vertical offset
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 15),
                                    child: Column(
                                      children: [
                                        Container(
                                            height: 120,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: const Color.fromARGB(
                                                  255, 73, 162, 162),
                                            ),
                                            child: Image.asset(
                                                "assets/manufacturer/sts.gif")),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              "Statistics",
                                              style: GoogleFonts.almarai(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
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
                            //////////////////////////////////////////////////////////////////////////////////
                            ///////////////////////////////////////////////////////////////////////
                            ///

                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MedicinePage()),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, right: 5),
                                child: Container(
                                  height: 200,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 63, 63, 104)
                                            .withOpacity(
                                                0.9), // Shadow color with transparency
                                        spreadRadius: 0.1, // Spread radius
                                        blurRadius:
                                            2, // Blur radius for a softer shadow
                                        offset: const Offset(7,
                                            7), // Horizontal and vertical offset
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 15),
                                    child: Column(
                                      children: [
                                        Container(
                                            height: 120,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: const Color.fromARGB(
                                                  255, 73, 162, 162),
                                            ),
                                            child: Image.asset(
                                                "assets/manufacturer/stok.gif")),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              "Stock",
                                              style: GoogleFonts.almarai(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
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
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MedicinePieChart()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20, right: 15, left: 130, bottom: 50),
                            child: Container(
                              height: 200,
                              width: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(
                                            255, 63, 63, 104)
                                        .withOpacity(
                                            0.9), // Shadow color with transparency
                                    spreadRadius: 0.1, // Spread radius
                                    blurRadius:
                                        2, // Blur radius for a softer shadow
                                    offset: const Offset(
                                        7, 7), // Horizontal and vertical offset
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 15),
                                child: Column(
                                  children: [
                                    Container(
                                        height: 120,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: const Color.fromARGB(
                                              255, 73, 162, 162),
                                        ),
                                        child: Image.asset(
                                            "assets/manufacturer/pie.gif")),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          "Category",
                                          style: GoogleFonts.almarai(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  height: 210,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Colors.blueAccent,
                    //color: const Color.fromRGBO(117, 164, 136, 1.0),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 30,
                        bottom: 10,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 35.0, top: 10),
                            child: Text(
                              "Manufacturer",
                              style: GoogleFonts.aboreto(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            manufacturerId != null
                                ? "Id: $manufacturerId"
                                : "Loading Manufacturer ID...",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          // SizedBox(
                          //   height: 30,
                          // ),
                          TextField(
                            controller: searchController,
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                showSearchResultsById(context,
                                    value); // Call the updated function
                              }
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Enter Product ID",
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.4),
                                fontSize: 17,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Color.fromARGB(255, 6, 79, 139),
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          // Placeholder for main content
                          const Center(
                            child: Text("Main content here"),
                          ),

                          // Placeholder for main content
                        ],
                      )),
                ),
                SizedBox(
                  child: FutureBuilder<List<String>>(
                    future: fetchHospitalIds(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const Center(
                            child: Text("Error fetching hospital IDs"));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No hospitals found."));
                      }

                      List<String> hospitalIds = snapshot.data!;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          String hospitalId = hospitalIds[index];

                          return FutureBuilder<int>(
                            future: fetchOrderCount(hospitalId),
                            builder: (context, countSnapshot) {
                              int orderCount = countSnapshot.data ?? 0;

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const TakeRequestPage(),
                                    ),
                                  );
                                  print("Hospital ID: $hospitalId");
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                      right: 1, left: 265, top: 13),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(Icons.notification_add),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print(
                        "hhhffffffffffffffffffffffffffffffffffffffffffffffffffffffhhhhhhhhhhhhhhh");
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Profilemanufacturer()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 48.0, left: 360),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            child: const Icon(
                          Icons.account_circle,
                          color: Color.fromARGB(255, 2, 2, 2),
                          size: 30,
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<int> fetchOrderCount(String hospitalId) async {
    // Simulate a delay and return a random number as the order count
    await Future.delayed(const Duration(seconds: 1));
    return 5; // Just a placeholder value, you can replace it with real data
  }
}
