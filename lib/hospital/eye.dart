import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trackrx/hospital/add_cart.dart';
import 'package:trackrx/hospital/model_class/all_medicine_model.dart';
import 'package:trackrx/hospital/model_class/medicineassignlist.dart';
//import 'package:trackrx/hospital/model_class/eye_model.dart';
import 'package:trackrx/hospital/mybotttom_sheet.dart';

class Eye extends StatefulWidget {
  const Eye({super.key});
  @override
  State createState() => _EyeState();
}

class _EyeState extends State {
  bool like = true;
  int addMedicineCountEye = Medicineassignlist.selectedObject.length;

  List<AllMedicineModel> EyeList = [];

  void initState() {
    super.initState();
    getMethod();
    setState(() {});
  }

  Padding EyeCart(int index) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Stack(
        children: [
          Container(
            width: 180,
            height: 370,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        if (like) {
                          like = false;
                          setState(() {});
                        } else {
                          like = true;
                          setState(() {});
                        }
                      },
                      child: (like)
                          ? const Icon(
                              Icons.favorite_outline,
                            )
                          : const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                ),
                Container(
                  width: 100,
                  // height: 120,
                  child: Image.network(
                    EyeList[index].MedicineUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Center(
                  child: Text(
                    EyeList[index].MedicineName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  EyeList[index].Tablet,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    EyeList[index].Brand,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "RS:${EyeList[index].Rupes}",
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      EyeList[index].Offer,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.brown,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Expiry:${EyeList[index].Expiry}",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                //  Spacer(),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      MyBottomSheet.showAddCardBottomSheet(
                          context, EyeList[index], "EyeMedicine");
                    },
                    child: Container(
                      width: 200,
                      height: 35,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: const Text(
                          "ADD TO CART",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 5,
            left: 5,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.red,
              ),
              child: const Text(
                "In Stock",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //////////////////////////////////////////////////////
  Future<void> getMethod() async {
    QuerySnapshot response =
        await FirebaseFirestore.instance.collection("EyeMedicine").get();
    //log("response:$response");

    for (int i = 0; i < response.docs.length; i++) {
      EyeList.add(
        AllMedicineModel(
            MedicineUrl: response.docs[i]['medicineUrl'],
            MedicineName: response.docs[i]['medicineName'],
            Tablet: response.docs[i]['tablet'],
            Brand: response.docs[i]['medicineBrand'],
            Rupes: response.docs[i]['Rs'],
            Offer: response.docs[i]['offer'],
            Expiry: response.docs[i]['expiry'],
            id: response.docs[i].id,
            islike: true),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Eye/Ear",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          Icon(
            Icons.search,
            color: Colors.white,
          ),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const AddCart();
                    },
                  ),
                );
                addMedicineCountEye = 0;
                setState(() {});
              },
              child: Column(
                children: [
                  (addMedicineCountEye == 0)
                      ? Container(
                          width: 30,
                          height: 20,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            //color: Colors.red,
                          ),
                          child: const Center(
                            child: Text(
                              "",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: 30,
                          height: 20,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: Center(
                            child: Text(
                              "$addMedicineCountEye",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                  const Icon(
                    Icons.shopping_cart,
                    color: Colors.red,
                  ),
                ],
              )),
        ],
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 3 columns
            childAspectRatio: 1 / 1.9, // Adjust aspect ratio as needed

            // crossAxisSpacing: 8.0, // Space between columns
            mainAxisSpacing: 0, // Space between rows
          ),
          itemCount: EyeList.length,
          itemBuilder: (BuildContext context, int index) {
            return EyeCart(index);
          }),
    );
  }
}
