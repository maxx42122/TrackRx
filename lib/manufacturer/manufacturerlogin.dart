// // import 'dart:async';
// // import 'dart:math';

// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:flutter/gestures.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:trackrx/manufacturer/manufaturerregister.dart';
// // import 'package:firebase_auth/firebase_auth.dart';

// // import 'homepage.dart';

// // class Login extends StatefulWidget {
// //   const Login({Key? key}) : super(key: key);

// //   @override
// //   State<Login> createState() => _LoginState();
// // }

// // class _LoginState extends State<Login> {
// //   bool hidePassword = true;
// //   final TextEditingController emailController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();
// //   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

// //   late PageController _pageController;
// //   int _currentPage = 0;
// //   late Timer _timer;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _pageController = PageController(initialPage: 0);

// //     _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
// //       if (_currentPage < 4) {
// //         _currentPage++;
// //         _pageController.animateToPage(
// //           _currentPage,
// //           duration: Duration(milliseconds: 600),
// //           curve: Curves.easeInOut,
// //         );
// //       } else {
// //         // Loop back to the first page without animation
// //         _currentPage = 0;
// //         _pageController.jumpToPage(_currentPage);
// //       }
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _timer.cancel();
// //     _pageController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final screenHeight = MediaQuery.of(context).size.height;
// //     final screenWidth = MediaQuery.of(context).size.width;

// //     return Scaffold(
// //       body: SingleChildScrollView(
// //         child: Stack(
// //           children: [
// //             // Background Image
// //             Column(
// //               children: [
// //                 SizedBox(
// //                   height: screenHeight,
// //                   width: screenWidth,
// //                   child: PageView(
// //                     controller: _pageController,
// //                     onPageChanged: (index) {
// //                       setState(() {
// //                         _currentPage = index;
// //                       });
// //                     },
// //                     children: [
// //                       Image.asset(
// //                         "assets/manufacturer/logb1.jpg",
// //                         fit: BoxFit.cover,
// //                       ),
// //                       Image.asset(
// //                         "assets/manufacturer/logb5.jpg",
// //                         fit: BoxFit.cover,
// //                       ),
// //                       Image.asset(
// //                         "assets/manufacturer/logb2.jpg",
// //                         fit: BoxFit.cover,
// //                       ),
// //                       Image.asset(
// //                         "assets/manufacturer/logb3.jpg",
// //                         fit: BoxFit.cover,
// //                       ),
// //                       Image.asset(
// //                         "assets/manufacturer/logb4.jpg",
// //                         fit: BoxFit.cover,
// //                       ),
// //                     ],
// //                   ),

// //                   // loadingBuilder: (context, child, loadingProgress) {
// //                   //   if (loadingProgress == null) return child;
// //                   //   return const Center(child: CircularProgressIndicator());
// //                   // },
// //                 ),
// //               ],
// //             ),

