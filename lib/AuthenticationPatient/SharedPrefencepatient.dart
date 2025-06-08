import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class Sharedprefencepatient {
  static String? ptype;
  static String? Email;
  static bool? isLogin;

  static Future<void> StoredPData({
    required String ptype,
    required String Email,
    required bool isLogin,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString("Email", Email);
    sharedPreferences.setBool("login", isLogin);
    sharedPreferences.setString("type", ptype);

    ///getData
    await getPrefrencesData();
  }

  static Future<void> getPrefrencesData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Email = sharedPreferences.getString("Email") ?? "";
    isLogin = sharedPreferences.getBool("login") ?? false;
    ptype = sharedPreferences.getString("type");
    log("Stored Email: $Email");
    log("Stored LoginType: $isLogin");
    log("Stored ptype: $ptype");
  }
}






















// import 'package:shared_preferences/shared_preferences.dart';

// class Sharedprefencepatient {

 
//   static String? ptype;
//   static String? Email;
//   static bool? isLogin;

//  static Future <void> StoredPData( {
   
//     required String ptype,
//     required String Email,
//     required bool isLogin,
  
//   }
  
//   )async{

//     SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    
//        sharedPreferences.setString("Email", Email);
//         sharedPreferences.setString("login", "$isLogin");
//          sharedPreferences.setString("type", ptype);

//          ///getData
//          getPrefrencesData();
//   } 


// static Future<void > getPrefrencesData()async{
//   SharedPreferences sharedPreferences=await SharedPreferences.getInstance();


//  Email=sharedPreferences.getString("Email") ?? "";
//  isLogin=sharedPreferences.getBool("login") ?? false;
//  ptype=sharedPreferences.getString("type");


  
// }
// }