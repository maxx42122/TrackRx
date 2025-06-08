import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MedicinePieChart1 extends StatefulWidget {
  const MedicinePieChart1({Key? key}) : super(key: key);

  @override
  _MedicinePieChart1State createState() => _MedicinePieChart1State();
}

class _MedicinePieChart1State extends State<MedicinePieChart1> {
  bool isLoading = true;
  Map<String, double> categoryData = {};

  List<String> AllCollection = [
    "CardiacMedicine",
    "HighCholestrol",
    "Hypertension",
    "Osteoarthritis",
    "PainManagement",
    "EyeMedicine",
    "AntiboticsMedicine",
  ];

  @override
  void initState() {
    super.initState();
    _fetchMedicineData();
  }

  Future<void> _fetchMedicineData() async {
    try {
      Map<String, double> data = {};

      for (String collection in AllCollection) {
        QuerySnapshot snapshot =
            await FirebaseFirestore.instance.collection(collection).get();

        data[collection] = snapshot.docs.length.toDouble();
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
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : categoryData.isEmpty
              ? const Center(child: Text("No data available"))
              : Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Hospital Inventory Category",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 5,
                              child: _buildLegend(), // Legend on the left
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 185.0, top: 80),
                                child: PieChart(
                                  PieChartData(
                                    sections: _buildChartSections(),
                                    sectionsSpace: 2,
                                    centerSpaceRadius: 50,
                                    borderData: FlBorderData(show: false),
                                    pieTouchData: PieTouchData(
                                      touchCallback: (event, response) {
                                        if (event.isInterestedForInteractions &&
                                            response != null &&
                                            response.touchedSection != null) {
                                          final index = response.touchedSection!
                                              .touchedSectionIndex;
                                          final category = categoryData.keys
                                              .elementAt(index);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'Category: $category, Count: ${categoryData[category]?.toInt()}'),
                                          ));
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

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
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 120,
        badgeWidget: _buildBadge(category),
        badgePositionPercentageOffset: 1.2,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildBadge(String category) {
    IconData icon;

    switch (category.toLowerCase()) {
      case 'cardiacmedicine':
        icon = Icons.favorite;
        break;
      case 'eyemedicine':
        icon = Icons.remove_red_eye;
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

  Widget _buildLegend() {
    return ListView(
      children: categoryData.entries.map((entry) {
        final category = entry.key;
        final color = Colors.primaries[
            categoryData.keys.toList().indexOf(category) %
                Colors.primaries.length];

        return Padding(
          padding: const EdgeInsets.only(right: 30, left: 30, bottom: 10),
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
