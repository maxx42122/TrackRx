import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trackrx/hospital/model_class/all_medicine_model.dart';
import 'package:trackrx/hospital/model_class/medicineassignlist.dart';
//import 'package:trackrx/hospital/modelclassCardiac.dart';
import 'package:trackrx/hospital/mybotttom_sheet.dart';

import 'add_cart.dart';

class Cardiacpage extends StatefulWidget {
  const Cardiacpage({super.key});
  @override
  State createState() => _CardiacpageState();
}

class _CardiacpageState extends State {
//  bool likeColor = true;

  List<AllMedicineModel> CardiacList = [];

  TextEditingController MedicineURl = TextEditingController();
  TextEditingController MedicineNAME = TextEditingController();
  TextEditingController TabletNo = TextEditingController();
  TextEditingController MedicineBarnd = TextEditingController();
  TextEditingController RSSS = TextEditingController();
  TextEditingController MedicineOFFER = TextEditingController();
  TextEditingController MedicineExpiry = TextEditingController();

  int addMedicineCount = Medicineassignlist.selectedObject.length;

  //////initState()
  void initState() {
    super.initState();
    getMethod();

    log("$CardiacList");
    // setState(() {

    // });
  }
  /////////////////////////////////////////////////////

  ////get method///

  Future<void> getMethod() async {
    QuerySnapshot response =
        await FirebaseFirestore.instance.collection("CardiacMedicine").get();
    log("response:$response");

    for (int i = 0; i < response.docs.length; i++) {
      CardiacList.add(
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
      setState(() {});
    }
  }

  //////Cardiac Card////
  Padding CardiacCart(
    int index,
    BuildContext context,
  ) {
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
                        if (CardiacList[index].islike) {
                          CardiacList[index].islike = false;
                          setState(() {});
                        } else {
                          CardiacList[index].islike = true;
                          setState(() {});
                        }

                        //  log("IN likecolor:$likeColor");
                      },
                      child: (CardiacList[index].islike)
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
                  //  height: 120,
                  child: Image.network(
                    CardiacList[index].MedicineUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  CardiacList[index].MedicineName,
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
                  CardiacList[index].Tablet,
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
                    CardiacList[index].Brand,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "RS:${CardiacList[index].Rupes}",
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      CardiacList[index].Offer,
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
                  "Expiry:${CardiacList[index].Expiry}",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                // Spacer(),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      MyBottomSheet.showAddCardBottomSheet(
                          context, CardiacList[index], "CardiacMedicine");
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

////////////////////////////////////////////////////////////////////////////

  /// SnackBar///////////////////////
  void mySnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "Cart is Added",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cardiac",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          const Icon(
            Icons.search,
            color: Colors.white,
          ),
          const SizedBox(
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
                addMedicineCount = 0;
                setState(() {});
              },
              child: Column(
                children: [
                  (addMedicineCount == 0)
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
                              "$addMedicineCount",
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
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 3 columns
            childAspectRatio: 1 / 1.9, // Adjust aspect ratio as needed

            // crossAxisSpacing: 8.0, // Space between columns
            mainAxisSpacing: 0, // Space between rows
          ),
          itemCount: CardiacList.length,
          itemBuilder: (BuildContext context, int index) {
            return CardiacCart(index, context);
          }),
    );
  }
}
