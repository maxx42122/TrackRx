import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StockList1 extends StatefulWidget {
  @override
  _StockList1State createState() => _StockList1State();
}

class _StockList1State extends State<StockList1> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Stock'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Medicine',
                hintText: 'Enter medicine name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('hospital_inventory')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No medicines found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                List<Widget> medicineCards = [];

                for (var doc in snapshot.data!.docs) {
                  var categoryData = doc.data() as Map<String, dynamic>;
                  var medicines = categoryData['medicines'] as List<dynamic>;

                  for (var medicine in medicines) {
                    if (medicine['medicenName']
                        .toString()
                        .toLowerCase()
                        .contains(_searchQuery)) {
                      medicineCards.add(_buildMedicineCard(medicine, doc.id));
                    }
                  }
                }

                if (medicineCards.isEmpty) {
                  return Center(
                    child: Text(
                      'No medicines match your search',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView(
                  children: medicineCards,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineCard(Map<String, dynamic> medicine, String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 8,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 2, 199, 179),
                Colors.teal,
                Colors.teal.shade600,
                Colors.teal.shade800,
                Colors.teal.shade900,
                Colors.teal.shade600,
                Colors.teal.shade800,
                Colors.teal.shade900,
                Colors.teal.shade600,
                Colors.teal.shade800,
                Colors.teal.shade900,
                Colors.teal.shade600,
                Colors.teal.shade800,
                Colors.teal.shade900,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(medicine['imageUrl']),
                      radius: 35,
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            medicine['medicenName'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Category: $category",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "\$${medicine['price']}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Product ID: ${medicine['productId']}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      child: Text(
                        "Quantity: ${medicine['quantity']}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Manufacture: ${medicine['mdate']}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Expiry: ${medicine['edate']}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
