import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MedicinePieChart extends StatefulWidget {
  const MedicinePieChart({Key? key}) : super(key: key);

  @override
  _MedicinePieChartState createState() => _MedicinePieChartState();
}

class _MedicinePieChartState extends State<MedicinePieChart> {
  bool isLoading = true;
  Map<String, double> categoryData = {};

  @override
  void initState() {
    super.initState();
    _fetchMedicineData();
  }

  Future<void> _fetchMedicineData() async {
    try {
      // Fetch all medicine data
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('medicine').get();

      Map<String, double> data = {};

      // Process each document
      for (var doc in snapshot.docs) {
        String category = doc['category'];
        double quantity = doc['quantity']?.toDouble() ?? 0;

        // Accumulate quantity by category
        data[category] = (data[category] ?? 0) + quantity;
      }

      setState(() {
        categoryData = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching medicine data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Distribution'),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : categoryData.isEmpty
              ? const Center(child: Text("No data available"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        "Medicine Distribution by Category",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: const LinearGradient(
                                      colors: [
                                        Color.fromARGB(120, 208, 43, 2),
                                        Color.fromARGB(120, 190, 24, 162),
                                        Colors.white,
                                        Colors.white,
                                        Colors.white,
                                        Colors.white,
                                        Colors.white,
                                        Colors.white,
                                        Colors.white,
                                        Color.fromARGB(120, 149, 6, 227),
                                        Color.fromARGB(120, 26, 32, 213),
                                        Color.fromARGB(120, 4, 192, 255),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomCenter),
                                ),
                                child: Card(
                                  elevation: 12,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 60.0),
                                    child: PieChart(
                                      PieChartData(
                                        sections: _buildChartSections(),
                                        sectionsSpace:
                                            6, // Space between sections
                                        centerSpaceRadius:
                                            50, // Center empty radius
                                        borderData: FlBorderData(show: false),
                                        pieTouchData: PieTouchData(
                                          touchCallback: (event, response) {
                                            if (event
                                                    .isInterestedForInteractions &&
                                                response != null &&
                                                response.touchedSection !=
                                                    null) {
                                              final index = response
                                                  .touchedSection!
                                                  .touchedSectionIndex;
                                              final category = categoryData.keys
                                                  .elementAt(index);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                  'Category: $category, '
                                                  'Quantity: ${categoryData[category]}',
                                                ),
                                              ));
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: _buildLegend(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  // Build the Pie Chart Sections
  List<PieChartSectionData> _buildChartSections() {
    final totalQuantity =
        categoryData.values.reduce((value, element) => value + element);

    return categoryData.entries.map((entry) {
      final category = entry.key;
      final quantity = entry.value;
      final percentage = (quantity / totalQuantity) * 100;
      final color = Colors.primaries[
          categoryData.keys.toList().indexOf(category) %
              Colors.primaries.length];

      return PieChartSectionData(
        color: color,
        value: quantity,
        title: '${percentage.toStringAsFixed(1)}%', // Show percentage
        radius: 100,
        badgeWidget: _buildBadge(category),
        badgePositionPercentageOffset: 1.2, // Position the badge
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  // Build the Badge (Icon for the pie section)
  Widget _buildBadge(String category) {
    IconData icon;

    // Example of mapping categories to icons
    switch (category.toLowerCase()) {
      case 'antibiotics':
        icon = Icons.medical_services;
        break;
      case 'painkillers':
        icon = Icons.local_hospital;
        break;
      default:
        icon = Icons.category;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            spreadRadius: 2,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.blueAccent, size: 20),
    );
  }

  // Build the Legend
  Widget _buildLegend() {
    return ListView(
      children: categoryData.entries.map((entry) {
        final category = entry.key;
        final color = Colors.primaries[
            categoryData.keys.toList().indexOf(category) %
                Colors.primaries.length];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  category,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:trackrx/AuthenticationPatient/3typelogin.dart';
// import 'package:trackrx/AuthenticationPatient/SharedPrefencepatient.dart';
// import 'package:trackrx/AuthenticationPatient/hospital/1login_hospital.dart';

// import 'package:trackrx/Patient/patient.dart';
// import 'package:trackrx/hospital/homepage.dart';
// import 'package:trackrx/manufacturer/homepage.dart';
// import 'package:splash_screen_view/SplashScreenView.dart';

// class SplashScreen1 extends StatelessWidget {
//   const SplashScreen1({super.key});

//   void navigate(BuildContext context) {
//     Future.delayed(const Duration(seconds: 5), () async {
//       await Sharedprefencepatient.getPrefrencesData();
//       print("IS LOGIN :${Sharedprefencepatient.isLogin} ");
//       print("PTYPE: ${Sharedprefencepatient.ptype}");

//       if (Sharedprefencepatient.isLogin == true &&
//           Sharedprefencepatient.ptype == "patient") {
//         print("in patient splashscrren");
//         Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => const Patient_UI()));
//       } else if (Sharedprefencepatient.isLogin == true &&
//           Sharedprefencepatient.ptype == "hospital") {
//         print("in hospital splashscrren");
//         Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => const Homepage()));
//       } else if (Sharedprefencepatient.isLogin == true &&
//           Sharedprefencepatient.ptype == "manufacturer") {
//         print("in manufacturer splashscrren");
//         Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => const Home()));
//       } else {
//         print("in else ");
//         Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => const typeLoginui()));
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("In Build");
//     navigate(context);

//     return Scaffold(
//       body: SplashScreenView(
//         imageSrc: "assets/icon.png",
//         imageSize: 300,
//         navigateRoute: const typeLoginui(),
//         text: "TRACKRX",
//         textType: TextType.ColorizeAnimationText,
//         textStyle: GoogleFonts.lato(
//           fontSize: 70,
//           fontWeight: FontWeight.w800,
//           letterSpacing: 4,
//           shadows: [
//             const Shadow(
//               offset: Offset(2.0, 2.0),
//               blurRadius: 3.0,
//               color: Colors.black45,
//             ),
//           ],
//         ),
//         colors: const [
//           Color.fromARGB(255, 14, 64, 149),
//           Colors.white,
//           Colors.blue,
//         ],
//         backgroundColor:
//             Colors.black, // Dark background for 3D effect visibility
//       ),
//       // Optional: Add more 3D animation to the logo or background.
//       // You can use a Transform widget to create 3D-like rotations or scaling.
//       // Example of 3D rotating effect on the logo image.
//       floatingActionButton: Transform(
//         transform: Matrix4.rotationY(0.5)..rotateX(0.2),
//         alignment: Alignment.center,
//         child: Image.asset(
//           "assets/icon.png",
//           height: 200,
//           fit: BoxFit.contain,
//         ),
//       ),
//     );
//   }
// }
