import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:trackrx/AuthenticationPatient/SharedPrefencepatient.dart';
import 'package:trackrx/hospital/model_class/Particular_Patient_listmodel.dart';
import 'package:trackrx/hospital/model_class/assign_patinet_id.dart';
import 'package:trackrx/hospital/model_class/medicineassignlist.dart';

class PatientOrderList extends StatefulWidget {
  const PatientOrderList({super.key});

  @override
  State<PatientOrderList> createState() => _PatientOrderListState();
}

class _PatientOrderListState extends State<PatientOrderList> {
  List<ParticularPatientListmodel> PatientAssignMedicine = [];

  @override
  void initState() {
    super.initState();
    getAssignData();
    setState(() {});
  }

  Future<void> getAssignData() async {
    log("${AssignPatinetId.SelectedId}");
    log("${Sharedprefencepatient.Email}");

    DocumentSnapshot response = await FirebaseFirestore.instance
        .collection("AssignMedicine")
        .doc(AssignPatinetId.SelectedId)
        .get();

    for (int i = 0; i < response['cartItems'].length; i++) {
      PatientAssignMedicine.add(ParticularPatientListmodel(
          MedicineUrl: response['cartItems'][i]['MedicineURl'],
          MedicineName: response['cartItems'][i]['MedicineBName'],
          Rssss: response['cartItems'][i]['Rs'],
          expiry: response['cartItems'][i]['Expiry'],
          Quantity: response['cartItems'][i]['Quantity']));
    }
    setState(() {});
  }

  Padding patientListCart(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                // Implement delete action
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Material(
          elevation: 5, // Soft shadow
          borderRadius: BorderRadius.circular(12), // Rounded corners
          shadowColor: Colors.grey.withOpacity(0.4),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                // Medicine Image
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200]),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    PatientAssignMedicine[index].MedicineUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 15),
                // Medicine Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        PatientAssignMedicine[index].MedicineName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Quantity: ${PatientAssignMedicine[index].Quantity}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Rs: ${PatientAssignMedicine[index].Rssss}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Expiry: ${PatientAssignMedicine[index].expiry}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
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
        title: const Text(
          "Assign Medicine List",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search Medicine",
                hintStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              ),
            ),
          ),
          // Medicine List
          Expanded(
            child: ListView.builder(
              itemCount: PatientAssignMedicine.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return patientListCart(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