// //             // Login Form
// //             Padding(
// //               padding: const EdgeInsets.only(top: 250, left: 30),
// //               child: Container(
// //                 width: screenWidth * 0.85,
// //                 padding:
// //                     const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
// //                 decoration: BoxDecoration(
// //                   color: Colors.white70,
// //                   borderRadius: BorderRadius.circular(20),
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.black.withOpacity(0.1),
// //                       blurRadius: 10,
// //                       offset: const Offset(0, 5),
// //                     ),
// //                   ],
// //                 ),
// //                 child: SingleChildScrollView(
// //                   dragStartBehavior: DragStartBehavior.start,
// //                   child: Column(
// //                     children: [
// //                       Text(
// //                         "Sign in",
// //                         style: GoogleFonts.almarai(
// //                           fontSize: 36,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                       const SizedBox(height: 20),
// //                       _buildTextField(
// //                         controller: emailController,
// //                         label: "Enter Email",
// //                         isPassword: false,
// //                       ),
// //                       const SizedBox(height: 20),
// //                       _buildTextField(
// //                         controller: passwordController,
// //                         label: "Password",
// //                         isPassword: true,
// //                       ),
// //                       const SizedBox(height: 10),
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           const Text("Don't have an account? ",
// //                               style: TextStyle(color: Colors.black54)),
// //                           GestureDetector(
// //                             onTap: () {
// //                               Navigator.push(
// //                                 context,
// //                                 MaterialPageRoute(
// //                                   builder: (context) => const Register(),
// //                                 ),
// //                               );
// //                             },
// //                             child: const Text(
// //                               "Register now!",
// //                               style: TextStyle(
// //                                 color: Colors.blue,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 30),
// //                       ElevatedButton(
// //                         style: ElevatedButton.styleFrom(
// //                           padding: const EdgeInsets.symmetric(
// //                               horizontal: 40, vertical: 15),
// //                           backgroundColor:
// //                               const Color.fromRGBO(117, 164, 136, 1.0),
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(10),
// //                           ),
// //                         ),
// //                         onPressed: () {
// //                           if (emailController.text.trim().isNotEmpty &&
// //                               passwordController.text.trim().isNotEmpty) {
// //                             // try{
// //                             //   await _firebaseAuth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);

// //                             Navigator.of(context).pushReplacement(
// //                                 MaterialPageRoute(builder: (context) {
// //                               return Home(
// //                                   // email:UserCredential.user!.email!,
// //                                   );
// //                             }));
// //                           } else {
// //                             ScaffoldMessenger.of(context).showSnackBar(
// //                               const SnackBar(
// //                                 content: Text(
// //                                   "Please enter valid credentials!",
// //                                   style: TextStyle(color: Colors.white),
// //                                 ),
// //                                 backgroundColor: Colors.red,
// //                               ),
// //                             );
// //                           }
// //                         },
// //                         //onPressed: () {},
// //                         child: const Padding(
// //                           padding: EdgeInsets.only(left: 5, right: 5),
// //                           child: Text(
// //                             "Sign in",
// //                             style: TextStyle(
// //                               fontSize: 20,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildTextField({
// //     required TextEditingController controller,
// //     required String label,
// //     required bool isPassword,
// //   }) {
// //     return TextField(
// //       controller: controller,
// //       obscureText: isPassword && hidePassword,
// //       decoration: InputDecoration(
// //         labelText: label,
// //         suffixIcon: isPassword
// //             ? GestureDetector(
// //                 onTap: () {
// //                   setState(() {
// //                     hidePassword = !hidePassword;
// //                   });
// //                 },
// //                 child: Icon(
// //                   hidePassword ? Icons.visibility_off : Icons.visibility,
// //                 ),
// //               )
// //             : null,
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(10),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';

// class MedicinePage extends StatefulWidget {
//   const MedicinePage({super.key});

//   @override
//   _MedicinePageState createState() => _MedicinePageState();
// }

// class _MedicinePageState extends State<MedicinePage> {
//   /////////////
//   File? _image; // To store the picked image
//   List<String> droplist = <String>[
//     'Cardiac',
//     'Antibiotics',
//     'Pain Management',
//     'Osteoarthritis',
//     'Hypertension',
//     'High Cholesterol',
//     'Eye/Ear',
//     'Diabetes'
//   ];
//   String? dropvalue;

//   void showBottomSheetAddMedicen() {
//     showModalBottomSheet(
//       isScrollControlled: true,
//       context: context,
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 20,
//             right: 20,
//             top: 20,
//           ),
//           child: StatefulBuilder(
//             builder: (context, setState) {
//               Future<void> pickImage() async {
//                 final picker = ImagePicker();
//                 final pickedFile = await picker.pickImage(
//                   source: ImageSource.gallery,
//                   imageQuality: 50,
//                 );
//                 if (pickedFile != null) {
//                   setState(() {
//                     _image = File(pickedFile.path);
//                   });
//                 }
//               }

//               Future<void> addMedicine() async {
//                 if (_image == null ||
//                     medicenameController.text.trim().isEmpty ||
//                     productidcontroller.text.trim().isEmpty ||
//                     manufacturedatecontroller.text.trim().isEmpty ||
//                     expirydatecontroller.text.trim().isEmpty ||
//                     pricecontroller.text.trim().isEmpty ||
//                     quantitycontroller.text.trim().isEmpty ||
//                     categorycontoller.text.trim().isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Invalid Data")),
//                   );
//                   return;
//                 }

//                 try {
//                   // Upload image to Firebase Storage
//                   String fileName = DateTime.now().toString();
//                   Reference storageRef = FirebaseStorage.instance
//                       .ref()
//                       .child('medicines_images/$fileName');
//                   UploadTask uploadTask = storageRef.putFile(_image!);
//                   await uploadTask;
//                   String imageUrl = await storageRef.getDownloadURL();

//                   // Prepare data to add to Firestore
//                   String productId = productidcontroller.text.trim();
//                   Map<String, dynamic> stockData = {
//                     "medicenName": medicenameController.text.trim(),
//                     "productId": productId,
//                     "mdate": manufacturedatecontroller.text.trim(),
//                     "edate": expirydatecontroller.text.trim(),
//                     "price": pricecontroller.text.trim(),
//                     "quantity": quantitycontroller.text.trim(),
//                     "category": categorycontoller.text.trim(),
//                     "imageUrl": imageUrl,
//                   };

//                   // Add to Firestore with document ID as productId
//                   await FirebaseFirestore.instance
//                       .collection("medicine")
//                       .doc(productId) // Use productId as document ID
//                       .set(stockData);

//                   // Clear fields and image
//                   medicenameController.clear();
//                   productidcontroller.clear();
//                   manufacturedatecontroller.clear();
//                   expirydatecontroller.clear();
//                   pricecontroller.clear();
//                   quantitycontroller.clear();
//                   categorycontoller.clear();
//                   setState(() {
//                     _image = null;
//                   });

//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text(
//                         "Data Added Successfully",
//                         style: TextStyle(
//                             color: Colors.cyanAccent,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w400),
//                       ),
//                     ),
//                   );
//                   Navigator.pop(context);
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("Error: $e")),
//                   );
//                 }
//               }

