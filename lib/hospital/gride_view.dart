import 'dart:developer';

import 'package:flutter/material.dart';

class MyGrideView extends StatefulWidget {
  const MyGrideView({super.key});

  @override
  State<MyGrideView> createState() => _GrideViewState();
}

class _GrideViewState extends State<MyGrideView> {
  bool likeColor = true;

  Padding CardiacCart(int index) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Stack(
        children: [
          Container(
            width: 180,
            height: 370,
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        if (likeColor) {
                          likeColor = false;
                          setState(() {});
                        } else {
                          likeColor = true;
                          setState(() {});
                        }
                      },
                      child: (likeColor)
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
                SizedBox(
                  width: 100,
                  //  height: 120,
                  child: Image.network(
                    "https://tse4.mm.bing.net/th?id=OIP.E9aMpnNHkcUptj-QnNxU4wHaG8&pid=Api&P=0&h=180",
                    fit: BoxFit.cover,
                  ),
                ),
                const Text(
                  "VERAPRES 120 SR TABLET",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Strip of 10 Tablets",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Verapamil 120 mg",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      " RS:65",
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "34% OFF",
                      style: TextStyle(
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
                const Text(
                  "Expiry:05/2025",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      // showAddCardBottomSheet();
                    },
                    child: Container(
                      width: 200,
                      height: 35,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: Text(
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
              padding: const EdgeInsets.all(2),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 3 columns
            childAspectRatio: 1 / 1.7, // Adjust aspect ratio as needed

            // crossAxisSpacing: 8.0, // Space between columns
            mainAxisSpacing: 0, // Space between rows
          ),
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            log("hhh");
            return CardiacCart(index);
          }),
    );
  }
}

// import 'package:flutter/material.dart';

// class HomeScreen extends StatelessWidget {
//   HomeScreen({Key? key}) : super(key: key);

//   final List<Map> myProducts =
//       List.generate(100000, (index) => {"id": index, "name": "Product $index"})
//           .toList();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Kindacode.com'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         // implement GridView.builder
//         child: GridView.builder(
//             gridDelegate:SilverGridDelegateWithFixedCrossAxsCount(
                
//                 childAspectRatio: 3 / 2,
//                 crossAxisSpacing: 20,
//                 mainAxisSpacing: 20),
//             itemCount: myProducts.length,
//             itemBuilder: (BuildContext ctx, index) {
//               return Container(
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                     color: Colors.amber,
//                     borderRadius: BorderRadius.circular(15)),
//                 child: Text(myProducts[index]["name"]),
//               );
//             }),
//       ),
//     );
//   }
// }