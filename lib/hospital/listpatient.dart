import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:trackrx/hospital/model_class/assign_patinet_id.dart';
import 'package:trackrx/hospital/model_class/patient_model.dart';
import 'package:trackrx/hospital/patient_order_list.dart';
import 'package:trackrx/hospital/productcategory.dart';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:trackrx/hospital/model_class/assign_patinet_id.dart';
import 'package:trackrx/hospital/model_class/patient_model.dart';
import 'package:trackrx/hospital/patient_order_list.dart';
import 'package:trackrx/hospital/productcategory.dart';

class Listpatient extends StatefulWidget {
  const Listpatient({super.key});

  @override
  State<Listpatient> createState() => _ListpatientState();
}

class _ListpatientState extends State<Listpatient> {
  final List<LinearGradient> gradients = [
    const LinearGradient(
      colors: [
        Color.fromARGB(255, 179, 222, 246),
        Color.fromARGB(255, 105, 190, 180),
        Color.fromARGB(255, 69, 145, 185),
        Color.fromARGB(255, 49, 180, 195),
        Color.fromARGB(255, 85, 192, 250),
        Color.fromARGB(255, 179, 222, 246),
        Color.fromARGB(255, 105, 190, 180),
        Color.fromARGB(255, 69, 145, 185),
        Color.fromARGB(255, 49, 180, 195),
        Color.fromARGB(255, 85, 192, 250),
        Color.fromARGB(255, 179, 222, 246),
        Color.fromARGB(255, 105, 190, 180),
        Color.fromARGB(255, 69, 145, 185),
        Color.fromARGB(255, 49, 180, 195),
        Color.fromARGB(255, 85, 192, 250),
      ], // Peach

      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color.fromARGB(255, 138, 245, 255), Color(0xFFF6FFED)], // Mint
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [
        Color.fromARGB(255, 221, 126, 232),
        Color(0xFFF7E7FF)
      ], // Lavender
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [
        Color.fromARGB(255, 237, 137, 165),
        Color(0xFFFFF9E6)
      ], // Soft Yellow
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];

  Widget patientCard(PatientModel patient, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          // Optional card tap action
        },
        child: Material(
          elevation: 18,
          borderRadius: BorderRadius.circular(15),
          shadowColor: const Color.fromARGB(255, 0, 47, 255).withOpacity(0.2),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: gradients[index % gradients.length],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Image.network(
                          patient.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person,
                                size: 50, color: Colors.grey);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Name: ',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                children: [
                                  TextSpan(
                                    text: patient.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            RichText(
                              text: TextSpan(
                                text: 'Age: ',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: patient.age,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Color.fromARGB(255, 27, 27, 27),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            RichText(
                              text: TextSpan(
                                text: 'Gender: ',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 19, 19, 19),
                                ),
                                children: [
                                  TextSpan(
                                    text: patient.gender,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Color.fromARGB(255, 21, 21, 21),
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
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ElevatedButton.icon(
                      //   onPressed: () {
                      //     AssignPatinetId.SelectedId = patient.name;
                      //     Navigator.of(context).push(
                      //       MaterialPageRoute(builder: (context) {
                      //         return const PatientOrderList();
                      //       }),
                      //     );
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Colors.blueAccent,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 15, vertical: 10),
                      //   ),
                      //   icon: const Icon(
                      //     Icons.history,
                      //     size: 18,
                      //     color: Colors.white,
                      //   ),
                      //   label: const Text(
                      //     "Patient History",
                      //     style: TextStyle(fontSize: 14, color: Colors.white),
                      //   ),
                      // ),
                      ElevatedButton.icon(
                        onPressed: () {
                          AssignPatinetId.SelectedId = patient.email;
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return const Productcategory();
                            }),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                        ),
                        icon: const Icon(
                          Icons.medical_services,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Assign Medicine",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
        title: const Text("Patients List"),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("user").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading patients"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Patients Found"));
          }

          List<PatientModel> patients = snapshot.data!.docs.map((doc) {
            return PatientModel(
              name: doc['name'] ?? "No Name",
              email: doc['email'] ?? "No Email",
              age: doc['age'] ?? "Unknown Age",
              imageUrl: doc['imageUrl'] ?? "",
              gender: doc['gender'] ?? "Unknown Gender",
            );
          }).toList();

          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) =>
                patientCard(patients[index], index),
          );
        },
      ),
    );
  }
}
