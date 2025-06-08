

import 'package:flutter/material.dart';

class MySnackbarModelclass {

  static  void snakbarmethod(BuildContext context,String message) {
    // SnackBar snack = SnackBar(
    //   content: const Row(
    //     children: [
    //       Text(
    //         "Sucessfully send A Request",
    //         style: TextStyle(
    //           fontSize: 15,
    //           fontWeight: FontWeight.w900,
    //           color: Colors.black,
    //         ),
    //       ),
    //       Spacer(),
    //       Icon(Icons.close)
    //     ],
    //   ),
      // duration: const Duration(seconds: 4),
      // backgroundColor: Colors.white,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(20),
      // ),
      // behavior: SnackBarBehavior.floating,
      // margin: EdgeInsets.all(10),
  
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message,style:const TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.w800,

    ),),
     duration: const Duration(seconds: 4),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      behavior: SnackBarBehavior.floating,
      margin:const  EdgeInsets.all(10),
    ));
  }
}