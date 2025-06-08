import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trackrx/Patient/patientmedicine.dart';
import 'package:trackrx/hospital/homepage.dart';
import 'package:trackrx/hospital/listpatient.dart';
import 'package:trackrx/hospital/model_class/add_to_cart_medicine_model.dart';
import 'package:trackrx/hospital/model_class/assign_patinet_id.dart';
import 'package:trackrx/hospital/model_class/medicineassignlist.dart';
import 'package:trackrx/hospital/model_class/my_snackbar_modelclass.dart';

class AddCart extends StatefulWidget {
  const AddCart({super.key});
  @override
  State createState() => _AddCartState();
}

class _AddCartState extends State {
  static int totalAmount = 0;

  List<AddToCartMedicineModel> addMedicine = [];

  ////////////////////// initState() metthod///////////////
  @override
  void initState() {
    super.initState();
    getData();
  }

//// get data to the medicineassign list/////
  Future<void> getData() async {
    for (int i = 0; i < Medicineassignlist.selectedObject.length; i++) {
      String collectionName =
          Medicineassignlist.selectedObject[i]['medicineType'];

      DocumentSnapshot data = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(Medicineassignlist.selectedObject[i]['medicineId'])
          .get();

      totalAmount = Medicineassignlist.selectedObject[i]['Quantity'] *
          (totalAmount + int.parse(data['Rs']));
      //AssignPatinetId.TotalAmount!=totalAmount;
      addMedicine.add(AddToCartMedicineModel(
          medicineURL: data['medicineUrl'],
          MedicineName: data['medicineName'],
          Rupes: data['Rs'],
          MedicineOffer: data['offer'],
          MDQuantity: Medicineassignlist.selectedObject[i]['Quantity'],
          tablet: data['tablet'],
          Expiry: data['expiry']));
      setState(() {});
    }
  }

  Padding AddToCart(int index) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        elevation: 10, // Add elevation
        borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
        shadowColor: Colors.grey,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Image.network(
                  addMedicine[index].medicineURL,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      addMedicine[index].MedicineName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      addMedicine[index].tablet,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Rs:${addMedicine[index].Rupes}",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          addMedicine[index].MedicineOffer,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: Colors.brown,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Expiry: ${addMedicine[index].Expiry}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Quantity :",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Container(
                          width: 40,
                          height: 25,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Center(
                            child: Text(
                              "${addMedicine[index].MDQuantity}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),

                        // const SizedBox(
                        //   width:,
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
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
          "ADD CART",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.blue,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemCount: addMedicine.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return AddToCart(index);
                }),
          ),

          // Spacer(),

          Row(
            children: [
              Container(
                width: 205,
                height: 50,
                color: Colors.white,
                child: Center(
                  child: Text(
                    "Rs:$totalAmount",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  try {
                    // Prepare data for Firestore
                    Map<String, List<Map>> data = {};
                    List<Map> medData = [];
                    for (int i = 0; i < addMedicine.length; i++) {
                      medData.add({
                        "MedicineURl": addMedicine[i].medicineURL,
                        "MedicineBName": addMedicine[i].MedicineName,
                        'Tablets': addMedicine[i].tablet,
                        'Rs': addMedicine[i].Rupes,
                        'Expiry': addMedicine[i].Expiry,
                        "Quantity": Medicineassignlist.selectedObject[i]
                            ['Quantity'],
                      });
                    }

                    data['cartItems'] = medData;

                    // Save the cart items to Firestore
                    await FirebaseFirestore.instance
                        .collection("AssignMedicine")
                        .doc(AssignPatinetId.SelectedId)
                        .set(data);

                    // Show success message
                    MySnackbarModelclass.snakbarmethod(context,
                        "Medicine is Successfully Added to the Patient");

                    // Clear the list and reset the total amount
                    setState(() {
                      addMedicine.clear();
                      totalAmount = 0;
                    });

                    // Navigate to the homepage
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) {
                      return const Homepage();
                    }));
                  } catch (e) {
                    log("Error while processing the cart: $e");
                    MySnackbarModelclass.snakbarmethod(
                        context, "Failed to add medicines. Please try again.");
                  }
                },
                child: Container(
                  width: 205,
                  height: 50,
                  color: Colors.blue,
                  child: const Center(
                    child: Text(
                      "Proceed",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
