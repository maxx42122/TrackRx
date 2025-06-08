import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  List<Map<String, dynamic>> orders = [];
  String? manufacturerId;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No user is currently logged in.");
      }
      String userEmail = currentUser.email ?? "";

      // Fetch the manufacturer ID from Firestore
      DocumentSnapshot manufacturerSnapshot = await FirebaseFirestore.instance
          .collection("manufacturer")
          .doc(userEmail)
          .get();

      if (!manufacturerSnapshot.exists) {
        throw Exception("Manufacturer details not found.");
      }

      manufacturerId = manufacturerSnapshot['id'];

      // Fetch orders from Firestore
      DocumentSnapshot ordersSnapshot = await FirebaseFirestore.instance
          .collection("manufactureorder")
          .doc(manufacturerId)
          .get();

      if (ordersSnapshot.exists && ordersSnapshot.data() != null) {
        final rawOrders = ordersSnapshot['orders'] as List<dynamic>;
        orders = rawOrders
            .map((order) => Map<String, dynamic>.from(order as Map))
            .toList();

        // Sort orders by date in descending order
        orders.sort((a, b) {
          final dateA = DateTime.tryParse(a['date'] ?? '') ?? DateTime(1970);
          final dateB = DateTime.tryParse(b['date'] ?? '') ?? DateTime(1970);
          return dateB.compareTo(dateA); // Most recent date first
        });
      }
    } catch (e) {
      print("Error fetching order details: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showQrDialog(Map<String, dynamic> order) {
    // Generate QR code data
    final qrData = jsonEncode({
      'orderId': order['orderId'],
      'hospitalId': order['hospitalId'],
      'totalPrice': order['totalPrice'],
      'date': order['date'],
    });

    // Show dialog with QR code
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("QR Code"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Order ID: ${order['orderId']}"),
              const SizedBox(height: 10),
              PrettyQr(
                data: qrData,
                size: 150,
                roundEdges: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Stream<List<Map<String, dynamic>>> fetchOrders(String manufacturerId) {
    return FirebaseFirestore.instance
        .collection("manufactureorder")
        .doc(manufacturerId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        return (data?['orders'] ?? []).cast<Map<String, dynamic>>();
      }
      return [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order History',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Stack(
        children: [
          // Background clock image
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/manufacturer/clk.gif', // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content: Loader, No Data, or Order List
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : orders.isEmpty
                  ? const Center(
                      child: Text(
                        'No orders available',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        final medicines =
                            order['medicines'] as List<dynamic>? ?? [];

                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header: Order ID and QR Button
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Order ID: ${order['orderId'] ?? 'N/A'}',
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.indigo,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.qr_code,
                                        color: Colors.deepPurple,
                                      ),
                                      onPressed: () => _showQrDialog(order),
                                      tooltip: 'View QR Code',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Hospital Information
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.local_hospital,
                                      color: Colors.blueGrey,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Hospital ID: ${order['hospitalId'] ?? 'N/A'}',
                                      style: GoogleFonts.openSans(
                                        fontSize: 14,
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 20, color: Colors.grey),

                                // Medicines List
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: medicines.map((medicine) {
                                    final medicineMap =
                                        Map<String, dynamic>.from(medicine);
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  medicineMap['name'] ??
                                                      'Unknown',
                                                  style: GoogleFonts.openSans(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                Text(
                                                  'Product ID: ${medicineMap['productId'] ?? 'N/A'}',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            'Qty: ${medicineMap['quantity'] ?? 0}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const Divider(height: 20, color: Colors.grey),

                                // Total and Date Information
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      'Rs ${order['totalPrice']?.toStringAsFixed(2) ?? '0.00'}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigo,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.grey,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      order['date'] ?? 'N/A',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ],
      ),
    );
  }
}
