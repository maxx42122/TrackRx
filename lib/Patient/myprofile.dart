// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class Myprofile extends StatefulWidget {
//   const Myprofile({super.key});

//   @override
//   State createState() => _MyprofileState();
// }

// class _MyprofileState extends State {
//   bool? selectgender1 = false;
//   bool? selectgender2 = false;

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController datecontroller = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "My Profile",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
//         ),
//         backgroundColor: const Color.fromRGBO(
//           5,
//           77,
//           154,
//           1,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             GestureDetector(
//               onTap: () {},
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 45.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Stack(children: [
//                       Container(
//                           child: const Icon(
//                         Icons.account_circle,
//                         color: Color.fromARGB(255, 37, 61, 179),
//                         size: 150,
//                       )),
//                       Positioned(
//                           bottom: 5,
//                           right: 5,
//                           child: Container(
//                               decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Color.fromARGB(255, 37, 61, 179),
//                               ),
//                               child: const Icon(
//                                 Icons.add,
//                                 color: Colors.white,
//                                 size: 18,
//                               )))
//                     ]),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 40,
//             ),
//             const Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       labelText:
//                           'First Name', // Text that appears on the border
//                       floatingLabelBehavior: FloatingLabelBehavior
//                           .always, // Keeps label on the border line
//                       border: OutlineInputBorder(),
//                       labelStyle: TextStyle(
//                         color: Color.fromARGB(
//                             255, 37, 61, 179), // Customize label color
//                         fontSize: 18, // Customize label size
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       labelText: 'Last Name', // Text that appears on the border
//                       floatingLabelBehavior: FloatingLabelBehavior
//                           .always, // Keeps label on the border line
//                       border: OutlineInputBorder(),
//                       labelStyle: TextStyle(
//                         color: Color.fromARGB(
//                             255, 37, 61, 179), // Customize label color
//                         fontSize: 18, // Customize label size
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             const TextField(
//               decoration: InputDecoration(
//                 labelText: 'Mobile', // Text that appears on the border
//                 floatingLabelBehavior: FloatingLabelBehavior
//                     .always, // Keeps label on the border line
//                 border: OutlineInputBorder(),
//                 labelStyle: TextStyle(
//                   color:
//                       Color.fromARGB(255, 37, 61, 179), // Customize label color
//                   fontSize: 18, // Customize label size
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),

// ////////////////////////////////////////////////////////////////////////////////////////////////////
//             Row(
//               children: [
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         if (selectgender1 == false) {
//                           selectgender1 = true;
//                           selectgender2 = false;

//                           print("on tap chya if madhe alo111111111");
//                         } else {
//                           selectgender1 = false;
//                           selectgender2 = true;

//                           print("on tap chya else madhe alo222222222222222");
//                         }
//                       });
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(12),
//                       color: selectgender1!
//                           ? const Color.fromARGB(255, 224, 215, 215)
//                           : const Color.fromRGBO(
//                               5,
//                               77,
//                               154,
//                               1,
//                             ),
//                       //checkgender(selectgender1, selectgender2),
//                       child: const Row(
//                         children: [Icon(Icons.boy_sharp), Text("Male")],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         if (selectgender2 == true) {
//                           selectgender2 = false;
//                           selectgender1 = true;

//                           print("on tap chya if madhe alo3333333333333333");
//                         } else {
//                           selectgender2 = true;
//                           selectgender1 = false;

//                           print("on tap chya else madhe alo4444444444444444");
//                         }
//                       });
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: selectgender2!
//                             ? const Color.fromARGB(255, 224, 215, 215)
//                             : const Color.fromRGBO(
//                                 5,
//                                 77,
//                                 154,
//                                 1,
//                               ),
//                         //checkgender(selectgender1, selectgender2),
//                       ),
//                       child: const Row(
//                         children: [Icon(Icons.girl_outlined), Text("Female")],
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),

//             //////////////////////////////////////////////////////////////////////////////////////////////////////
//             const SizedBox(
//               height: 15,
//             ),
//             TextField(
//               readOnly: true,
//               decoration: const InputDecoration(
//                   labelText: 'Date of Birth',
//                   floatingLabelBehavior: FloatingLabelBehavior.always,
//                   labelStyle: TextStyle(
//                     color: Color.fromARGB(
//                         255, 37, 61, 179), // Customize label color
//                     fontSize: 18, // Customize label size
//                   ),
//                   border: OutlineInputBorder(),
//                   focusedBorder: OutlineInputBorder(
//                       borderSide:
//                           BorderSide(color: Color.fromARGB(255, 101, 81, 255))),
//                   suffixIcon: Icon(Icons.calendar_month)),
//               onTap: () async {
//                 DateTime? pickedDate = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime(2024),
//                   lastDate: DateTime(2025),
//                 );

//                 if (pickedDate != null) {
//                   String formattedDate = DateFormat.yMMMd().format(pickedDate);
//                   setState(() {
//                     datecontroller.text = formattedDate;
//                   });
//                 }
//               },
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             const Text("Blood Group"),
//             const SizedBox(
//               height: 10,
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         color: const Color.fromARGB(255, 224, 215, 215),
//                         child: const Text(
//                           "A+",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w800,
//                               color: Color.fromARGB(255, 101, 81, 255)),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         color: const Color.fromARGB(255, 224, 215, 215),
//                         child: const Text(
//                           "A-",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w800,
//                               color: Color.fromARGB(255, 101, 81, 255)),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         color: const Color.fromARGB(255, 224, 215, 215),
//                         child: const Text(
//                           "B+",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w800,
//                               color: Color.fromARGB(255, 101, 81, 255)),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         color: const Color.fromARGB(255, 224, 215, 215),
//                         child: const Text(
//                           "B-",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w800,
//                               color: Color.fromARGB(255, 101, 81, 255)),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         color: const Color.fromARGB(255, 224, 215, 215),
//                         child: const Text(
//                           "O+",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w800,
//                               color: Color.fromARGB(255, 101, 81, 255)),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         color: const Color.fromARGB(255, 224, 215, 215),
//                         child: const Text(
//                           "O-",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w800,
//                               color: Color.fromARGB(255, 101, 81, 255)),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         color: const Color.fromARGB(255, 224, 215, 215),
//                         child: const Text(
//                           "AB+",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w800,
//                               color: Color.fromARGB(255, 101, 81, 255)),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         color: const Color.fromARGB(255, 224, 215, 215),
//                         child: const Text(
//                           "AB-",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w800,
//                               color: Color.fromARGB(255, 101, 81, 255)),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                   ],
//                 )
//               ],
//             ),
//             const Spacer(),
//             Container(
//               width: MediaQuery.of(context).size.width,
//               height: 50,
//               padding: const EdgeInsets.all(12),
//               color: const Color.fromARGB(255, 37, 61, 179),
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.check_circle,
//                     color: Colors.white,
//                   ),
//                   Text(
//                     "Submit",
//                     style: TextStyle(color: Color.fromARGB(255, 248, 247, 249)),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  late String email;
  late String name;
  late String age;
  late String gender;
  late String imageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  // Fetch the user details from Firestore
  Future<void> _fetchUserDetails() async {
    try {
      // Get the current user's email from FirebaseAuth
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        email = user.email ?? '';

        // Get the user's data from Firestore using their email as document ID
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('user')
            .doc(email)
            .get();

        if (doc.exists) {
          setState(() {
            name = doc['name'] ?? 'No Name';
            age = doc['age'] ?? 'Unknown Age';
            gender = doc['gender'] ?? 'Unknown Gender';
            imageUrl = doc['imageUrl'] ?? '';
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User data not found!')),
          );
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching user data!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: const Color(0xFF3A3A3A),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: imageUrl.isNotEmpty
                        ? NetworkImage(imageUrl)
                        : const AssetImage('assets/default_avatar.png')
                            as ImageProvider,
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Name: $name',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Email: $email',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Age: $age',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Gender: $gender',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
    );
  }
}
