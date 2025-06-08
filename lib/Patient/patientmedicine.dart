// // import 'dart:developer';

// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:trackrx/Patient/modelclass/patient_assignmedicine_model.dart';
// // import 'package:trackrx/hospital/model_class/assign_patinet_id.dart';
// // import 'package:trackrx/hospital/model_class/medicineassignlist.dart';

// // final currentUser = FirebaseAuth.instance.currentUser;
// // final currentUserEmail = currentUser?.email;

// // class Patientmedicine extends StatefulWidget {
// //   const Patientmedicine({super.key});

// //   @override
// //   State<Patientmedicine> createState() => _PatientmedicineState();
// // }

// // class _PatientmedicineState extends State<Patientmedicine> {
// //   List<PatientAssignmedicineModel> assignMedicine = [];
// //   int PatientTotalAmount = 0;

// //   @override
// //   void initState() {
// //     super.initState();
// //     getDataPatientdata();
// //     setState(() {});
// //   }

// //   Future<void> UpDataData() async {
// //     log("UPDATE DATA");

// //     for (int i = 0; i < Medicineassignlist.selectedObject.length; i++) {
// //       log("IN For loop");
// //       log("med type: ${Medicineassignlist.selectedObject[i]['medicineType']}");
// //       String collectionName =
// //           Medicineassignlist.selectedObject[i]['medicineType'];

// //       log("MED ID: ${Medicineassignlist.selectedObject[i]['medicineId']}");
// //       DocumentSnapshot data = await FirebaseFirestore.instance
// //           .collection(collectionName)
// //           .doc(Medicineassignlist.selectedObject[i]['medicineId'])
// //           .get();

// //       log("Quant  ${data['quantity']}");
// //       log("sel obj q: ${Medicineassignlist.selectedObject[i]['Quantity']}");

// //       String updataQuantity =
// //           " ${int.parse(data['quantity']) - Medicineassignlist.selectedObject[i]['Quantity'] as int}";

// //       log("+++++++++++++:$updataQuantity");

// //       Map<String, dynamic> Data = {'quantity': updataQuantity};

// //       await FirebaseFirestore.instance
// //           .collection(collectionName)
// //           .doc(Medicineassignlist.selectedObject[i]['medicineId'])
// //           .update(Data);

// //       setState(() {});
// //     }
// //   }

// //   Future<void> getDataPatientdata() async {
// //     if (currentUserEmail == null) {
// //       log("User is not logged in");
// //       return;
// //     }

// //     log("Fetching data for email: $currentUserEmail");

// //     try {
// //       DocumentSnapshot response = await FirebaseFirestore.instance
// //           .collection("AssignMedicine")
// //           .doc(currentUserEmail)
// //           .get();

// //       if (response.exists && response['cartItems'] != null) {
// //         for (var item in response['cartItems']) {
// //           assignMedicine.add(PatientAssignmedicineModel(
// //             MedicineURl: item['MedicineURl'],
// //             MedicineName: item['MedicineBName'],
// //             tablets: item['Tablets'],
// //             Rs: item['Rs'],
// //             Quantity: item['Quantity'],
// //             Expiry: item['Expiry'],
// //           ));
// //           log("Medicine: ${item['MedicineBName']} added.");
// //         }

// //         calculateTotalAmount();
// //       } else {
// //         log("No data found for the user.");
// //       }
// //     } catch (e) {
// //       log("Error fetching data: $e");
// //     }

// //     setState(() {});
// //   }

// //   void calculateTotalAmount() {
// //     PatientTotalAmount = 0;
// //     for (var medicine in assignMedicine) {
// //       // Directly use Quantity and Rs as they are already of type int
// //       PatientTotalAmount += medicine.Quantity * int.parse(medicine.Rs);
// //     }
// //     AssignPatinetId.TotalAmount = PatientTotalAmount;
// //     log("Total Amount: $PatientTotalAmount");
// //   }

