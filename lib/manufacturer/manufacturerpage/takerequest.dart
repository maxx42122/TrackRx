import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'prepareorder.dart';

class TakeRequestPage extends StatefulWidget {
  const TakeRequestPage({super.key});

  @override
  _TakeRequestPageState createState() => _TakeRequestPageState();
}

class _TakeRequestPageState extends State<TakeRequestPage> {
  List<Map<String, dynamic>> orders = [];
  List<Map<String, dynamic>> filteredOrders = []; // For search results
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAllOrders();
  }

  // Fetch all orders from Firestore
  Future<void> _fetchAllOrders() async {
    try {
      print("Fetching all orders...");
      List<Map<String, dynamic>> fetchedOrders = [];

      var hospitalsSnapshot =
          await FirebaseFirestore.instance.collection('Hospitalorder').get();

      for (var hospitalDoc in hospitalsSnapshot.docs) {
        print("Hospital found: ${hospitalDoc.id}");
        String hospitalId = hospitalDoc.id;

        var ordersSnapshot = await FirebaseFirestore.instance
            .collection('Hospitalorder')
            .doc(hospitalId)
            .collection('Orders')
            .get();

        for (var orderDoc in ordersSnapshot.docs) {
          print("Order found in $hospitalId: ${orderDoc.id}");

          // Ensure medicines field is properly parsed
          List<Map<String, dynamic>> medicines = [];
          if (orderDoc['medicines'] != null) {
            for (var medicine in orderDoc['medicines']) {
              medicines.add({
                'medicineName': medicine['medicineName'],
                'quantity': medicine['quantity'],
              });
            }
          }

          fetchedOrders.add({
            'hospitalId': hospitalId,
            'medicines': medicines,
            'status': orderDoc['status'],
            'orderDate': orderDoc['orderDate'].toDate(),
            'orderId': orderDoc.id,
          });
        }
      }

      fetchedOrders.sort((a, b) => b['orderDate'].compareTo(a['orderDate']));

      setState(() {
        orders = fetchedOrders;
        filteredOrders = fetchedOrders; // Initially show all orders
        isLoading = false;
      });

      print("Fetched orders: $fetchedOrders");
    } catch (e) {
      print("Error fetching orders: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Update status to "prepared"
  Future<void> _acceptOrder(
      BuildContext context, String hospitalId, String orderId) async {
    await FirebaseFirestore.instance
        .collection('Hospitalorder')
        .doc(hospitalId)
        .collection('Orders')
        .doc(orderId)
        .update({'status': 'prepared'});

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PrepareOrder(hospitalId: hospitalId, orderId: orderId),
      ),
    );
  }

  // Update status to "declined" and remove from UI
  Future<void> _declineOrder(
      BuildContext context, String hospitalId, String orderId) async {
    await FirebaseFirestore.instance
        .collection('Hospitalorder')
        .doc(hospitalId)
        .collection('Orders')
        .doc(orderId)
        .update({'status': 'declined'});

    setState(() {
      orders.removeWhere((order) =>
          order['hospitalId'] == hospitalId && order['orderId'] == orderId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order Declined')),
    );
  }

  // Filter orders based on search query
  void _searchOrders(String query) {
    final filtered = orders.where((order) {
      return order['hospitalId'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredOrders = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(120.0), // Adjusted height for rounded corners
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
          child: AppBar(
            title: const Text(
              "All Hospital Orders",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.blueAccent,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56.0),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: TextField(
                  controller: searchController,
                  onChanged: _searchOrders,
                  decoration: InputDecoration(
                    labelText: "Search by Hospital ID",
                    labelStyle: const TextStyle(color: Colors.white),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 178, 196, 247),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredOrders.isEmpty
              ? const Center(child: Text("No orders found."))
              : ListView.builder(
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    var order = filteredOrders[index];

                    Color statusColor;
                    IconData statusIcon;

                    switch (order['status']) {
                      case 'prepared':
                        statusColor = Colors.green;
                        statusIcon = Icons.check_circle;
                        break;
                      case 'declined':
                        statusColor = Colors.red;
                        statusIcon = Icons.cancel;
                        break;
                      default:
                        statusColor = Colors.orange;
                        statusIcon = Icons.pending;
                    }

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.local_hospital,
                                    color: Colors.blue),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Hospital ID: ${order['hospitalId']}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            const SizedBox(height: 10),
                            const Text(
                              "Medicines:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  order['medicines'].map<Widget>((medicine) {
                                return Row(
                                  children: [
                                    const Icon(Icons.medication,
                                        color: Colors.blue),
                                    const SizedBox(width: 8),
                                    Text(
                                      "${medicine['medicineName']} - Qty: ${medicine['quantity']}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                            const Divider(),
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    color: Colors.blue),
                                const SizedBox(width: 8),
                                Text(
                                  "Order Date: ${order['orderDate']}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(statusIcon, color: statusColor),
                                const SizedBox(width: 8),
                                Text(
                                  "Status: ${order['status']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: statusColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _acceptOrder(context, order['hospitalId'],
                                        order['orderId']);
                                  },
                                  icon: const Icon(Icons.check),
                                  label: const Text("Accept"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _declineOrder(context, order['hospitalId'],
                                        order['orderId']);
                                  },
                                  icon: const Icon(Icons.close),
                                  label: const Text("Decline"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
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
    );
  }
}
