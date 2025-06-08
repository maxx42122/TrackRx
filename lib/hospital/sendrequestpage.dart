import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'requestData.dart';

class SendRequestPage extends StatefulWidget {
  const SendRequestPage({super.key});

  @override
  _SendRequestPageState createState() => _SendRequestPageState();
}

class _SendRequestPageState extends State<SendRequestPage> {
  List<Map<String, dynamic>> medicines = [];
  final TextEditingController _medicineController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  String? hospitalId;

  @override
  void initState() {
    super.initState();
    _fetchHospitalId();
  }

  Future<void> _storeOrderToFirestore() async {
    if (hospitalId == null || medicines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot send request. Missing data.")),
      );
      return;
    }

    try {
      var orderData = {
        'hospitalId': hospitalId,
        'orderDate': DateTime.now(),
        'medicines': medicines,
        'status': 'Pending',
      };

      // Add to Hospital Orders
      await FirebaseFirestore.instance
          .collection('Hospitalorder')
          .doc(hospitalId)
          .collection('Orders')
          .add(orderData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order saved successfully!")),
      );

      setState(() {
        medicines.clear();
      });
    } catch (e) {
      debugPrint("Error saving order: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save order.")),
      );
    }
  }

  Future<void> _fetchHospitalId() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> hospitalData =
            await FirebaseFirestore.instance
                .collection('hospital')
                .doc(currentUser.email)
                .get();

        if (hospitalData.exists) {
          setState(() {
            hospitalId = hospitalData.data()?['Id'];
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching hospital ID: $e");
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled:
          true, // Ensures the bottom sheet resizes with the keyboard
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
            left: 16,
            right: 16,
            top: 20,
          ),
          child: SingleChildScrollView(
            // Make content scrollable
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Medicine Name TextField
                TextField(
                  controller: _medicineController,
                  decoration: InputDecoration(
                    labelText: "Medicine Name",
                    prefixIcon: const Icon(Icons.medication_outlined,
                        color: Colors.blue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 12,
                    ),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),

                // Quantity TextField
                TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Quantity",
                    prefixIcon: const Icon(Icons.plus_one, color: Colors.blue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 12,
                    ),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),

                // Add Medicine Button
                ElevatedButton(
                  onPressed: () {
                    if (_medicineController.text.isNotEmpty &&
                        _quantityController.text.isNotEmpty) {
                      setState(() {
                        medicines.add({
                          'medicineName': _medicineController.text,
                          'quantity':
                              int.tryParse(_quantityController.text) ?? 0,
                        });
                      });

                      _medicineController.clear();
                      _quantityController.clear();

                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 25,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text(
                    "Add Medicine",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToOrderHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequestedPage(hospitalId: hospitalId ?? ''),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Medicine Request"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Medicines to be Ordered",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: medicines.length,
                itemBuilder: (context, index) {
                  final medicine = medicines[index];
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      title: Text(
                        medicine['medicineName'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text("Quantity: ${medicine['quantity']}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            medicines.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RequestedPage(hospitalId: hospitalId ?? ''),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blueAccent),
                height: 55,
                width: 170,
                padding: const EdgeInsets.only(left: 10),
                child: const Row(
                  children: [
                    Icon(Icons.list),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "View Order History",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () => _showBottomSheet(context),
            backgroundColor: const Color.fromARGB(255, 160, 198, 254),
            elevation: 8,
            tooltip: 'Add Medicine',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 15),
          FloatingActionButton.extended(
            onPressed: _storeOrderToFirestore,
            label: const Text("Send Request"),
            icon: const Icon(Icons.send),
            backgroundColor: Colors.blueAccent,
          ),
        ],
      ),
    );
  }
}
