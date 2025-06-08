import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'bottomnavigationbar.dart';

class cart extends StatefulWidget {
  const cart({super.key});

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {
  bool x = false;
  int num = 0;

  Future<File?> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();

    // Pick an image
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path); // Return the selected image file
    } else {
      return null; // Return null if no image was picked
    }
  }

  List<Color> colors = <Color>[
    // Color.fromRGBO(250, 232, 232, 1),
    const Color.fromRGBO(232, 237, 250, 1),
    // const Color.fromRGBO(250, 249, 232, 1),
    // const Color.fromRGBO(250, 232, 250, 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0), // Height of the underline
          child: Container(
            color: const Color.fromARGB(
                255, 143, 148, 150), // Color of the underline
            height: 2.0, // Thickness of the underline
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int Index) {
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: colors[Index % colors.length],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          height: 66,
                                          width: 66,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: Image.asset(
                                              "assets/patient/systane_hydration_10ml_eye_drops.png"),
                                          // child: Image.asset(
                                          //   "assets/screen.jpg",
                                          // ),
                                        ),
                                      ),
                                      const Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Lorem Ipsum is simply setting industry.",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                "1 Bottle of 20 ml",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromRGBO(
                                                        84, 84, 84, 1)),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        const Text(
                                          "\$ 115.00",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            if (num != 0) {
                                              num--;
                                            }
                                            setState(() {});
                                          },
                                          child: Container(
                                            height: 22,
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  2, 167, 177, 1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.remove,
                                              color: Color.fromRGBO(
                                                  253, 253, 253, 1),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Text(
                                            "$num",
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            num++;
                                            setState(() {});
                                          },
                                          child: Container(
                                            height: 22,
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  2, 167, 177, 1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              color: Color.fromRGBO(
                                                  253, 253, 253, 1),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 20,
                          child: GestureDetector(
                            onTap: () {
                              if (num != 0) {
                                num--;
                              }
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Color.fromRGBO(140, 137, 137, 1),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: GestureDetector(
                onTap: () async {
                  await pickImageFromGallery();
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 20, 95, 166)),
                    color: const Color.fromRGBO(232, 237, 250, 1),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.camera_alt,
                        color: Color.fromARGB(255, 20, 95, 166),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "     Upload \n Prescription ",
                        style: TextStyle(
                            color: Color.fromARGB(255, 20, 95, 166),
                            fontSize: 15),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 60,
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 20, 95, 166),
              ),
              child: const Row(
                children: [
                  Text(
                    "NET  ",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    "\$",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    "333",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Spacer(),
                  Text(
                    "Checkout",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: Colors.white,
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarUI(),
    );
  }
}
