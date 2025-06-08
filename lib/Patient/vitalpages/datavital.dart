// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackrx/Patient/vitalpages/addvitals.dart';

class VitalsDataPage extends StatefulWidget {
  const VitalsDataPage({super.key});

  @override
  _VitalsDataPageState createState() => _VitalsDataPageState();
}

class _VitalsDataPageState extends State<VitalsDataPage> {
  int _selectedIndex = 0;

  final List<String> vitalTypes = [
    'Blood Glucose',
    'Blood Pressure',
    'Weight',
    'Blood Oxygen',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vitals Data',
          style: TextStyle(color: Colors.white), // AppBar text color
        ),
        backgroundColor: const Color(0xFF007BFF), // Royal Blue
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('vitals')
            .doc(vitalTypes[_selectedIndex])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                'No data available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          Timestamp? lastUpdated = data['lastUpdated'] as Timestamp?;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 400,
              height: 300,
              child: Card(
                color: const Color.fromARGB(
                    255, 224, 234, 243), // Light Gray card background
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vitalTypes[_selectedIndex],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF007BFF), // Royal Blue text
                        ),
                      ),
                      const SizedBox(height: 16),
                      for (var field in data.entries)
                        if (field.key !=
                            'lastUpdated') // Skip the lastUpdated field
                          Text(
                            '${field.key.capitalize()}: ${field.value}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black, // Black for content text
                            ),
                          ),
                      const SizedBox(height: 16),
                      if (lastUpdated != null)
                        Text(
                          'Last Updated: ${DateFormat.yMMMd().add_jm().format(lastUpdated.toDate())}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey, // Gray for timestamp
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.white, // Active icon/text color
        backgroundColor: const Color(0xFF007BFF), // Royal Blue background
        currentIndex: _selectedIndex,
        // Selected tab color
        unselectedItemColor: const Color.fromARGB(
            255, 157, 173, 182), // Light gray for inactive tabs
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.opacity),
            label: 'Blood Glucose',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Blood Pressure',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_weight),
            label: 'Weight',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.air),
            label: 'Blood Oxygen',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return VitalsScreen();
          }));
        },
        backgroundColor: const Color(0xFF007BFF), // Emerald Green
        child: const Icon(Icons.add, color: Colors.white), // Plus icon
      ),
      backgroundColor: const Color(0xFFFFFFFF), // White background
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
  }
}