//               Widget buildTextField({
//                 required TextEditingController controller,
//                 required String labelText,
//                 IconData? suffixIcon,
//                 VoidCallback? onTap,
//                 TextInputType keyboardType = TextInputType.text,
//               }) {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextField(
//                     controller: controller,
//                     keyboardType: keyboardType,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       labelText: labelText,
//                       suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
//                     ),
//                     readOnly: onTap != null,
//                     onTap: onTap,
//                   ),
//                 );
//               }

//               return SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Center(
//                       child: Text(
//                         "Medicens",
//                         style: GoogleFonts.almarai(
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     GestureDetector(
//                       onTap: pickImage,
//                       child: Container(
//                         height: 100,
//                         width: 100,
//                         clipBehavior: Clip.antiAlias,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(),
//                           color: const Color.fromRGBO(0, 0, 0, 0.05),
//                         ),
//                         child: _image == null
//                             ? const Icon(Icons.add_a_photo, size: 50)
//                             : Image.file(_image!, fit: BoxFit.cover),
//                       ),
//                     ),
//                     buildTextField(
//                       controller: medicenameController,
//                       labelText: "Name of Medicine",
//                     ),
//                     buildTextField(
//                       controller: productidcontroller,
//                       labelText: "Product ID",
//                     ),
//                     buildTextField(
//                       controller: manufacturedatecontroller,
//                       labelText: "Manufacture Date",
//                       suffixIcon: Icons.calendar_month_outlined,
//                       onTap: () async {
//                         DateTime? pickedDate = await showDatePicker(
//                           context: context,
//                           firstDate: DateTime(2024),
//                           lastDate: DateTime(2025),
//                         );
//                         if (pickedDate != null) {
//                           manufacturedatecontroller.text =
//                               DateFormat.yMMMd().format(pickedDate);
//                         }
//                       },
//                     ),
//                     buildTextField(
//                       controller: expirydatecontroller,
//                       labelText: "Expiry Date",
//                       suffixIcon: Icons.calendar_month_outlined,
//                       onTap: () async {
//                         DateTime? pickedDate = await showDatePicker(
//                           context: context,
//                           firstDate: DateTime(2024),
//                           lastDate: DateTime(2025),
//                         );
//                         if (pickedDate != null) {
//                           expirydatecontroller.text =
//                               DateFormat.yMMMd().format(pickedDate);
//                         }
//                       },
//                     ),
//                     buildTextField(
//                       controller: pricecontroller,
//                       labelText: "Price",
//                       keyboardType: TextInputType.number,
//                     ),
//                     buildTextField(
//                       controller: quantitycontroller,
//                       labelText: "Quantity",
//                       keyboardType: TextInputType.number,
//                     ),
//                     buildTextField(
//                       controller: categorycontoller,
//                       labelText: "Category",
//                       suffixIcon: Icons.arrow_drop_down,
//                       onTap: () async {
//                         // Assuming `droplist` and `dropvalue` are pre-defined
//                         String? selectedCategory =
//                             await showModalBottomSheet<String>(
//                           context: context,
//                           builder: (_) => ListView(
//                             children: droplist
//                                 .map(
//                                   (category) => ListTile(
//                                     title: Text(category),
//                                     onTap: () =>
//                                         Navigator.pop(context, category),
//                                   ),
//                                 )
//                                 .toList(),
//                           ),
//                         );
//                         if (selectedCategory != null) {
//                           setState(() {
//                             dropvalue = selectedCategory;
//                             categorycontoller.text = selectedCategory;
//                           });
//                         }
//                       },
//                     ),
//                     const SizedBox(height: 10),
//                     GestureDetector(
//                       onTap: addMedicine,
//                       child: Container(
//                         height: 45,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(),
//                         ),
//                         alignment: Alignment.center,
//                         child: Text(
//                           "Add Medicine",
//                           style: GoogleFonts.poppins(
//                               fontSize: 15, fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   //////////////////////
//   final TextEditingController medicenameController = TextEditingController();
//   final TextEditingController productidcontroller = TextEditingController();
//   final TextEditingController manufacturedatecontroller =
//       TextEditingController();
//   final TextEditingController expirydatecontroller = TextEditingController();
//   final TextEditingController pricecontroller = TextEditingController();
//   final TextEditingController quantitycontroller = TextEditingController();
//   final TextEditingController categorycontoller = TextEditingController();

//   Future<void> _addOrUpdateMedicine() async {
//     String productId = productidcontroller.text.trim();
//     int newQuantity = int.tryParse(quantitycontroller.text.trim()) ?? 0;

//     if (productId.isEmpty || newQuantity <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Invalid Data")),
//       );
//       return;
//     }

//     try {
//       // Reference to the document with productId
//       DocumentReference docRef =
//           FirebaseFirestore.instance.collection("medicine").doc(productId);

//       DocumentSnapshot docSnapshot = await docRef.get();

//       if (docSnapshot.exists) {
//         // If productId exists, update the quantity
//         int currentQuantity = docSnapshot.get("quantity");
//         await docRef.update({
//           "quantity": currentQuantity + newQuantity,
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text("Quantity updated for product ID: $productId")),
//         );
//       } else {
//         // If productId does not exist, create a new document
//         await docRef.set({
//           "medicenName": medicenameController.text.trim(),
//           "productId": productId,
//           "mdate": manufacturedatecontroller.text.trim(),
//           "edate": expirydatecontroller.text.trim(),
//           "price": pricecontroller.text.trim(),
//           "quantity": newQuantity,
//           "category": categorycontoller.text.trim(),
//           "imageUrl": "", // Add image upload logic if required
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text("New medicine added with product ID: $productId")),
//         );
//       }

