import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trackrx/Patient/vitalpages/datavital.dart';

class VitalsScreen extends StatefulWidget {
  const VitalsScreen({super.key});

  @override
  _VitalsScreenState createState() => _VitalsScreenState();
}

class _VitalsScreenState extends State<VitalsScreen> {
  final CollectionReference vitalsCollection =
      FirebaseFirestore.instance.collection('vitals');

  String selectedVital = 'Blood Glucose';

  final TextEditingController _field1Controller = TextEditingController();
  final TextEditingController _field2Controller = TextEditingController();
  final TextEditingController _field3Controller = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final Map<String, List<String>> vitalFields = {
    'Blood Glucose': ['Glucose Level', 'Type', 'Measured On', 'Note'],
    'Blood Pressure': ['Systolic', 'Diastolic', 'Pulse', 'Measured On', 'Note'],
    'Weight': ['Weight', 'Height', 'Measured On', 'Note'],
    'Blood Oxygen': ['SpO2', 'Pulse Rate', 'Measured On', 'Note'],
  };

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Fetch data for the currently selected vital
    DocumentSnapshot doc = await vitalsCollection.doc(selectedVital).get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      setState(() {
        _field1Controller.text = data[vitalFields[selectedVital]![0]
                    .toLowerCase()
                    .replaceAll(' ', '')] // Normalize field names
                ?.toString() ??
            '';
        _field2Controller.text = data[vitalFields[selectedVital]![1]
                    .toLowerCase()
                    .replaceAll(' ', '')] // Normalize field names
                ?.toString() ??
            '';
        _field3Controller.text = data[vitalFields[selectedVital]![2]
                    .toLowerCase()
                    .replaceAll(' ', '')] // Normalize field names
                ?.toString() ??
            '';
        _noteController.text = data['note']?.toString() ?? '';
      });
    } else {
      // Clear text controllers if no data is found
      _field1Controller.clear();
      _field2Controller.clear();
      _field3Controller.clear();
      _noteController.clear();
    }
  }

  Future<void> updateData() async {
    Map<String, dynamic> data = {
      vitalFields[selectedVital]![0].toLowerCase().replaceAll(' ', ''):
          _field1Controller.text,
      vitalFields[selectedVital]![1].toLowerCase().replaceAll(' ', ''):
          _field2Controller.text,
      vitalFields[selectedVital]![2].toLowerCase().replaceAll(' ', ''):
          _field3Controller.text,
      'note': _noteController.text,
      'lastUpdated': FieldValue.serverTimestamp(),
    };

    await vitalsCollection
        .doc(selectedVital)
        .set(data, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$selectedVital data updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color(0xFF007BFF), // Royal B // Purple primary color
        title: const Text('Vitals Management',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding for all elements
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown for selecting the vital type
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(125, 191, 189, 193),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: DropdownButton<String>(
                  dropdownColor: const Color.fromARGB(255, 231, 221, 235),
                  value: selectedVital,
                  isExpanded: true,
                  items: vitalFields.keys
                      .map((vital) => DropdownMenuItem(
                            value: vital,
                            child: Text(vital,
                                style: const TextStyle(fontSize: 16)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedVital = value!;
                      fetchData(); // Fetch new data when vital type changes
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Input fields
            _buildInputField(_field1Controller, vitalFields[selectedVital]![0]),
            _buildInputField(_field2Controller, vitalFields[selectedVital]![1]),
            _buildInputField(_field3Controller, vitalFields[selectedVital]![2]),

            // Note field
            _buildInputField(_noteController, 'Note'),
            const SizedBox(height: 24),

            // Update Button
            Center(
              child: SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: () async {
                    await updateData();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => VitalsDataPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                        0xFF007BFF), // Royal B // Purple primary color
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Update',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build input fields
  Widget _buildInputField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  const BorderSide(color: Color(0xFF007BFF)) // Royal B),
              ),
        ),
      ),
    );
  }
}