// //   // Future<void> getDataPatientdata() async {
// //   //   log("Id :  ${AssignPatinetId.SelectedId}");
// //   //   DocumentSnapshot response = await FirebaseFirestore.instance
// //   //       .collection("AssignMedicine")
// //   //       .doc(AssignPatinetId.SelectedId)
// //   //       .get();

// //   //   log("============${response['cartItems']}");
// //   //   log("slelectid:======${AssignPatinetId.SelectedId}");

// //   //   for (int i = 0; i < response['cartItems'].length; i++) {
// //   //     assignMedicine.add(PatientAssignmedicineModel(
// //   //         MedicineURl: response['cartItems'][i]['MedicineURl'],
// //   //         MedicineName: response['cartItems'][i]['MedicineBName'],
// //   //         tablets: response['cartItems'][i]['Tablets'],
// //   //         Rs: response['cartItems'][i]['Rs'],
// //   //         Quantity: response['cartItems'][i]['Quantity'],
// //   //         Expiry: response['cartItems'][i]['Expiry']));

// //   //     log("+++++++++++++++++++++++++++++++++++:${response['cartItems'][i]['MedicineBName']}");
// //   //   }

// //   //   setState(() {});

// //   //   for (int i = 0; i < assignMedicine.length; i++) {
// //   //     PatientTotalAmount = int.parse("${assignMedicine[i].Quantity}") *
// //   //         (PatientTotalAmount + int.parse(assignMedicine[i].Rs));
// //   //     AssignPatinetId.TotalAmount = PatientTotalAmount;
// //   //     log("++++++++++++:${AssignPatinetId.TotalAmount}");
// //   //   }
// //   // }

