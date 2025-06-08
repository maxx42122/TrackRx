import 'package:flutter/material.dart';
import 'package:trackrx/hospital/model_class/Alertlist_model.dart';

import 'model_class/add_stock_model.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});
  @override
  State createState() => _AlertPageState();
}

class _AlertPageState extends State {
  //static  List<String > stckData = [];

  void snackbar() {
    SnackBar bar = SnackBar(
      content: Row(
        children: [
          const Text(
            "Request is accepted",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          GestureDetector(onTap: () {}, child: const Icon(Icons.close)),
        ],
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      duration: const Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(13),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }

  // Padding requestCard(int index) {
  //   return Padding(
  //     padding: const EdgeInsets.all(10),
  //     child: Container(
  //       // width: 100,
  //       // height: 100,
  //       padding: EdgeInsets.all(10),
  //       decoration: BoxDecoration(
  //         color: const Color.fromRGBO(255, 171, 159, 159),
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: GestureDetector(
  //         onTap: () {
  //           print("value:${stckData[index].destination}");
  //         },
  //         child: Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const Text(
  //                 "Inventory Name:Omkar Inventory",
  //                 style: const TextStyle(
  //                   fontSize: 15,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //               Text(
  //                 "Medicine Name=${stckData[index].MdName}",
  //                 style: const TextStyle(
  //                   fontSize: 15,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),

  //               Text(
  //                 "Destination =${stckData[index].destination}",
  //                 style: const TextStyle(
  //                   fontSize: 15,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),

  //               //  const  Spacer(),
  //               Text(
  //                 "Received Date :${stckData[index].recevied}",
  //                 style: const TextStyle(
  //                   fontSize: 15,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //                 // maxLines: 5,
  //               ),

  //               Row(
  //                 children: [
  //                   const Spacer(),
  //                   Text(
  //                     "Quantity :${stckData[index].quantity}",
  //                     style: const TextStyle(
  //                       fontSize: 15,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(
  //                 height: 5,
  //               ),

  //               Row(
  //                 children: [
  //                   GestureDetector(
  //                     onTap: () {},
  //                     child: Container(
  //                       padding: EdgeInsets.all(5),
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(12),
  //                         color: Colors.blue,
  //                       ),
  //                       child: const Text(
  //                         "Dismiss",
  //                         style: TextStyle(
  //                           fontSize: 15,
  //                           fontWeight: FontWeight.w900,
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   const Spacer(),
  //                   GestureDetector(
  //                     onTap: () {
  //                       snackbar();
  //                     },
  //                     child: Container(
  //                       padding: const EdgeInsets.all(5),
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(12),
  //                         color: Colors.blue,
  //                       ),
  //                       child: const Text(
  //                         "Accept",
  //                         style: TextStyle(
  //                           fontSize: 15,
  //                           fontWeight: FontWeight.w900,
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Padding RequestCart(int index) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        elevation: 8.0, // Add elevation
        borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
        shadowColor: Colors.green,
        child: Container(
          // width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),

          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(8)),

          child: Row(
            children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.warning,
                        color: Colors.red,
                      ),
                      Text(
                        AlertlistModel.AlertData[index],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          Container(
                            width: 150,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.red,
                            ),
                            child: const Center(
                              child: Text(
                                " Stock is Less than 30%",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),

              // Column(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //  //crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     //const  Spacer(),
              //      Container(
              //        width: 150,
              //        height: 30,
              //        decoration: BoxDecoration(
              //          borderRadius: BorderRadius.circular(5),
              //          color: Colors.red,
              //        ),
              //        child: const Center(
              //          child: const Text(" Stock is Less than 30%",
              //          style: TextStyle(
              //                            fontSize: 12,
              //                            fontWeight: FontWeight.w700,
              //                            color: Colors.white
              //                          ),
              //          ),
              //        ),
              //      ),
              //   ],
              // )
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
        title: const Text("Request data"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: AlertlistModel.AlertData.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return RequestCart(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