//       // Clear input fields
//       medicenameController.clear();
//       productidcontroller.clear();
//       manufacturedatecontroller.clear();
//       expirydatecontroller.clear();
//       pricecontroller.clear();
//       quantitycontroller.clear();
//       categorycontoller.clear();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   }

//   // Open Update Dialog
//   void _showUpdateDialog(Map<String, dynamic> medicineData) {
//     // Pre-fill the fields with existing data
//     medicenameController.text = medicineData["medicenName"] ?? "";
//     productidcontroller.text = medicineData["productId"] ?? "";
//     manufacturedatecontroller.text = medicineData["mdate"] ?? "";
//     expirydatecontroller.text = medicineData["edate"] ?? "";
//     pricecontroller.text = medicineData["price"] ?? "";
//     quantitycontroller.text = medicineData["quantity"].toString();
//     categorycontoller.text = medicineData["category"] ?? "";

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Update Medicine"),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: medicenameController,
//                 decoration: const InputDecoration(labelText: "Medicine Name"),
//               ),
//               TextField(
//                 controller: manufacturedatecontroller,
//                 decoration:
//                     const InputDecoration(labelText: "Manufacture Date"),
//               ),
//               TextField(
//                 controller: expirydatecontroller,
//                 decoration: const InputDecoration(labelText: "Expiry Date"),
//               ),
//               TextField(
//                 controller: pricecontroller,
//                 decoration: const InputDecoration(labelText: "Price"),
//               ),
//               TextField(
//                 controller: quantitycontroller,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(labelText: "Quantity"),
//               ),
//               TextField(
//                 controller: categorycontoller,
//                 decoration: const InputDecoration(labelText: "Category"),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               _addOrUpdateMedicine();
//               Navigator.pop(context);
//             },
//             child: const Text("Update"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Medicines"),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection("medicine").snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text("No medicines found."));
//           }

//           final medicines = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: medicines.length,
//             itemBuilder: (context, index) {
//               final medicine = medicines[index];
//               final medicineData = medicine.data() as Map<String, dynamic>;

//               return Card(
//                 margin: const EdgeInsets.all(8.0),
//                 child: ListTile(
//                   leading: medicineData["imageUrl"] != null &&
//                           medicineData["imageUrl"].isNotEmpty
//                       ? Image.network(
//                           medicineData["imageUrl"],
//                           height: 50,
//                           width: 50,
//                           fit: BoxFit.cover,
//                         )
//                       : const Icon(Icons.medical_services, size: 50),
//                   title: Text(medicineData["medicenName"] ?? "Unknown"),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Expiry Date: ${medicineData["edate"] ?? "N/A"}"),
//                       Text("Quantity: ${medicineData["quantity"] ?? "0"}"),
//                     ],
//                   ),
//                   trailing: TextButton(
//                     style: const ButtonStyle(
//                         backgroundColor: WidgetStatePropertyAll(Colors.amber)),
//                     child: const Text("Update"),
//                     onPressed: () {
//                       _showUpdateDialog(medicineData);
//                     },
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showBottomSheetAddMedicen();
//         },
//         child: const Icon(Icons.add_outlined),
//       ),
//     );
//   }
// }
