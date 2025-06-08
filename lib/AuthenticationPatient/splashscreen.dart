// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:trackrx/AuthenticationPatient/3typelogin.dart';
// import 'package:trackrx/AuthenticationPatient/SharedPrefencepatient.dart';
// import 'package:trackrx/AuthenticationPatient/hospital/1login_hospital.dart';

// import 'package:trackrx/Patient/patient.dart';
// import 'package:trackrx/hospital/homepage.dart';
// import 'package:trackrx/manufacturer/homepage.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   void navigate(BuildContext context) {
//     Future.delayed(const Duration(seconds: 3), () async {
//       await Sharedprefencepatient.getPrefrencesData();
//       log("IS LOGIN :${Sharedprefencepatient.isLogin} ");
//       log("PTYPE: ${Sharedprefencepatient.ptype}");

//       if (Sharedprefencepatient.isLogin == true &&
//           Sharedprefencepatient.ptype == "patient") {
//         log("in patient splashscrren");
//         Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => Patient_UI()));
//       } else if (Sharedprefencepatient.isLogin == true &&
//           Sharedprefencepatient.ptype == "hospital") {
//         log("in hospital splashscrren");
//         Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => Homepage()));
//       } else if (Sharedprefencepatient.isLogin == true &&
//           Sharedprefencepatient.ptype == "manufacturer") {
//         log("in manufacturer splashscrren");
//         Navigator.of(context)
//             .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
//       } else {
//         log("in else ");
//         Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => typeLoginui()));
//       }

//       // await SessionData.getSessionData();
//       // print("IS LOGIN : ${SessionData.isLogin}");
//       // print("IS LOGIN : ${SessionData1.isLogin1}");
//       // print("IS LOGIN : ${SessionData2.isLogin2}");

//       // if (SessionData.isLogin!) {
//       //   print("Navigate to home of patient");
//       //   Navigator.of(context)
//       //       .pushReplacement(MaterialPageRoute(builder: (context) {
//       //     return Patient_UI(
//       //       email: SessionData.emailId!,
//       //     );
//       //   }));
//       // } else {
//       //   print("Navigate to login page of patient");
//       //   Navigator.of(context)
//       //       .pushReplacement(MaterialPageRoute(builder: (context) {
//       //     return typeLoginui();
//       //   }));
//       // }

//       // ////////////////////////////////
//       // if (SessionData1.isLogin1!) {
//       //   print("Navigate to home hospital");
//       //   Navigator.of(context)
//       //       .pushReplacement(MaterialPageRoute(builder: (context) {
//       //     return Homepage(
//       //       email1: SessionData1.emailId1!,
//       //     );
//       //   }));
//       // } else {
//       //   print("Navigate to login page hospital");
//       //   Navigator.of(context)
//       //       .pushReplacement(MaterialPageRoute(builder: (context) {
//       //     return typeLoginui();
//       //   }));
//       // }

//       // //////////////////////////////////////////////
//       // if (SessionData2.isLogin2!) {
//       //   print("Navigate to home manufacturer");
//       //   Navigator.of(context)
//       //       .pushReplacement(MaterialPageRoute(builder: (context) {
//       //     return Home(
//       //       email2: SessionData2.emailId2!,
//       //     );
//       //   }));
//       // } else {
//       //   print("Navigate to login page manufacturer");
//       //   Navigator.of(context)
//       //       .pushReplacement(MaterialPageRoute(builder: (context) {
//       //     return typeLoginui();
//       //   }));
//       // }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("In Build");
//     navigate(context);

//     return Scaffold(
//       body: Image.asset(
//         "assets/TrackRx.png",
//         height: 950,
//         fit: BoxFit.fill,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackrx/AuthenticationPatient/3typelogin.dart';
import 'package:trackrx/AuthenticationPatient/SharedPrefencepatient.dart';
import 'package:trackrx/AuthenticationPatient/hospital/1login_hospital.dart';

