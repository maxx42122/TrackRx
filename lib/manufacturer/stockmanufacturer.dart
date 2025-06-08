import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MedicinePage extends StatefulWidget {
  const MedicinePage({Key? key}) : super(key: key);

  @override
  _MedicinePageState createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage>
    with SingleTickerProviderStateMixin {
  File? _image;
  String searchQuery = "";

  // Dropdown list and value
  List<String> droplist = <String>[
    'Throat',
    'Cardiac',
    'Antibiotics',
    'Pain Management',
    'Osteoarthritis',
    'Hypertension',
    'High Cholesterol',
    'Eye_Ear',
    'Diabetes',
    'Nasal',
    'Vaginal',
    'Vitamins',
    'Antiviral',
    'Sex hormone',
  ];
  String? dropvalue;

  // Controllers for input fields
  final TextEditingController medicenameController = TextEditingController();
  final TextEditingController productidcontroller = TextEditingController();
  final TextEditingController manufacturedatecontroller =
      TextEditingController();
  final TextEditingController expirydatecontroller = TextEditingController();
  final TextEditingController pricecontroller = TextEditingController();
  final TextEditingController quantitycontroller = TextEditingController();
  final TextEditingController categorycontoller = TextEditingController();

  // Floating Action Button Animation Controller
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void showBottomSheetAddMedicine() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              Future<void> pickImage() async {
                final picker = ImagePicker();
                final pickedFile = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 50,
                );
                if (pickedFile != null) {
                  setState(() {
                    _image = File(pickedFile.path);
                  });
                }
              }

              Future<void> addMedicine() async {
                if (_image == null ||
                    medicenameController.text.trim().isEmpty ||
                    productidcontroller.text.trim().isEmpty ||
                    manufacturedatecontroller.text.trim().isEmpty ||
                    expirydatecontroller.text.trim().isEmpty ||
                    pricecontroller.text.trim().isEmpty ||
                    quantitycontroller.text.trim().isEmpty ||
                    categorycontoller.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invalid Data")),
                  );
                  return;
                }

                try {
                  // Convert price and quantity to integers
                  int price = int.tryParse(pricecontroller.text.trim()) ?? 0;
                  int quantity =
                      int.tryParse(quantitycontroller.text.trim()) ?? 0;

                  // Upload image to Firebase Storage
                  String fileName = DateTime.now().toString();
                  Reference storageRef = FirebaseStorage.instance
                      .ref()
                      .child('medicines_images/$fileName');
                  UploadTask uploadTask = storageRef.putFile(_image!);
                  await uploadTask;
                  String imageUrl = await storageRef.getDownloadURL();

                  // Prepare data to add to Firestore
                  String productId = productidcontroller.text.trim();
                  Map<String, dynamic> stockData = {
                    "medicenName": medicenameController.text.trim(),
                    "productId": productId,
                    "mdate": manufacturedatecontroller.text.trim(),
                    "edate": expirydatecontroller.text.trim(),
                    "price": price, // Store as integer
                    "quantity": quantity, // Store as integer
                    "category": categorycontoller.text.trim(),
                    "imageUrl": imageUrl,
                  };

                  // Add to Firestore with document ID as productId
                  await FirebaseFirestore.instance
                      .collection("medicine")
                      .doc(productId) // Use productId as document ID
                      .set(stockData);

                  // Clear fields and image
                  medicenameController.clear();
                  productidcontroller.clear();
                  manufacturedatecontroller.clear();
                  expirydatecontroller.clear();
                  pricecontroller.clear();
                  quantitycontroller.clear();
                  categorycontoller.clear();
                  setState(() {
                    _image = null;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Data Added Successfully",
                        style: TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              }

              Widget buildTextField({
                required TextEditingController controller,
                required String labelText,
                IconData? suffixIcon,
                VoidCallback? onTap,
                TextInputType keyboardType = TextInputType.text,
              }) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    decoration: InputDecoration(
                      labelText: labelText,
                      labelStyle: GoogleFonts.poppins(fontSize: 14),
                      filled: true,
                      fillColor: Colors.grey[100],
                      prefixIcon: suffixIcon != null
                          ? Icon(suffixIcon, color: Colors.teal)
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    readOnly: onTap != null,
                    onTap: onTap,
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        "Add Medicine",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.teal, width: 2),
                          color: Colors.teal.withOpacity(0.1),
                        ),
                        child: _image == null
                            ? const Icon(
                                Icons.add_a_photo_outlined,
                                size: 50,
                                color: Colors.teal,
                              )
                            : ClipOval(
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    buildTextField(
                      controller: medicenameController,
                      labelText: "Name of Medicine",
                      suffixIcon: Icons.label_important_outline,
                    ),
                    buildTextField(
                      controller: productidcontroller,
                      labelText: "Product ID",
                      suffixIcon: Icons.qr_code_outlined,
                    ),
                    buildTextField(
                      controller: manufacturedatecontroller,
                      labelText: "Manufacture Date",
                      suffixIcon: Icons.calendar_today_outlined,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2025),
                        );
                        if (pickedDate != null) {
                          manufacturedatecontroller.text =
                              DateFormat.yMMMd().format(pickedDate);
                        }
                        // Date picker logic here
                      },
                    ),
                    buildTextField(
                      controller: expirydatecontroller,
                      labelText: "Expiry Date",
                      suffixIcon: Icons.date_range_outlined,
                      onTap: () async {
                        DateTime? manufacturerDate;
                        if (manufacturedatecontroller.text.isNotEmpty) {
                          manufacturerDate = DateFormat.yMMMd()
                              .parse(manufacturedatecontroller.text);
                        }

                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: manufacturerDate ?? DateTime.now(),
                          firstDate: manufacturerDate ??
                              DateTime
                                  .now(), // Set minimum date as the manufacturer date or today
                          lastDate: DateTime.now().add(const Duration(
                              days:
                                  3 * 365)), // Add 3 years to the current date
                        );

                        if (pickedDate != null) {
                          expirydatecontroller.text =
                              DateFormat.yMMMd().format(pickedDate);
                        }
                      },
                    ),
                    buildTextField(
                      controller: pricecontroller,
                      labelText: "Price",
                      keyboardType: TextInputType.number,
                      suffixIcon: Icons.currency_rupee_outlined,
                    ),
                    buildTextField(
                      controller: quantitycontroller,
                      labelText: "Quantity",
                      keyboardType: TextInputType.number,
                      suffixIcon: Icons.confirmation_number_outlined,
                    ),
                    const SizedBox(height: 15),
                    buildTextField(
                      controller: categorycontoller,
                      labelText: "Category",
                      suffixIcon: Icons.arrow_drop_down,
                      onTap: () async {
                        // Assuming `droplist` and `dropvalue` are pre-defined
                        String? selectedCategory =
                            await showModalBottomSheet<String>(
                          context: context,
                          builder: (_) => ListView(
                            children: droplist
                                .map(
                                  (category) => ListTile(
                                    title: Text(category),
                                    onTap: () =>
                                        Navigator.pop(context, category),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                        if (selectedCategory != null) {
                          setState(() {
                            dropvalue = selectedCategory;
                            categorycontoller.text = selectedCategory;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: addMedicine,
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Add Medicine",
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _deleteMedicine(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection("medicine")
          .doc(productId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Medicine Deleted Successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void _showUpdateDialog(Map<String, dynamic> medicineData) {
    // Pre-fill the fields with existing data
    medicenameController.text = medicineData["medicenName"] ?? "";
    productidcontroller.text = medicineData["productId"] ?? "";
    manufacturedatecontroller.text = medicineData["mdate"] ?? "";
    expirydatecontroller.text = medicineData["edate"] ?? "";
    pricecontroller.text = (medicineData["price"] ?? 0).toString();
    quantitycontroller.text = (medicineData["quantity"] ?? 0).toString();
    categorycontoller.text = medicineData["category"] ?? "";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Update Medicine",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Icon(Icons.medical_services, color: Colors.teal),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                  medicenameController, "Medicine Name", Icons.medication),
              _buildTextField(manufacturedatecontroller, "Manufacture Date",
                  Icons.date_range),
              _buildTextField(
                  expirydatecontroller, "Expiry Date", Icons.date_range),
              _buildTextField(pricecontroller, "Price", Icons.attach_money,
                  keyboardType: TextInputType.number),
              _buildTextField(
                  quantitycontroller, "Quantity", Icons.add_shopping_cart,
                  keyboardType: TextInputType.number),
              _buildTextField(categorycontoller, "Category", Icons.category),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.teal)),
          ),
          ElevatedButton(
            onPressed: () {
              _updateMedicine(medicineData["productId"]);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text("Update",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.teal),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal.shade200),
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Colors.teal.shade50,
        ),
        keyboardType: keyboardType,
      ),
    );
  }

  Future<void> _updateMedicine(String productId) async {
    try {
      // Convert price and quantity to integers
      int price = int.tryParse(pricecontroller.text.trim()) ?? 0;
      int quantity = int.tryParse(quantitycontroller.text.trim()) ?? 0;

      await FirebaseFirestore.instance
          .collection("medicine")
          .doc(productId)
          .update({
        "medicenName": medicenameController.text.trim(),
        "mdate": manufacturedatecontroller.text.trim(),
        "edate": expirydatecontroller.text.trim(),
        "price": price, // Store as integer
        "quantity": quantity, // Store as integer
        "category": categorycontoller.text.trim(),
      });

      // Clear input fields
      medicenameController.clear();
      productidcontroller.clear();
      manufacturedatecontroller.clear();
      expirydatecontroller.clear();
      pricecontroller.clear();
      quantitycontroller.clear();
      categorycontoller.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Medicine Updated Successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Drug Inventory",
            style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.normal,
            )),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.tealAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("medicine").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No medicines found."));
            }

            final medicines = snapshot.data!.docs;

            // Filter medicines based on search query
            final filteredMedicines = medicines.where((medicine) {
              String medicineName =
                  (medicine["medicenName"] ?? "").toString().toLowerCase();
              return medicineName.contains(searchQuery);
            }).toList();

            // Sort medicines by expiry date
            filteredMedicines.sort((a, b) {
              final aDate = DateFormat.yMMMd().parse(a["edate"]);
              final bDate = DateFormat.yMMMd().parse(b["edate"]);
              return aDate.compareTo(bDate);
            });

            return ListView.builder(
              itemCount: filteredMedicines.length,
              itemBuilder: (context, index) {
                final medicine = filteredMedicines[index];
                final medicineData = medicine.data() as Map<String, dynamic>;

                return Slidable(
                  endActionPane: ActionPane(
                    motion: DrawerMotion(), // Creates a sliding drawer effect
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          _showUpdateDialog(medicineData);
                        },
                        backgroundColor: Colors.blue,
                        icon: Icons.edit,
                        label: 'Update',
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          _deleteMedicine(medicineData["productId"]);
                        },
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.teal.shade50,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: medicineData["imageUrl"] != null &&
                              medicineData["imageUrl"].isNotEmpty
                          ? Image.network(
                              medicineData["imageUrl"],
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.medical_services,
                              size: 60, color: Colors.teal),
                      title: Text(
                        medicineData["medicenName"] ?? "Unknown",
                        style: TextStyle(
                          color: Colors.teal.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Expiry Date: ${medicineData["edate"] ?? "N/A"}",
                            style: TextStyle(
                              color: Colors.teal.shade700,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          Text(
                            "Quantity: ${medicineData["quantity"] ?? "0"}",
                            style: TextStyle(
                              color: Colors.teal.shade700,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _fabController.value * 2.0 * 3.1416,
            child: child,
          );
        },
        child: FloatingActionButton(
          backgroundColor: Colors.teal,
          onPressed: () {
            _fabController.forward(from: 0.0);
            showBottomSheetAddMedicine();
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
