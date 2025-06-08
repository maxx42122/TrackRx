import 'dart:convert'; // Import for jsonEncode
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'takerequest.dart'; // Ensure you're using this package

class PrepareOrder extends StatefulWidget {
  final String hospitalId;
  final String orderId;
  const PrepareOrder({
    super.key,
    required this.hospitalId,
    required this.orderId,
  });

  @override
  _PrepareOrderState createState() => _PrepareOrderState();
}

class _PrepareOrderState extends State<PrepareOrder> {
  String searchQuery = ""; // The search query
  List<Map<String, dynamic>> cart = [];

  // Function to get the total cost
  double getTotalCost() {
    double totalCost = 0.0;
    for (var item in cart) {
      double price = (item['price'] ?? 0).toDouble();
      int quantity = (item['quantity'] ?? 1).toInt();
      totalCost += price * quantity;
    }
    return totalCost;
  }

  // Function to generate QR data
  void generateQR() {
    setState(() {
      // Combine text from multiple fields
      final qrData = jsonEncode({
        'orderId': widget.orderId,
        'hospitalId': widget.hospitalId,
        'totalPrice': getTotalCost(),
        'date': DateTime.now().toString().split(' ')[0],
      });
    });
  }

  // Function to proceed with the order
  void _proceedWithOrder() async {
    if (cart.isEmpty) {
      // Show alert if the cart is empty
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Cart is Empty"),
            content:
                const Text("Please add items to the cart before proceeding."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
      return;
    }

    // Generate QR data based on the order details
    final qrData = jsonEncode({
      'orderId': widget.orderId,
      'hospitalId': widget.hospitalId,
      'totalPrice': getTotalCost(),
      'date': DateTime.now().toString().split(' ')[0],
    });

    // // Create the order object
    // final order = {
    //   'orderId': widget.orderId,
    //   'status': 'Pending',
    //   'date': DateTime.now().toString().split(' ')[0],
    //   'totalPrice': getTotalCost(),
    //   'medicines': cart,
    //   'hospitalId': widget.hospitalId,
    //   'qrData': qrData,
    // };

    final productIds = cart.map((item) => item['productId']).toList();
    final order = {
      'orderId': widget.orderId,
      'status': 'Pending',
      'date': DateTime.now().toString().split(' ')[0],
      'totalPrice': getTotalCost(),
      'medicines': cart,
      'hospitalId': widget.hospitalId,
      'qrData': qrData,
      'productIds': productIds, // Add product IDs as a separate field
    };

    try {
      // Retrieve the current user
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No user is currently logged in.");
      }
      String userEmail = currentUser.email ?? "";

      // Fetch the manufacturer details
      DocumentSnapshot manufacturerSnapshot = await FirebaseFirestore.instance
          .collection("manufacturer")
          .doc(userEmail)
          .get();

      if (!manufacturerSnapshot.exists) {
        throw Exception("Manufacturer details not found for the current user.");
      }

      String manufacturerId = manufacturerSnapshot['id'];

      // Save the order in Firestore under the manufacturer
      await FirebaseFirestore.instance
          .collection("manufactureorder")
          .doc(manufacturerId)
          .set({
        'orders': FieldValue.arrayUnion([order]),
      }, SetOptions(merge: true));

      // Clear the cart after the order is successfully placed
      setState(() {
        cart.clear();
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Order Placed"),
            content: const Text("The order has been successfully placed."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle errors and display an error dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text("Failed to place order: $e"),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(156.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30.0), // Adjust the radius as needed
            bottomRight: Radius.circular(30.0), // Adjust the radius as needed
          ),
          child: AppBar(
            backgroundColor:
                Colors.deepPurple, // Use deep purple as primary color
            title: Text(
              "Prepare Order",
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TakeRequestPage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.notification_add, color: Colors.white)),
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            backgroundColor: Colors
                                .deepPurple.shade50, // Dialog background color
                            title: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Your Cart',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                      'Hospital ID: ${widget.hospitalId}', // Display the hospital ID here
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const Icon(Icons.cancel_outlined),
                                )
                              ],
                            ),
                            content: SizedBox(
                              width: double.maxFinite,
                              height: 300, // Adjust height for scrolling
                              child: cart.isEmpty
                                  ? const Center(
                                      child: Text('Your cart is empty.'))
                                  : ListView(
                                      children: cart.map((item) {
                                        return Card(
                                          elevation: 4.0,
                                          margin: const EdgeInsets.all(8.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: ListTile(
                                            title: Text(
                                              item['name'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                              'Product ID: ${item['productId']}\n'
                                              'Quantity: ${item['quantity'] ?? 1} \n'
                                              'Price: Rs${item['price'] ?? 0}',
                                            ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.remove,
                                                      color: Colors.deepPurple),
                                                  onPressed: () {
                                                    setState(() {
                                                      if ((item['quantity'] ??
                                                              1) >
                                                          1) {
                                                        item['quantity'] =
                                                            (item['quantity'] ??
                                                                    1) -
                                                                1;
                                                      } else {
                                                        cart.remove(item);
                                                      }
                                                    });
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.add,
                                                      color: Colors.deepPurple),
                                                  onPressed: () {
                                                    setState(() {
                                                      item['quantity'] =
                                                          (item['quantity'] ??
                                                                  1) +
                                                              1;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                            ),
                            actions: [
                              // Display total cost
                              Text(
                                'Total: Rs${getTotalCost().toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              const SizedBox(width: 65),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close dialog
                                  _proceedWithOrder();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors
                                      .deepPurple, // Use deep purple for Proceed button
                                ),
                                child: const Text(
                                  'Proceed',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
            bottom: PreferredSize(
              preferredSize:
                  const Size.fromHeight(60.0), // Height of the bottom area
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                child: TextField(
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query.toLowerCase(); // Update search query
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Search Medicines",
                    labelStyle: const TextStyle(
                        color: Colors.deepPurple), // Label color
                    prefixIcon: const Icon(Icons.search,
                        color: Colors.deepPurple), // Search icon color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                          color: Colors.deepPurple), // Border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                          color: Colors.deepPurple,
                          width: 2.0), // Focused border
                    ),
                    filled: true,
                    fillColor: Colors.deepPurple.shade50, // Background color
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("medicine").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No medicines found."));
          }

          final medicines = snapshot.data!.docs;
          final filteredMedicines = medicines.where((medicine) {
            String medicineName =
                (medicine["medicenName"] ?? "").toString().toLowerCase();
            return medicineName.contains(searchQuery);
          }).toList();

          return ListView.builder(
            itemCount: filteredMedicines.length,
            itemBuilder: (context, index) {
              final medicine = filteredMedicines[index];
              final medicineData = medicine.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: medicineData["imageUrl"] != null &&
                          medicineData["imageUrl"].isNotEmpty
                      ? Image.network(
                          medicineData["imageUrl"],
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image, color: Colors.deepPurple),
                  title: Text(
                    medicineData["medicenName"] ?? "No name",
                    style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Quantity: ${medicineData['quantity'] ?? 1} \n'
                    'Price: Rs${medicineData['price'] ?? 0} \n'
                    'Product ID: ${medicineData['productId']}',
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // Check if the medicine is already in the cart
                        bool isAlreadyInCart =
                            cart.any((item) => item['id'] == medicine.id);

                        if (!isAlreadyInCart) {
                          // Add the medicine to the cart only if it's not already there
                          cart.add({
                            'id': medicine.id, // Add product ID
                            'name': medicineData["medicenName"],
                            'quantity': 1,
                            'price': double.tryParse(
                                    medicineData["price"].toString()) ??
                                0.0,
                            'productId': medicine
                                .id, // Store Product ID explicitly in the cart
                          });
                        } else {
                          // Optionally, you can show a message to the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${medicineData["medicenName"]} is already in the cart.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.deepPurple, // Button color updated
                    ),
                    child: const Text(
                      "Add to Cart",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