import 'package:trackrx/Patient/patient.dart';
import 'package:trackrx/hospital/homepage.dart';
import 'package:trackrx/manufacturer/homepage.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void navigate(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () async {
      await Sharedprefencepatient.getPrefrencesData();
      print("IS LOGIN :${Sharedprefencepatient.isLogin} ");
      print("PTYPE: ${Sharedprefencepatient.ptype}");

      if (Sharedprefencepatient.isLogin == true &&
          Sharedprefencepatient.ptype == "patient") {
        print("in patient splashscrren");
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Patient_UI()));
      } else if (Sharedprefencepatient.isLogin == true &&
          Sharedprefencepatient.ptype == "hospital") {
        print("in hospital splashscrren");
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Homepage()));
      } else if (Sharedprefencepatient.isLogin == true &&
          Sharedprefencepatient.ptype == "manufacturer") {
        print("in manufacturer splashscrren");
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Home()));
      } else {
        print("in else ");
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const typeLoginui()));
      }

      // await SessionData.getSessionData();
      // print("IS LOGIN : ${SessionData.isLogin}");
      // print("IS LOGIN : ${SessionData1.isLogin1}");
      // print("IS LOGIN : ${SessionData2.isLogin2}");

      // if (SessionData.isLogin!) {
      //   print("Navigate to home of patient");
      //   Navigator.of(context)
      //       .pushReplacement(MaterialPageRoute(builder: (context) {
      //     return Patient_UI(
      //       email: SessionData.emailId!,
      //     );
      //   }));
      // } else {
      //   print("Navigate to login page of patient");
      //   Navigator.of(context)
      //       .pushReplacement(MaterialPageRoute(builder: (context) {
      //     return typeLoginui();
      //   }));
      // }

      // ////////////////////////////////
      // if (SessionData1.isLogin1!) {
      //   print("Navigate to home hospital");
      //   Navigator.of(context)
      //       .pushReplacement(MaterialPageRoute(builder: (context) {
      //     return Homepage(
      //       email1: SessionData1.emailId1!,
      //     );
      //   }));
      // } else {
      //   print("Navigate to login page hospital");
      //   Navigator.of(context)
      //       .pushReplacement(MaterialPageRoute(builder: (context) {
      //     return typeLoginui();
      //   }));
      // }

      // //////////////////////////////////////////////
      // if (SessionData2.isLogin2!) {
      //   print("Navigate to home manufacturer");
      //   Navigator.of(context)
      //       .pushReplacement(MaterialPageRoute(builder: (context) {
      //     return Home(
      //       email2: SessionData2.emailId2!,
      //     );
      //   }));
      // } else {
      //   print("Navigate to login page manufacturer");
      //   Navigator.of(context)
      //       .pushReplacement(MaterialPageRoute(builder: (context) {
      //     return typeLoginui();
      //   }));
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("In Build");
    navigate(context);

    return Scaffold(
      body: SplashScreenView(
        imageSrc: "assets/icon.png",
        imageSize: 300,
        navigateRoute: const typeLoginui(),
        text: "TRACKRX",
        textType: TextType.ColorizeAnimationText,
        textStyle: GoogleFonts.lato(
          // Using Google Fonts for better styling.
          fontSize: 70,
          fontWeight: FontWeight.w800,
          letterSpacing: 4,
          shadows: [
            const Shadow(
              offset: Offset(2.0, 2.0),
              blurRadius: 3.0,
              color: Colors.black45,
            ),
          ],
        ),
        colors: const [
          Color.fromARGB(255, 14, 64, 149),
          //const Color.fromARGB(255, 43, 129, 171),
          Colors.white,
          Colors.blue,
          // Colors.yellow,
          // Colors.red,
        ],
      ),

      // Image.asset(
      //   "assets/TrackRx.png",
      //   //height: 500,
      //   fit: BoxFit.fill,
      // ),
    );
  }
}
