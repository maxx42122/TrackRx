// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'dart:developer';

// // import 'model_class/stockList_model.dart';

// // class StockList extends StatefulWidget {
// //   const StockList({super.key});
// //   @override
// //   State createState() => _StockListState();
// // }

// // class _StockListState extends State {
// //   List<StocklistModel> stockList = [];
// //   List<StocklistModel> filteredStockList = [];
// //   int alertQuantity = 30;

// //   List<String> Categorylist = [
// //     "CardiacMedicine",
// //     "HighCholestrol",
// //     "Hypertension",
// //     "Osteoarthritis",
// //     "PainManagement",
// //     "EyeMedicine",
// //   ];

// //   bool isLoading = true;
// //   final TextEditingController searchController = TextEditingController();

// //   @override
// //   void initState() {
// //     super.initState();
// //     getStocklist();
// //     searchController.addListener(() {
// //       filterSearchResults(searchController.text);
// //     });
// //   }

// //   Future<void> getStocklist() async {
// //     try {
// //       for (String category in Categorylist) {
// //         log("Fetching category: $category");
// //         QuerySnapshot response =
// //             await FirebaseFirestore.instance.collection(category).get();

// //         for (var doc in response.docs) {
// //           int quantity = int.parse(doc['quantity']);
// //           bool alert = quantity < alertQuantity;

// //           stockList.add(StocklistModel(
// //             MedicineUrl: doc['medicineUrl'],
// //             MedicineName: doc['medicineName'],
// //             Rssss: doc['Rs'],
// //             expiry: doc['expiry'],
// //             Quantity: quantity,
// //             alert: alert,
// //           ));
// //         }
// //       }
// //       filteredStockList = List.from(stockList); // Initialize filtered list
// //     } catch (e) {
// //       log("Error fetching data: $e");
// //     } finally {
// //       setState(() {
// //         isLoading = false;
// //       });
// //     }
// //   }

// //   void filterSearchResults(String query) {
// //     if (query.isEmpty) {
// //       setState(() {
// //         filteredStockList = List.from(stockList);
// //       });
// //     } else {
// //       setState(() {
// //         filteredStockList = stockList
// //             .where((item) =>
// //                 item.MedicineName.toLowerCase().contains(query.toLowerCase()))
// //             .toList();
// //       });
// //     }
// //   }