// //   Padding patientCard(int index) {
// //     return Padding(
// //       padding: const EdgeInsets.all(10),
// //       child: Material(
// //         elevation: 8,
// //         borderRadius: BorderRadius.circular(10),
// //         shadowColor: Colors.grey.withOpacity(0.5),
// //         child: Container(
// //           padding: const EdgeInsets.all(10),
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(10),
// //           ),
// //           child: Row(
// //             children: [
// //               ClipRRect(
// //                 borderRadius: BorderRadius.circular(8),
// //                 child: Image.network(
// //                   assignMedicine[index].MedicineURl,
// //                   width: 80,
// //                   height: 80,
// //                   fit: BoxFit.cover,
// //                 ),
// //               ),
// //               const SizedBox(width: 15),
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       assignMedicine[index].MedicineName,
// //                       style: const TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 5),
// //                     Row(
// //                       children: [
// //                         const Icon(Icons.medication, size: 16),
// //                         const SizedBox(width: 5),
// //                         Text("Tablet: ${assignMedicine[index].tablets}"),
// //                       ],
// //                     ),
// //                     Row(
// //                       children: [
// //                         const Icon(Icons.add_shopping_cart, size: 16),
// //                         const SizedBox(width: 5),
// //                         Text("Quantity: ${assignMedicine[index].Quantity}"),
// //                       ],
// //                     ),
// //                     Row(
// //                       children: [
// //                         const Icon(Icons.money, size: 16),
// //                         const SizedBox(width: 5),
// //                         Text("Rs: ${assignMedicine[index].Rs}"),
// //                       ],
// //                     ),
// //                     Row(
// //                       children: [
// //                         const Icon(Icons.calendar_today, size: 16),
// //                         const SizedBox(width: 5),
// //                         Text("Expiry: ${assignMedicine[index].Expiry}"),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Medicine Details'),
// //         centerTitle: true,
// //       ),
// //       body: Column(
// //         children: [
// //           Image.asset("assets/patient/pexels-alex-green-5699515.jpg",
// //               height: 200, fit: BoxFit.cover),
// //           const SizedBox(height: 20),
// //           const Text(
// //             "Check Alternatives of Medicine",
// //             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// //           ),
// //           const SizedBox(height: 20),
// //           Expanded(
// //             child: ListView.builder(
// //               itemCount: assignMedicine.length,
// //               itemBuilder: (context, index) {
// //                 return patientCard(index);
// //               },
// //             ),
// //           ),
// //           Row(
// //             children: [
// //               Expanded(
// //                 child: Container(
// //                   padding: const EdgeInsets.all(15),
// //                   margin: const EdgeInsets.all(10),
// //                   decoration: BoxDecoration(
// //                     color: Colors.white,
// //                     borderRadius: BorderRadius.circular(10),
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: Colors.grey.withOpacity(0.5),
// //                         spreadRadius: 2,
// //                         blurRadius: 5,
// //                         offset: const Offset(0, 3),
// //                       ),
// //                     ],
// //                   ),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       const Icon(Icons.currency_rupee,
// //                           color: Colors.green, size: 24),
// //                       const SizedBox(width: 8),
// //                       Text(
// //                         "Total: Rs $PatientTotalAmount",
// //                         style: const TextStyle(
// //                           fontSize: 18,
// //                           fontWeight: FontWeight.bold,
// //                           color: Colors.black,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               GestureDetector(
// //                 onTap: () async {
// //                   await UpDataData();
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     const SnackBar(
// //                       content: Text("Medicine received"),
// //                       duration: Duration(seconds: 2),
// //                     ),
// //                   );
// //                   Future.delayed(const Duration(seconds: 2), () {
// //                     Navigator.of(context).pop();
// //                   });
// //                 },
// //                 child: Container(
// //                   padding:
// //                       const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
// //                   margin: const EdgeInsets.all(10),
// //                   decoration: BoxDecoration(
// //                     gradient: const LinearGradient(
// //                       colors: [Colors.blue, Colors.lightBlueAccent],
// //                       begin: Alignment.topLeft,
// //                       end: Alignment.bottomRight,
// //                     ),
// //                     borderRadius: BorderRadius.circular(10),
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: Colors.blue.withOpacity(0.5),
// //                         spreadRadius: 2,
// //                         blurRadius: 5,
// //                         offset: const Offset(0, 3),
// //                       ),
// //                     ],
// //                   ),
// //                   child: const Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Icon(Icons.done, color: Colors.white, size: 24),
// //                       SizedBox(width: 8),
// //                       Text(
// //                         "Done",
// //                         style: TextStyle(
// //                           fontSize: 18,
// //                           fontWeight: FontWeight.bold,
// //                           color: Colors.white,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:trackrx/Patient/modelclass/patient_assignmedicine_model.dart';
// import 'package:trackrx/hospital/model_class/assign_patinet_id.dart';
// import 'package:trackrx/hospital/model_class/medicineassignlist.dart';

// class Patientmedicine extends StatefulWidget {
//   const Patientmedicine({super.key});

//   @override
//   State<Patientmedicine> createState() => _PatientmedicineState();
// }

// class _PatientmedicineState extends State<Patientmedicine> {
//   List<PatientAssignmedicineModel> assignMedicine = [];
//   int PatientTotalAmount = 0;

//   @override
//   void initState() {
//     super.initState();
//     getDataPatientdata();
//     setState(() {});
//   }

//   Future<void> UpDataData() async {
//     log("UPDATE DATA");

//     for (int i = 0; i < Medicineassignlist.selectedObject.length; i++) {
//       log("IN For loop");
//       log("med type: ${Medicineassignlist.selectedObject[i]['medicineType']}");
//       String collectionName =
//           Medicineassignlist.selectedObject[i]['medicineType'];

//       log("MED ID: ${Medicineassignlist.selectedObject[i]['medicineId']}");
//       DocumentSnapshot data = await FirebaseFirestore.instance
//           .collection(collectionName)
//           .doc(Medicineassignlist.selectedObject[i]['medicineId'])
//           .get();

//       log("Quant  ${data['quantity']}");
//       log("sel obj q: ${Medicineassignlist.selectedObject[i]['Quantity']}");

//       String updataQuantity =
//           " ${int.parse(data['quantity']) - Medicineassignlist.selectedObject[i]['Quantity'] as int}";

//       log("+++++++++++++:$updataQuantity");

//       Map<String, dynamic> Data = {'quantity': updataQuantity};

//       await FirebaseFirestore.instance
//           .collection(collectionName)
//           .doc(Medicineassignlist.selectedObject[i]['medicineId'])
//           .update(Data);

//       setState(() {});
//     }
//   }

//   Future<void> getDataPatientdata() async {
//     log("Id :  ${AssignPatinetId.SelectedId}");
//     DocumentSnapshot response = await FirebaseFirestore.instance
//         .collection("AssignMedicine")
//         .doc(AssignPatinetId.SelectedId)
//         .get();

//     log("============${response['cartItems']}");
//     log("slelectid:======${AssignPatinetId.SelectedId}");

//     for (int i = 0; i < response['cartItems'].length; i++) {
//       assignMedicine.add(PatientAssignmedicineModel(
//           MedicineURl: response['cartItems'][i]['MedicineURl'],
//           MedicineName: response['cartItems'][i]['MedicineBName'],
//           tablets: response['cartItems'][i]['Tablets'],
//           Rs: response['cartItems'][i]['Rs'],
//           Quantity: response['cartItems'][i]['Quantity'],
//           Expiry: response['cartItems'][i]['Expiry']));

//       log("+++++++++++++++++++++++++++++++++++:${response['cartItems'][i]['MedicineBName']}");
//     }

//     setState(() {});

//     for (int i = 0; i < assignMedicine.length; i++) {
//       PatientTotalAmount = int.parse("${assignMedicine[i].Quantity}") *
//           (PatientTotalAmount + int.parse(assignMedicine[i].Rs));
//       AssignPatinetId.TotalAmount = PatientTotalAmount;
//       log("++++++++++++:${AssignPatinetId.TotalAmount}");
//     }
//   }

//   Padding patientCard(int index) {
//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: Material(
//         elevation: 8,
//         borderRadius: BorderRadius.circular(10),
//         shadowColor: Colors.grey.withOpacity(0.5),
//         child: Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Row(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.network(
//                   assignMedicine[index].MedicineURl,
//                   width: 80,
//                   height: 80,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               const SizedBox(width: 15),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       assignMedicine[index].MedicineName,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Row(
//                       children: [
//                         const Icon(Icons.medication, size: 16),
//                         const SizedBox(width: 5),
//                         Text("Tablet: ${assignMedicine[index].tablets}"),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         const Icon(Icons.add_shopping_cart, size: 16),
//                         const SizedBox(width: 5),
//                         Text("Quantity: ${assignMedicine[index].Quantity}"),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         const Icon(Icons.money, size: 16),
//                         const SizedBox(width: 5),
//                         Text("Rs: ${assignMedicine[index].Rs}"),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         const Icon(Icons.calendar_today, size: 16),
//                         const SizedBox(width: 5),
//                         Text("Expiry: ${assignMedicine[index].Expiry}"),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Medicine Details'),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Image.asset("assets/patient/pexels-alex-green-5699515.jpg",
//               height: 200, fit: BoxFit.cover),
//           const SizedBox(height: 20),
//           const Text(
//             "Check Alternatives of Medicine",
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: ListView.builder(
//               itemCount: assignMedicine.length,
//               itemBuilder: (context, index) {
//                 return patientCard(index);
//               },
//             ),
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   padding: const EdgeInsets.all(15),
//                   margin: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(Icons.attach_money,
//                           color: Colors.green, size: 24),
//                       const SizedBox(width: 8),
//                       Text(
//                         "Total: Rs $PatientTotalAmount",
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () async {
//                   await UpDataData();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text("Medicine received"),
//                       duration: Duration(seconds: 2),
//                     ),
//                   );
//                   Future.delayed(const Duration(seconds: 2), () {
//                     Navigator.of(context).pop();
//                   });
//                 },
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//                   margin: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Colors.blue, Colors.lightBlueAccent],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.blue.withOpacity(0.5),
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.done, color: Colors.white, size: 24),
//                       SizedBox(width: 8),
//                       Text(
//                         "Done",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trackrx/Patient/modelclass/patient_assignmedicine_model.dart';
import 'package:trackrx/hospital/model_class/assign_patinet_id.dart';
import 'package:trackrx/hospital/model_class/medicineassignlist.dart';

class Patientmedicine extends StatefulWidget {
  const Patientmedicine({super.key});

  @override
  State<Patientmedicine> createState() => _PatientmedicineState();
}

class _PatientmedicineState extends State<Patientmedicine> {
  List<PatientAssignmedicineModel> assignMedicine = [];
  int PatientTotalAmount = 0;

  @override
  void initState() {
    super.initState();
    getDataPatientdata();
    setState(() {});
  }

  Future<void> UpDataData() async {
    log("UPDATE DATA");

    for (int i = 0; i < Medicineassignlist.selectedObject.length; i++) {
      log("IN For loop");
      log("med type: ${Medicineassignlist.selectedObject[i]['medicineType']}");
      String collectionName =
          Medicineassignlist.selectedObject[i]['medicineType'];

      log("MED ID: ${Medicineassignlist.selectedObject[i]['medicineId']}");
      DocumentSnapshot data = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(Medicineassignlist.selectedObject[i]['medicineId'])
          .get();

      log("Quant  ${data['quantity']}");
      log("sel obj q: ${Medicineassignlist.selectedObject[i]['Quantity']}");

      // String updataQuantity =
      //     " ${int.parse(data['quantity']) - Medicineassignlist.selectedObject[i]['Quantity'] as int}";
      String updataQuantity =
          " ${int.parse(data['quantity']) - Medicineassignlist.selectedObject[i]['Quantity'] as int}";

      log("+++++++++++++:$updataQuantity");

      Map<String, dynamic> Data = {'quantity': updataQuantity};

      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(Medicineassignlist.selectedObject[i]['medicineId'])
          .update(Data);

      setState(() {});
    }
  }

  // Future<void> getDataPatientdata() async {
  //   log("Id :  ${AssignPatinetId.SelectedId}");
  //   DocumentSnapshot response = await FirebaseFirestore.instance
  //       .collection("AssignMedicine")
  //       .doc(AssignPatinetId.SelectedId)
  //       .get();
  //   log("Id :  ${AssignPatinetId.SelectedId}");

  //   log("============${response['cartItems']}");
  //   log("slelectid:======${AssignPatinetId.SelectedId}");

  //   for (int i = 0; i < response['cartItems'].length; i++) {
  //     assignMedicine.add(PatientAssignmedicineModel(
  //         MedicineURl: response['cartItems'][i]['MedicineURl'],
  //         MedicineName: response['cartItems'][i]['MedicineBName'],
  //         tablets: response['cartItems'][i]['Tablets'],
  //         Rs: response['cartItems'][i]['Rs'],
  //         Quantity: response['cartItems'][i]['Quantity'],
  //         Expiry: response['cartItems'][i]['Expiry']));

  //     log("+++++++++++++++++++++++++++++++++++:${response['cartItems'][i]['MedicineBName']}");
  //   }

  //   setState(() {});

  //   for (int i = 0; i < assignMedicine.length; i++) {
  //     PatientTotalAmount = int.parse("${assignMedicine[i].Quantity}") *
  //         (PatientTotalAmount + int.parse(assignMedicine[i].Rs));
  //     AssignPatinetId.TotalAmount = PatientTotalAmount;
  //     log("++++++++++++:${AssignPatinetId.TotalAmount}");
  //   }
  // }
  Future<void> getDataPatientdata() async {
    log("Id :  ${AssignPatinetId.SelectedId}");
    DocumentSnapshot response = await FirebaseFirestore.instance
        .collection("AssignMedicine")
        .doc(AssignPatinetId.SelectedId)
        .get();
    log("Id :  ${AssignPatinetId.SelectedId}");

    // Check if the document exists and contains the 'cartItems' field
    if (response.exists && response.data() != null) {
      var cartItems = response['cartItems'];
      if (cartItems != null && cartItems is List) {
        for (int i = 0; i < cartItems.length; i++) {
          assignMedicine.add(PatientAssignmedicineModel(
              MedicineURl: cartItems[i]['MedicineURl'],
              MedicineName: cartItems[i]['MedicineBName'],
              tablets: cartItems[i]['Tablets'],
              Rs: cartItems[i]['Rs'],
              Quantity: cartItems[i]['Quantity'],
              Expiry: cartItems[i]['Expiry']));

          log("+++++++++++++++++++++++++++++++++++:${cartItems[i]['MedicineBName']}");
        }
      } else {
        log("No cartItems found or cartItems is not a List.");
      }
    } else {
      log("Document does not exist or data is null.");
    }

    setState(() {});

    // Calculate total amount based on retrieved data
    for (int i = 0; i < assignMedicine.length; i++) {
      PatientTotalAmount += int.parse("${assignMedicine[i].Quantity}") *
          int.parse(assignMedicine[i].Rs);
      AssignPatinetId.TotalAmount = PatientTotalAmount;
      log("++++++++++++:${AssignPatinetId.TotalAmount}");
    }
  }

  // Padding patientCard(int index) {
  //   return Padding(
  //     padding: const EdgeInsets.all(10),
  //     child: Material(
  //       elevation: 8,
  //       borderRadius: BorderRadius.circular(10),
  //       shadowColor: Colors.grey.withOpacity(0.5),
  //       child: Container(
  //         padding: const EdgeInsets.all(10),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         child: Row(
  //           children: [
  //             ClipRRect(
  //               borderRadius: BorderRadius.circular(8),
  //               child: Image.network(
  //                 assignMedicine[index].MedicineURl,
  //                 width: 80,
  //                 height: 80,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             const SizedBox(width: 15),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     assignMedicine[index].MedicineName,
  //                     style: const TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 5),
  //                   Row(
  //                     children: [
  //                       const Icon(Icons.medication, size: 16),
  //                       const SizedBox(width: 5),
  //                       Text("Tablet: ${assignMedicine[index].tablets}"),
  //                     ],
  //                   ),
  //                   Row(
  //                     children: [
  //                       const Icon(Icons.add_shopping_cart, size: 16),
  //                       const SizedBox(width: 5),
  //                       Text("Quantity: ${assignMedicine[index].Quantity}"),
  //                     ],
  //                   ),
  //                   Row(
  //                     children: [
  //                       const Icon(Icons.money, size: 16),
  //                       const SizedBox(width: 5),
  //                       Text("Rs: ${assignMedicine[index].Rs}"),
  //                     ],
  //                   ),
  //                   Row(
  //                     children: [
  //                       const Icon(Icons.calendar_today, size: 16),
  //                       const SizedBox(width: 5),
  //                       Text("Expiry: ${assignMedicine[index].Expiry}"),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Padding patientCard(int index) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(10),
        shadowColor: Colors.grey.withOpacity(0.5),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  assignMedicine[index].MedicineURl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assignMedicine[index].MedicineName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    _buildRow(Icons.medication,
                        "Tablet: ${assignMedicine[index].tablets}"),
                    _buildRow(Icons.add_shopping_cart,
                        "Quantity: ${assignMedicine[index].Quantity}"),
                    _buildRow(Icons.money, "Rs: ${assignMedicine[index].Rs}"),
                    _buildRow(Icons.calendar_today,
                        "Expiry: ${assignMedicine[index].Expiry}"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 5),
        Expanded(child: Text(text, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Details'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Image.asset("assets/patient/pexels-alex-green-5699515.jpg",
              height: 200, fit: BoxFit.cover),
          const SizedBox(height: 20),
          const Text(
            "Check Alternatives of Medicine",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: assignMedicine.length,
              itemBuilder: (context, index) {
                return patientCard(index);
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.currency_rupee,
                          color: Colors.green, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        "Total: Rs $PatientTotalAmount",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await UpDataData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Medicine received"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.of(context).pop();
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.lightBlueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.done, color: Colors.white, size: 24),
                      SizedBox(width: 8),
                      Text(
                        "Done",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
