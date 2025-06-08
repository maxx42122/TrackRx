import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestedPage extends StatefulWidget {
  final String hospitalId;

  const RequestedPage({super.key, required this.hospitalId});

  @override
  _RequestedPageState createState() => _RequestedPageState();
}

class _RequestedPageState extends State<RequestedPage> {
  Stream<List<Map<String, dynamic>>> _fetchOrdersStream() {
    return FirebaseFirestore.instance
        .collection('Hospitalorder')
        .doc(widget.hospitalId)
        .collection('Orders')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        List<Map<String, dynamic>> medicines = [];
        for (var medicine in doc['medicines']) {
          medicines.add({
            'medicineName': medicine['medicineName'],
            'quantity': medicine['quantity'],
          });
        }

        return {
          'medicines': medicines,
          'status': doc['status'],
          'orderDate': doc['orderDate'].toDate(),
          'hospitalId': widget.hospitalId,
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order History",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _fetchOrdersStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "No orders found.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              );
            }

            var orders = snapshot.data!;

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                var order = orders[index];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...order['medicines'].map<Widget>((medicine) {
                            return Text(
                              "• ${medicine['medicineName']} - Quantity: ${medicine['quantity']}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.local_hospital,
                                  color: Colors.teal, size: 20),
                              const SizedBox(width: 5),
                              Text(
                                "Hospital ID: ${order['hospitalId']}",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                order['status'] == 'Delivered'
                                    ? Icons.check_circle
                                    : Icons.pending_actions,
                                color: order['status'] == 'Delivered'
                                    ? Colors.green
                                    : Colors.orange,
                                size: 20,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Status: ${order['status']}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: order['status'] == 'Delivered'
                                      ? Colors.green
                                      : Colors.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.date_range,
                                color: Colors.grey, size: 20),
                            const SizedBox(width: 5),
                            Text(
                              "Order Date: ${order['orderDate']}",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
