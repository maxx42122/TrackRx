import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class MedicineBarChart extends StatefulWidget {
  const MedicineBarChart({super.key});

  @override
  _MedicineBarChartState createState() => _MedicineBarChartState();
}

class _MedicineBarChartState extends State<MedicineBarChart> {
  late Future<List<MedicineData>> _medicineDataFuture;

  @override
  void initState() {
    super.initState();
    _medicineDataFuture = fetchMedicineData();
  }

  Future<List<MedicineData>> fetchMedicineData() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('medicine').get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return MedicineData(
        medicenName: data['medicenName'] ?? 'Unknown',
        quantity: (data['quantity'] ?? 0).toInt(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Medicine Quantity Bar Chart',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.2),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.bar_chart_rounded,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<MedicineData>>(
        future: _medicineDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          final data = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: MedicineBarChartWidget(medicineData: data),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Legend(medicineData: data),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MedicineData {
  final String medicenName;
  final int quantity;

  MedicineData({required this.medicenName, required this.quantity});
}

class MedicineBarChartWidget extends StatelessWidget {
  final List<MedicineData> medicineData;

  MedicineBarChartWidget({super.key, required this.medicineData});

  final Map<String, IconData> medicineIcons = {
    'Painkillers': Icons.medical_services,
    'Antibiotics': Icons.healing,
    'Vitamins': Icons.local_pharmacy,
    'Supplements': Icons.sanitizer,
    'Other': Icons.category,
  };

  final List<Color> barColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: medicineData.length * 90.0,
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(12),
            shadowColor: Colors.black.withOpacity(0.2),
            child: BarChart(
              BarChartData(
                barGroups: medicineData
                    .asMap()
                    .entries
                    .map(
                      (entry) => BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.quantity.toDouble(),
                            gradient: LinearGradient(
                              colors: [
                                barColors[entry.key % barColors.length]
                                    .withOpacity(0.7),
                                barColors[entry.key % barColors.length]
                              ],
                            ),
                            width: 22,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          // Background bar (if needed)
                          BarChartRodData(
                            toY: entry.value.quantity.toDouble() *
                                0.3, // Customize for background effect
                            color: Colors.grey.withOpacity(0.3),
                            width: 22,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ],
                      ),
                    )
                    .toList(),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[700]),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < medicineData.length) {
                          return Transform.translate(
                            offset: const Offset(0, 8),
                            child: Column(
                              children: [
                                Icon(
                                  medicineIcons[
                                          medicineData[index].medicenName] ??
                                      Icons.category,
                                  size: 16,
                                  color: barColors[index % barColors.length],
                                ),
                                const SizedBox(height: 4),
                                Transform.rotate(
                                  angle: -0.5,
                                  child: Text(
                                    medicineData[index].medicenName,
                                    style: const TextStyle(fontSize: 10),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.grey[300], strokeWidth: 0.8),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: const EdgeInsets.all(8.0),
                    tooltipMargin: 18,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${medicineData[groupIndex].medicenName}\n'
                        'Quantity: ${rod.toY.toInt()}',
                        const TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 245, 245, 245),
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                groupsSpace: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Legend extends StatelessWidget {
  final List<MedicineData> medicineData;

  const Legend({super.key, required this.medicineData});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.15),
      borderRadius: BorderRadius.circular(12),
      child: Wrap(
        spacing: 20,
        children: medicineData
            .asMap()
            .entries
            .map(
              (entry) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 8,
                    backgroundColor:
                        Colors.primaries[entry.key % Colors.primaries.length],
                  ),
                  const SizedBox(
                    height: 20,
                    width: 20,
                  ),
                  Text(
                    entry.value.medicenName,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
