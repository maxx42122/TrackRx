import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class ReceiveOrderPage extends StatefulWidget {
  final String hospitalId;

  const ReceiveOrderPage({super.key, required this.hospitalId});

  @override
  _ReceiveOrderPageState createState() => _ReceiveOrderPageState();
}

class _ReceiveOrderPageState extends State<ReceiveOrderPage> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;
  int newOrdersCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
    _listenForNewOrders();
  }

  void _listenForNewOrders() {
    FirebaseFirestore.instance
        .collection('manufactureorder')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      int newCount = 0;

      for (var doc in snapshot.docs) {
        final rawOrders = doc['orders'] as List<dynamic>?;

        if (rawOrders != null) {
          newCount += rawOrders
              .where((order) =>
                  order['hospitalId'] == widget.hospitalId &&
                  (order['status'] == null || order['status'] != 'success'))
              .length;
        }
      }

      // Update the state with the new count
      setState(() {
        newOrdersCount = newCount;
      });
    });
  }

  Future<void> _fetchOrderDetails() async {
    try {
      String hospitalId = widget.hospitalId;

      // Fetch orders from Firestore (manufactureorder collection)
      QuerySnapshot ordersSnapshot =
          await FirebaseFirestore.instance.collection("manufactureorder").get();

      // Filter orders by hospitalId from the orders subfield
      for (var doc in ordersSnapshot.docs) {
        final rawOrders = doc['orders'] as List<dynamic>?;

        if (rawOrders != null) {
          final filteredOrders = rawOrders
              .where((order) =>
                  order['hospitalId'] == hospitalId) // Filter by hospitalId
              .map((order) => {
                    ...Map<String, dynamic>.from(order as Map),
                    'manufacturerId':
                        doc.id // Include manufacturerId from docId
                  })
              .toList();

          orders.addAll(filteredOrders);
        }
      }
    } catch (e) {
      print("Error fetching order details: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateOrderStatus(String orderId, String manufacturerId) async {
    try {
      // Fetch the order to retrieve the medicines
      DocumentReference orderRef = FirebaseFirestore.instance
          .collection("manufactureorder")
          .doc(manufacturerId);

      final orderSnapshot = await orderRef.get();

      if (orderSnapshot.exists) {
        List<dynamic> ordersList = orderSnapshot['orders'] ?? [];
        for (var order in ordersList) {
          if (order['orderId'] == orderId) {
            final medicines = order['medicines'] as List<dynamic>? ?? [];

            // Reduce medicine quantities in global stock (Only once per order)
            for (var medicine in medicines) {
              final medicineMap = Map<String, dynamic>.from(medicine);

              // Reduce quantity in global stock
              await _reduceMedicineQuantity(
                medicineMap['name'],
                medicineMap['quantity'],
              );

              // Update hospital stock (inventory update without quantity reduction)
              await _updateHospitalStock(
                widget.hospitalId, // Current hospital ID
                medicineMap['name'], // Medicine name
                medicineMap['quantity'], // Quantity to add
              );
            }

            // Mark the order as successful
            order['status'] = 'success';
            break;
          }
        }

        // Update the Firestore document with modified orders
        await orderRef.update({'orders': ordersList});
      }

      // Remove the order from the UI
      setState(() {
        orders.removeWhere((order) =>
            order['orderId'] == orderId &&
            order['manufacturerId'] == manufacturerId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order marked as Success!')),
      );
    } catch (e) {
      print("Error updating order status: $e");
    }
  }

  // Future<void> _updateOrderStatus(String orderId, String manufacturerId) async {
  //   try {
  //     // Fetch the order to retrieve the medicines
  //     DocumentReference orderRef = FirebaseFirestore.instance
  //         .collection("manufactureorder")
  //         .doc(manufacturerId);

  //     final orderSnapshot = await orderRef.get();

  //     if (orderSnapshot.exists) {
  //       List<dynamic> ordersList = orderSnapshot['orders'] ?? [];
  //       for (var order in ordersList) {
  //         if (order['orderId'] == orderId) {
  //           final medicines = order['medicines'] as List<dynamic>? ?? [];

  //           // Reduce medicine quantities
  //           for (var medicine in medicines) {
  //             final medicineMap = Map<String, dynamic>.from(medicine);

  //             // Reduce quantity in global stock
  //             await _reduceMedicineQuantity(
  //               medicineMap['name'],
  //               medicineMap['quantity'],
  //             );

  //             // Add/Update medicine in hospital stock
  //             await _updateHospitalStock(
  //               widget.hospitalId, // Current hospital ID
  //               medicineMap['name'], // Medicine name
  //               medicineMap['quantity'], // Quantity to add
  //             );
  //           }

  //           // Update order status
  //           order['status'] = 'success';
  //           break;
  //         }
  //       }

  //       // Update the Firestore document with modified orders
  //       await orderRef.update({'orders': ordersList});
  //     }

  //     // Remove the card from the UI
  //     setState(() {
  //       orders.removeWhere((order) =>
  //           order['orderId'] == orderId &&
  //           order['manufacturerId'] == manufacturerId);
  //     });

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Order marked as Success!')),
  //     );
  //   } catch (e) {
  //     print("Error updating order status: $e");
  //   }
  // }

  Future<void> _updateHospitalStock(
      String hospitalId, String medicineName, int quantityToAdd) async {
    try {
      // Reference to the hospital_stock collection
      final stockRef = FirebaseFirestore.instance
          .collection("hospital_stock")
          .doc(medicineName);

      final stockSnapshot = await stockRef.get();

      if (stockSnapshot.exists) {
        // Update existing stock
        int currentStock = stockSnapshot['quantity'] ?? 0;
        int updatedStock = currentStock + quantityToAdd;

        await stockRef.update({'quantity': updatedStock});
      } else {
        // Create new stock document
        await stockRef.set({
          'hospitalId': hospitalId,
          'name': medicineName,
          'quantity': quantityToAdd,
        });
      }
    } catch (e) {
      print("Error updating hospital stock: $e");
    }
  }

//////////////
  Future<void> _reduceMedicineQuantity(
      String medicineName, int quantityToReduce) async {
    try {
      // Reference to the medicine document
      final medicineRef =
          FirebaseFirestore.instance.collection("medicine").doc(medicineName);

      // Fetch current quantity
      final medicineSnapshot = await medicineRef.get();

      if (medicineSnapshot.exists) {
        int currentQuantity = medicineSnapshot['quantity'] ?? 0;

        // Calculate new quantity
        int updatedQuantity = currentQuantity - quantityToReduce;
        if (updatedQuantity < 0) {
          updatedQuantity = 0; // Prevent negative quantity
        }

        // Update Firestore document
        await medicineRef.update({'quantity': updatedQuantity});
      } else {
        print("Medicine $medicineName not found in the database.");
      }
    } catch (e) {
      print("Error reducing medicine quantity: $e");
    }
  }

  void _showQrDialog(Map<String, dynamic> order) {
    // Generate QR code data
    final qrData = jsonEncode({
      'orderId': order['orderId'],
      'hospitalId': order['hospitalId'],
      'manufacturerId': order['manufacturerId'],
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

  Future<void> _processOrder(
      String orderId, String manufacturerId, List<dynamic> medicines) async {
    try {
      for (var medicine in medicines) {
        final medicineMap = Map<String, dynamic>.from(medicine);
        final productId = medicineMap['productId'];
        final orderedQuantity = medicineMap['quantity'];

        // Fetch medicine details from the 'medicine' collection
        final medicineSnapshot = await FirebaseFirestore.instance
            .collection("medicine")
            .doc(productId)
            .get();

        if (medicineSnapshot.exists) {
          final data = medicineSnapshot.data()!;
          final category = data['category'] as String;
          final newCollectionName = category;

          // Prepare data to be added to the new collection
          final newMedicineData = {
            'productId': productId,
            'category': category,
            'imageUrl': data['imageUrl'],
            'mdate': data['mdate'],
            'edate': data['edate'],
            'medicenName': data['medicenName'],
            'price': data['price'],
            'quantity': orderedQuantity, // Only the ordered quantity is added
          };

          // Add the data to the new collection based on the category
          final categoryCollectionRef =
              FirebaseFirestore.instance.collection(newCollectionName);

          final categoryDocSnapshot =
              await categoryCollectionRef.doc(productId).get();
          if (categoryDocSnapshot.exists) {
            // Update existing document's quantity
            final currentQuantity =
                categoryDocSnapshot.data()?['quantity'] ?? 0;
            final updatedQuantity = currentQuantity + orderedQuantity;
            await categoryCollectionRef
                .doc(productId)
                .update({'quantity': updatedQuantity});
          } else {
            // Create a new document if it doesn't exist
            await categoryCollectionRef.doc(productId).set(newMedicineData);
          }

          // Reduce the quantity in the global 'medicine' collection
          final currentGlobalQuantity = data['quantity'] ?? 0;
          final updatedGlobalQuantity = currentGlobalQuantity - orderedQuantity;

          // Prevent negative quantity
          await FirebaseFirestore.instance
              .collection("medicine")
              .doc(productId)
              .update({
            'quantity': updatedGlobalQuantity < 0 ? 0 : updatedGlobalQuantity
          });
        } else {
          print("Medicine with productId $productId not found.");
        }
      }

      // After processing medicines, update the order status
      await _updateOrderStatus(orderId, manufacturerId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order processed successfully!')),
      );
    } catch (e) {
      print("Error processing order: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to process order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Received Orders',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(
                  child: Text(
                    'No received orders available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
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
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order ID: ${order['orderId'] ?? 'N/A'}',
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.qr_code),
                                      onPressed: () => _showQrDialog(order),
                                      tooltip: 'View QR Code',
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 1, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: order['status'] == 'Delivered'
                                            ? Colors.green.withOpacity(0.2)
                                            : Colors.orange.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        order['status'] ?? 'Unknown',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: order['status'] == 'Delivered'
                                              ? Colors.green
                                              : Colors.orange,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.factory,
                                    color: Colors.blueGrey, size: 16),
                                const SizedBox(width: 5),
                                Text(
                                  'Manufacturer ID: ${order['manufacturerId'] ?? 'N/A'}',
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 20, color: Colors.grey),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: medicines.map((medicine) {
                                final medicineMap =
                                    Map<String, dynamic>.from(medicine);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
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
                                              medicineMap['name'] ?? 'Unknown',
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
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            const Divider(height: 20, color: Colors.grey),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  '\$${order['totalPrice']?.toStringAsFixed(2) ?? '0.00'}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    final medicines =
                                        order['medicines'] as List<dynamic>? ??
                                            [];

                                    for (var medicine in medicines) {
                                      final medicineMap =
                                          Map<String, dynamic>.from(medicine);
                                      final productId =
                                          medicineMap['productId'];
                                      final orderedQuantity =
                                          medicineMap['quantity'];

                                      try {
                                        // Step 1: Fetch medicine details from Firestore
                                        final medicineRef = FirebaseFirestore
                                            .instance
                                            .collection("medicine")
                                            .doc(productId);
                                        final medicineSnapshot =
                                            await medicineRef.get();

                                        if (medicineSnapshot.exists) {
                                          final data = medicineSnapshot.data()!;
                                          final currentQuantity =
                                              data['quantity'] ?? 0;

                                          // Step 2: Calculate the new quantity
                                          final updatedQuantity =
                                              (currentQuantity -
                                                      orderedQuantity)
                                                  .clamp(0, double.infinity);

                                          // Step 3: Update the `medicine` collection with the reduced quantity
                                          await medicineRef.update(
                                              {'quantity': updatedQuantity});

                                          // Step 4: Update the hospital inventory
                                          final category =
                                              data['category'] as String;

                                          final inventoryData = {
                                            'productId': productId,
                                            'category': category,
                                            'imageUrl': data['imageUrl'],
                                            'mdate': data['mdate'],
                                            'edate': data['edate'],
                                            'medicenName': data['medicenName'],
                                            'price': data['price'],
                                            'quantity':
                                                orderedQuantity, // Use ordered quantity for inventory
                                          };

                                          final inventoryCollectionRef =
                                              FirebaseFirestore.instance
                                                  .collection(
                                                      "hospital_inventory");

                                          final categoryDocSnapshot =
                                              await inventoryCollectionRef
                                                  .doc(category)
                                                  .get();

                                          if (categoryDocSnapshot.exists) {
                                            // Update existing document's quantity
                                            final existingMedicines =
                                                categoryDocSnapshot
                                                        .data()?['medicines'] ??
                                                    [];

                                            final List<dynamic>
                                                updatedMedicines =
                                                List.from(existingMedicines);
                                            bool medicineExists = false;

                                            for (var med in updatedMedicines) {
                                              if (med['productId'] ==
                                                  productId) {
                                                med['quantity'] +=
                                                    orderedQuantity;
                                                medicineExists = true;
                                                break;
                                              }
                                            }

                                            if (!medicineExists) {
                                              updatedMedicines
                                                  .add(inventoryData);
                                            }

                                            await inventoryCollectionRef
                                                .doc(category)
                                                .update({
                                              'medicines': updatedMedicines,
                                            });
                                          } else {
                                            // Create a new document if it doesn't exist
                                            await inventoryCollectionRef
                                                .doc(category)
                                                .set({
                                              'category': category,
                                              'medicines': [inventoryData],
                                            });
                                          }
                                        } else {
                                          print(
                                              "Medicine with productId $productId not found.");
                                        }
                                      } catch (e) {
                                        print(
                                            "Error processing medicine with productId $productId: $e");
                                      }
                                    }

                                    // Step 5: Call the order processing logic
                                    try {
                                      await _processOrder(order['orderId'],
                                          order['manufacturerId'], medicines);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Order processed successfully!')),
                                      );
                                    } catch (e) {
                                      print("Error processing order: $e");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Failed to process order: $e')),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  child: Text(order['status'] == 'success'
                                      ? 'Success'
                                      : 'Done'),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        color: Colors.grey, size: 16),
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
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
