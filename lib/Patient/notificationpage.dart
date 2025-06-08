import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchMedicine extends StatefulWidget {
  const SearchMedicine({super.key});

  @override
  State<SearchMedicine> createState() => _SearchMedicineState();
}

class _SearchMedicineState extends State<SearchMedicine> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _medicines = [];
  bool _isLoading = false;

  // Function to search medicines by name
  void _searchMedicines() async {
    setState(() {
      _isLoading = true;
      _medicines = []; // Clear previous search results
    });

    String query = _searchController.text.toLowerCase();

    try {
      // Fetch data from Firestore collection "medicine"
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('medicine')
          .where('medicenName', isGreaterThanOrEqualTo: query)
          .where('medicenName',
              isLessThan: query + 'z') // For case-insensitive search
          .get();

      setState(() {
        _isLoading = false;
        _medicines = snapshot.docs.map((doc) {
          return {
            'category': doc['category'],
            'edate': doc['edate'],
            'imageUrl': doc['imageUrl'],
            'mdate': doc['mdate'],
            'medicenName': doc['medicenName'],
            'price': doc['price'],
            'productId': doc['productId'],
            'quantity': doc['quantity'],
          };
        }).toList();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching medicine data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Medicine'),
        backgroundColor: Colors.blueAccent, // Custom AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search field with styling
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter Medicine Name',
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                filled: true,
                fillColor: Colors.blue.shade50,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    _medicines = []; // Clear results if search is empty
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Search Button with animation and elevation
            ElevatedButton(
              onPressed: _searchMedicines,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Search',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // Show loading indicator or search results
            _isLoading
                ? const CircularProgressIndicator() // Show loading spinner
                : Expanded(
                    child: ListView.builder(
                      itemCount: _medicines.length,
                      itemBuilder: (context, index) {
                        var medicine = _medicines[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(118, 68, 137, 255),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4), // Shadow position
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: medicine['imageUrl'] != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        medicine['imageUrl'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.medical_services,
                                      size: 50,
                                      color: Colors.blueAccent,
                                    ),
                              title: Text(
                                medicine['medicenName'],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Category: ${medicine['category']}'),
                                  Text('Price: Rs ${medicine['price']}'),
                                  Text('Expiry Date: ${medicine['edate']}'),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
