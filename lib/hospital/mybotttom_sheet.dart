import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:trackrx/hospital/Hypertension.dart';
import 'package:trackrx/hospital/antibiotics.dart';
import 'package:trackrx/hospital/cardiacPage.dart';
import 'package:trackrx/hospital/eye.dart';
import 'package:trackrx/hospital/high_cholesterol.dart';
import 'package:trackrx/hospital/model_class/medicineassignlist.dart';
import 'package:trackrx/hospital/osteoarthritis.dart';
import 'package:trackrx/hospital/painmanagement.dart';

///import 'package:trackrx/hospital/modelclassCardiac.dart';

class MyBottomSheet {
  static int Quantity = 1;

  List<dynamic> addToCartList = [];

  static void showAddCardBottomSheet(
      BuildContext context, dynamic data, String Typemedicine) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          "ADD TO CART",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Quantity = 0;
                            setState(() {});
                          },
                          child: const Text(
                            "Dismiss",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.yellow,
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Image.network(
                      data.MedicineUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    data.MedicineName,
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
                    data.Tablet,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "RS:${data.Rupes}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        data.Offer,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "Choose Quantity",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (Quantity > 0) {
                            Quantity--;
                          } else {
                            Quantity = 0;
                          }
                          setState(() {});
                        },
                        child: Container(
                          width: 50,
                          height: 30,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.blue)),
                          child: const Icon(
                            Icons.remove,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "$Quantity",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Quantity++;

                          setState(() {});
                        },
                        child: Container(
                          width: 50,
                          height: 30,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.blue)),
                          child: const Icon(
                            Icons.add,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      Medicineassignlist.selectedObject.add({
                        "medicineType": Typemedicine,
                        "medicineId": data.id,
                        "Quantity": Quantity,
                      });
                      Quantity = 1;

                      Navigator.of(context).pop();

                      setState(() {});
                      if (Typemedicine == "CardiacMedicine") {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return Cardiacpage();
                        }));
                      } else if (Typemedicine == "AntiboticsMedicine") {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return Antibiotics();
                        }));
                      } else if (Typemedicine == "EyeMedicine") {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return Eye();
                        }));
                      } else if (Typemedicine == "HighCholestrol") {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return HighCholesterol();
                        }));
                      } else if (Typemedicine == "Hypertension") {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return Hypertension();
                        }));
                      } else if (Typemedicine == "Osteoarthritis") {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return Osteoarthritis();
                        }));
                      } else {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return PainManagement();
                        }));
                      }

                      //  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                      //   return const Cardiacpage();
                      //  }));
                      //mySnackBar();
                    },
                    child: Container(
                      width: 250,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: const Text(
                          "ADD TO CART",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              );
            }),
          );
        });
  }
}
