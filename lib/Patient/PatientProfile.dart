import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For fetching data from Firestore
import 'package:trackrx/AuthenticationPatient/3typelogin.dart';
import 'package:trackrx/AuthenticationPatient/forgotpass.dart';
import 'package:trackrx/Patient/myprofile.dart';
import 'package:trackrx/Patient/vitalpages/datavital.dart';
import '../AuthenticationPatient/SharedPrefencepatient.dart';
import 'bottomnavigationbar.dart';
import 'sqflite/familmember.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = '';
  String email = '';
  String age = '';
  String gender = '';
  String imageUrl = '';
  bool isLoading = true;

  // Fetch user details from Firestore
  void _fetchUserDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('user')
            .doc(user.email) // Assuming the document ID is the user's email
            .get();

        if (doc.exists) {
          setState(() {
            name = doc['name'] ?? 'No Name';
            email = user.email ?? 'No Email';
            age = doc['age'] ?? 'Unknown Age';
            gender = doc['gender'] ?? 'Unknown Gender';
            imageUrl = doc['imageUrl'] ?? ''; // URL for profile picture
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          // Handle case where document does not exist
          print('No user data found in Firestore.');
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9), // Light background color
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 45.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: isLoading
                        ? const CircularProgressIndicator() // Loading spinner
                        : imageUrl.isNotEmpty
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(imageUrl),
                              )
                            : const Icon(
                                Icons.account_circle,
                                color: Color.fromARGB(255, 37, 61, 179),
                                size: 100,
                              ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          name,
                          style: GoogleFonts.quicksand(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 37, 61, 179),
                          ),
                        ),
                ),
              ],
            ),
            isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      _buildDetailRow('Email:', email),
                      _buildDetailRow('Age:', age),
                      _buildDetailRow('Gender:', gender),
                      _buildNavigationItem(
                        context,
                        "Health Vitals",
                        "assets/patient/heart.png",
                        VitalsDataPage(),
                      ),
                      _buildNavigationItem(
                        context,
                        "Family Members",
                        "assets/patient/profile2.png",
                        FamilyMembersInfo(), // Replace with the respective page
                      ),
                      _buildDeleteAccountItem(context),
                      _buildNavigationItem(
                        context,
                        "Change Password",
                        "assets/patient/key.png",
                        const ForgotPassword(),
                      ),
                      _buildLogoutItem(context),
                    ],
                  ),
            Column(
              children: [
                Image.asset(
                  "assets/patient/logo.png",
                  height: 80,
                  width: 130,
                ),
                Container(
                  child: const Text("App Version 1.16",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 20, 20, 20),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarUI(),
    );
  }

  // Helper method to build user details
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        '$label $value',
        style: GoogleFonts.quicksand(
          fontSize: 16,
          color: const Color.fromARGB(255, 37, 61, 179),
        ),
      ),
    );
  }

  // Helper method for building navigation items
  Widget _buildNavigationItem(
    BuildContext context,
    String text,
    String iconPath,
    Widget? page,
  ) {
    return GestureDetector(
      onTap: () {
        if (page != null) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => page));
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: const Color.fromARGB(255, 141, 148, 154),
                width: 1.0,
              ),
            ),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Image.asset(iconPath),
              const SizedBox(width: 10),
              Text(
                text,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 37, 61, 179),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for deleting account
  Widget _buildDeleteAccountItem(BuildContext context) {
    return GestureDetector(
      onTap: () {
        deleteUser(context);
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: const Color.fromARGB(255, 141, 148, 154),
                width: 1.0,
              ),
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Row(
              children: [
                const Icon(
                  Icons.delete,
                  color: Color.fromARGB(255, 37, 61, 179),
                  size: 23,
                ),
                const SizedBox(width: 14),
                Text(
                  "Delete Account",
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 37, 61, 179),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for logging out
  Widget _buildLogoutItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: const Color.fromARGB(255, 141, 148, 154),
              width: 1.0,
            ),
          ),
          color: Colors.white,
        ),
        child: GestureDetector(
          onTap: () {
            Sharedprefencepatient.StoredPData(
                ptype: "", Email: "", isLogin: false);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const typeLoginui()));
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Row(
              children: [
                const Icon(
                  Icons.logout,
                  color: Color.fromARGB(255, 37, 61, 179),
                  size: 23,
                ),
                const SizedBox(width: 18),
                Text(
                  "Log Out",
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 37, 61, 179),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Delete user method (same as before)
  void deleteUser(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Prompt the user for their password to re-authenticate
        TextEditingController passwordController = TextEditingController();

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Confirm Deletion"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Enter Password",
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      AuthCredential credential = EmailAuthProvider.credential(
                        email: user.email!,
                        password: passwordController.text,
                      );

                      // Reauthenticate user
                      await user.reauthenticateWithCredential(credential);
                      await user.delete(); // Delete the account

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const typeLoginui()),
                      );
                    } catch (e) {
                      print("Error: $e");
                    }
                  },
                  child: const Text(
                    "Delete Account",
                  ),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print("Error deleting account: $e");
      }
    }
  }
}