// //   Widget stockCart(int index) {
// //     final item = filteredStockList[index];
// //     return Padding(
// //       padding: const EdgeInsets.all(10),
// //       child: Material(
// //         elevation: 8,
// //         borderRadius: BorderRadius.circular(15),
// //         shadowColor: Colors.blueGrey.shade100,
// //         child: InkWell(
// //           onTap: () {
// //             log("Tapped on ${item.MedicineName}");
// //           },
// //           borderRadius: BorderRadius.circular(15),
// //           child: Container(
// //             padding: const EdgeInsets.all(10),
// //             decoration: BoxDecoration(
// //               gradient: LinearGradient(
// //                 colors: item.alert
// //                     ? [
// //                         Colors.red.shade100,
// //                         Colors.red.shade300,
// //                       ]
// //                     : [
// //                         Colors.blue.shade50,
// //                         Colors.blue.shade200,
// //                       ],
// //                 begin: Alignment.topLeft,
// //                 end: Alignment.bottomRight,
// //               ),
// //               borderRadius: BorderRadius.circular(15),
// //             ),
// //             child: Row(
// //               children: [
// //                 ClipRRect(
// //                   borderRadius: BorderRadius.circular(15),
// //                   child: Image.network(
// //                     item.MedicineUrl,
// //                     width: 100,
// //                     height: 100,
// //                     fit: BoxFit.cover,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 10),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         item.MedicineName,
// //                         style: const TextStyle(
// //                           fontSize: 18,
// //                           fontWeight: FontWeight.w700,
// //                         ),
// //                       ),
// //                       const SizedBox(height: 5),
// //                       Row(
// //                         children: [
// //                           const Icon(Icons.currency_rupee, size: 18),
// //                           Text(
// //                             item.Rssss,
// //                             style: const TextStyle(
// //                               fontSize: 16,
// //                               fontWeight: FontWeight.w600,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 5),
// //                       Row(
// //                         children: [
// //                           const Icon(Icons.calendar_today, size: 18),
// //                           const SizedBox(width: 5),
// //                           Text(
// //                             "Expiry: ${item.expiry}",
// //                             style: const TextStyle(
// //                               fontSize: 14,
// //                               fontWeight: FontWeight.w500,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 5),
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           const Text(
// //                             "Available:",
// //                             style: TextStyle(
// //                               fontSize: 14,
// //                               fontWeight: FontWeight.w700,
// //                             ),
// //                           ),
// //                           Text(
// //                             "${item.Quantity} / 100",
// //                             style: TextStyle(
// //                               fontSize: 14,
// //                               fontWeight: FontWeight.w700,
// //                               color: item.alert
// //                                   ? const Color.fromARGB(255, 151, 16, 6)
// //                                   : Colors.black,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       if (item.alert)
// //                         Padding(
// //                           padding: const EdgeInsets.only(top: 10),
// //                           child: Row(
// //                             children: const [
// //                               Icon(Icons.warning,
// //                                   color: Color.fromARGB(255, 149, 21, 12),
// //                                   size: 18),
// //                               SizedBox(width: 5),
// //                               Text(
// //                                 "Alert: Low Stock",
// //                                 style: TextStyle(
// //                                   fontSize: 14,
// //                                   fontWeight: FontWeight.bold,
// //                                   color: Color.fromARGB(255, 156, 12, 2),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Stock List"),
// //         backgroundColor: Colors.blue,
// //       ),
// //       body: isLoading
// //           ? const Center(child: CircularProgressIndicator())
// //           : Padding(
// //               padding: const EdgeInsets.all(10),
// //               child: Column(
// //                 children: [
// //                   TextField(
// //                     controller: searchController,
// //                     decoration: InputDecoration(
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(10),
// //                       ),
// //                       hintText: "Search Product",
// //                       prefixIcon: const Icon(Icons.search),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 10),
// //                   Expanded(
// //                     child: filteredStockList.isNotEmpty
// //                         ? ListView.builder(
// //                             itemCount: filteredStockList.length,
// //                             itemBuilder: (context, index) => stockCart(index),
// //                           )
// //                         : const Center(
// //                             child: Text(
// //                               "No products found",
// //                               style: TextStyle(
// //                                 fontSize: 18,
// //                                 fontWeight: FontWeight.w500,
// //                               ),
// //                             ),
// //                           ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:developer';

// import 'model_class/stockList_model.dart';

// class StockList extends StatefulWidget {
//   const StockList({super.key});
//   @override
//   State createState() => _StockListState();
// }

// class _StockListState extends State {
//   List<StocklistModel> stockList = [];
//   List<StocklistModel> filteredStockList = [];
//   int alertQuantity = 30;

//   List<String> Categorylist = [
//     "CardiacMedicine",
//     "HighCholestrol",
//     "Hypertension",
//     "Osteoarthritis",
//     "PainManagement",
//     "EyeMedicine",
//   ];

//   bool isLoading = true;
//   final TextEditingController searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     getStocklist();
//     searchController.addListener(() {
//       filterSearchResults(searchController.text);
//     });
//   }

//   Future<void> getStocklist() async {
//     try {
//       for (String category in Categorylist) {
//         log("Fetching category: $category");
//         QuerySnapshot response =
//             await FirebaseFirestore.instance.collection(category).get();

//         for (var doc in response.docs) {
//           int quantity = int.parse(doc['quantity']);
//           bool alert = quantity < alertQuantity;

//           stockList.add(StocklistModel(
//             MedicineUrl: doc['medicineUrl'],
//             MedicineName: doc['medicineName'],
//             Rssss: doc['Rs'],
//             expiry: doc['expiry'],
//             Quantity: quantity,
//             alert: alert,
//           ));
//         }
//       }
//       filteredStockList = List.from(stockList); // Initialize filtered list
//     } catch (e) {
//       log("Error fetching data: $e");
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void filterSearchResults(String query) {
//     if (query.isEmpty) {
//       setState(() {
//         filteredStockList = List.from(stockList);
//       });
//     } else {
//       setState(() {
//         filteredStockList = stockList
//             .where((item) =>
//                 item.MedicineName.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       });
//     }
//   }

//   Widget stockCart(int index) {
//     final item = filteredStockList[index];
//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: Material(
//         elevation: 8,
//         borderRadius: BorderRadius.circular(15),
//         shadowColor: Colors.blueGrey.shade100,
//         child: InkWell(
//           onTap: () {
//             log("Tapped on ${item.MedicineName}");
//           },
//           borderRadius: BorderRadius.circular(15),
//           child: Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: item.alert
//                     ? [
//                         Colors.red.shade100,
//                         Colors.red.shade300,
//                       ]
//                     : [
//                         Colors.blue.shade50,
//                         Colors.blue.shade200,
//                       ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Row(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(15),
//                   child: Image.network(
//                     item.MedicineUrl,
//                     width: 100,
//                     height: 100,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         item.MedicineName,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Row(
//                         children: [
//                           const Icon(Icons.currency_rupee, size: 18),
//                           Text(
//                             item.Rssss,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 5),
//                       Row(
//                         children: [
//                           const Icon(Icons.calendar_today, size: 18),
//                           const SizedBox(width: 5),
//                           Text(
//                             "Expiry: ${item.expiry}",
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 5),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             "Available:",
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                           Text(
//                             "${item.Quantity} / 100",
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w700,
//                               color: item.alert
//                                   ? const Color.fromARGB(255, 151, 16, 6)
//                                   : Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                       if (item.alert)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: Row(
//                             children: const [
//                               Icon(Icons.warning,
//                                   color: Color.fromARGB(255, 149, 21, 12),
//                                   size: 18),
//                               SizedBox(width: 5),
//                               Text(
//                                 "Alert: Low Stock",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color.fromARGB(255, 156, 12, 2),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Stock List"),
//         backgroundColor: Colors.blue,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(10),
//               child: Column(
//                 children: [
//                   TextField(
//                     controller: searchController,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       hintText: "Search Product",
//                       prefixIcon: const Icon(Icons.search),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Expanded(
//                     child: filteredStockList.isNotEmpty
//                         ? ListView.builder(
//                             itemCount: filteredStockList.length,
//                             itemBuilder: (context, index) => stockCart(index),
//                           )
//                         : const Center(
//                             child: Text(
//                               "No products found",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:developer';

import 'model_class/stockList_model.dart';

class StockList extends StatefulWidget {
  const StockList({super.key});
  @override
  State createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  List<StocklistModel> stockList = [];
  List<StocklistModel> filteredStockList = [];
  int alertQuantity = 30;

  List<String> Categorylist = [
    "CardiacMedicine",
    "HighCholestrol",
    "Hypertension",
    "Osteoarthritis",
    "PainManagement",
    "EyeMedicine",
  ];

  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();

  // Audio player instance
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Set<String> alertedItems = {}; // Track already alerted items

  @override
  void initState() {
    super.initState();
    getStocklist();
    searchController.addListener(() {
      filterSearchResults(searchController.text);
    });
  }

  Future<void> playAlertSound() async {
    try {
      await _audioPlayer
          .setSource(AssetSource('assets/emergency.mp3')); // Load the sound
      await _audioPlayer.resume(); // Play the sound
    } catch (e) {
      log("Error playing sound: $e");
    }
  }

  Future<void> getStocklist() async {
    try {
      for (String category in Categorylist) {
        log("Fetching category: $category");
        QuerySnapshot response =
            await FirebaseFirestore.instance.collection(category).get();

        for (var doc in response.docs) {
          int quantity = int.parse(doc['quantity']);
          bool alert = quantity < alertQuantity;

          if (alert && !alertedItems.contains(doc.id)) {
            await playAlertSound(); // Play alert sound
            alertedItems.add(doc.id); // Mark this item as alerted
          }

          stockList.add(StocklistModel(
            MedicineUrl: doc['medicineUrl'],
            MedicineName: doc['medicineName'],
            Rssss: doc['Rs'],
            expiry: doc['expiry'],
            Quantity: quantity,
            alert: alert,
          ));
        }
      }
      filteredStockList = List.from(stockList); // Initialize filtered list
    } catch (e) {
      log("Error fetching data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredStockList = List.from(stockList);
      });
    } else {
      setState(() {
        filteredStockList = stockList
            .where((item) =>
                item.MedicineName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  Widget stockCart(int index) {
    final item = filteredStockList[index];
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(15),
        shadowColor: Colors.blueGrey.shade100,
        child: InkWell(
          onTap: () {
            log("Tapped on ${item.MedicineName}");
          },
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: item.alert
                    ? [
                        Colors.red.shade100,
                        Colors.red.shade300,
                      ]
                    : [
                        Colors.blue.shade50,
                        Colors.blue.shade200,
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    item.MedicineUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.MedicineName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.currency_rupee, size: 18),
                          Text(
                            item.Rssss,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18),
                          const SizedBox(width: 5),
                          Text(
                            "Expiry: ${item.expiry}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Available:",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "${item.Quantity} / 100",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: item.alert
                                  ? const Color.fromARGB(255, 151, 16, 6)
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      if (item.alert)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: const [
                              Icon(Icons.warning,
                                  color: Color.fromARGB(255, 149, 21, 12),
                                  size: 18),
                              SizedBox(width: 5),
                              Text(
                                "Alert: Low Stock",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 156, 12, 2),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock List"),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "Search Product",
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: filteredStockList.isNotEmpty
                        ? ListView.builder(
                            itemCount: filteredStockList.length,
                            itemBuilder: (context, index) => stockCart(index),
                          )
                        : const Center(
                            child: Text(
                              "No products found",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}


























// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:developer';

// import 'model_class/stockList_model.dart';

// class StockList extends StatefulWidget {
//   const StockList({super.key});
//   @override
//   State createState() => _StockListState();
// }

// class _StockListState extends State {
//   List<StocklistModel> stockList = [];
//   List<StocklistModel> filteredStockList = [];
//   int alertQuantity = 30;

//   List<String> Categorylist = [
//     "CardiacMedicine",
//     "HighCholestrol",
//     "Hypertension",
//     "Osteoarthritis",
//     "PainManagement",
//     "EyeMedicine",
//   ];

//   bool isLoading = true;
//   final TextEditingController searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     getStocklist();
//     searchController.addListener(() {
//       filterSearchResults(searchController.text);
//     });
//   }

//   Future<void> getStocklist() async {
//     try {
//       for (String category in Categorylist) {
//         log("Fetching category: $category");
//         QuerySnapshot response =
//             await FirebaseFirestore.instance.collection(category).get();

//         for (var doc in response.docs) {
//           int quantity = int.parse(doc['quantity']);
//           bool alert = quantity < alertQuantity;

//           stockList.add(StocklistModel(
//             MedicineUrl: doc['medicineUrl'],
//             MedicineName: doc['medicineName'],
//             Rssss: doc['Rs'],
//             expiry: doc['expiry'],
//             Quantity: quantity,
//             alert: alert,
//           ));
//         }
//       }
//       filteredStockList = List.from(stockList); // Initialize filtered list
//     } catch (e) {
//       log("Error fetching data: $e");
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void filterSearchResults(String query) {
//     if (query.isEmpty) {
//       setState(() {
//         filteredStockList = List.from(stockList);
//       });
//     } else {
//       setState(() {
//         filteredStockList = stockList
//             .where((item) =>
//                 item.MedicineName.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       });
//     }
//   }

//   Widget stockCart(int index) {
//     final item = filteredStockList[index];
//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: Material(
//         elevation: 8,
//         borderRadius: BorderRadius.circular(15),
//         shadowColor: Colors.blueGrey.shade100,
//         child: InkWell(
//           onTap: () {
//             log("Tapped on ${item.MedicineName}");
//           },
//           borderRadius: BorderRadius.circular(15),
//           child: Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: item.alert
//                     ? [
//                         Colors.red.shade100,
//                         Colors.red.shade300,
//                       ]
//                     : [
//                         Colors.blue.shade50,
//                         Colors.blue.shade200,
//                       ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Row(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(15),
//                   child: Image.network(
//                     item.MedicineUrl,
//                     width: 100,
//                     height: 100,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         item.MedicineName,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Row(
//                         children: [
//                           const Icon(Icons.currency_rupee, size: 18),
//                           Text(
//                             item.Rssss,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 5),
//                       Row(
//                         children: [
//                           const Icon(Icons.calendar_today, size: 18),
//                           const SizedBox(width: 5),
//                           Text(
//                             "Expiry: ${item.expiry}",
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 5),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             "Available:",
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                           Text(
//                             "${item.Quantity} / 100",
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w700,
//                               color: item.alert
//                                   ? const Color.fromARGB(255, 151, 16, 6)
//                                   : Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                       if (item.alert)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: Row(
//                             children: const [
//                               Icon(Icons.warning,
//                                   color: Color.fromARGB(255, 149, 21, 12),
//                                   size: 18),
//                               SizedBox(width: 5),
//                               Text(
//                                 "Alert: Low Stock",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color.fromARGB(255, 156, 12, 2),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Stock List"),
//         backgroundColor: Colors.blue,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(10),
//               child: Column(
//                 children: [
//                   TextField(
//                     controller: searchController,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       hintText: "Search Product",
//                       prefixIcon: const Icon(Icons.search),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Expanded(
//                     child: filteredStockList.isNotEmpty
//                         ? ListView.builder(
//                             itemCount: filteredStockList.length,
//                             itemBuilder: (context, index) => stockCart(index),
//                           )
//                         : const Center(
//                             child: Text(
//                               "No products found",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
