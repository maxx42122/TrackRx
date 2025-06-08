import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trackrx/AuthenticationPatient/3typelogin.dart';
import 'package:trackrx/Patient/myprofile.dart';
import '../AuthenticationPatient/SharedPrefencepatient.dart';

class Profilemanufacturer extends StatefulWidget {
  const Profilemanufacturer({super.key});

  @override
  State createState() => _ProfilemanufacturerState();
}

class _ProfilemanufacturerState extends State<Profilemanufacturer> {
  late Future<Map<String, dynamic>> profileData;

  @override
  void initState() {
    super.initState();
    profileData = _getProfileData();
  }

  Future<Map<String, dynamic>> _getProfileData() async {
    try {
      // Get current user email from FirebaseAuth
      String? email = FirebaseAuth.instance.currentUser?.email;

      if (email == null) {
        throw 'No user is logged in';
      }

      // Query the Firestore collection with the current user's email as document ID
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('manufacturer')
          .doc(email) // Use the email as the document ID
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        throw 'Profile document not found';
      }
    } catch (e) {
      throw 'Failed to load profile data: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: GoogleFonts.quicksand(fontSize: 22)),
        backgroundColor: Colors.teal,
        elevation: 5,
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: profileData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No profile data available'));
          } else {
            var data = snapshot.data!;
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 45.0),
                  child: Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.teal.shade200,
                      child: Icon(
                        Icons.account_circle,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "Name :${data['manufacturerName'] ?? 'Unknown Manufacturer'}",
                    style: GoogleFonts.quicksand(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: Colors.teal,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _buildDetailItem(
                  icon: Icons.email, // Email Icon
                  title: "Email ID: ${data['emailId'] ?? 'Not Available'}",
                ),
                _buildDetailItem(
                  icon: Icons.star, // Star Icon for Grade
                  title: "Grade: ${data['grade'] ?? 'Not Available'}",
                ),
                _buildDetailItem(
                  icon: Icons.perm_identity,
                  // ID Card Icon for ID
                  title: "Manufacturer ID: ${data['id'] ?? 'Not Available'}",
                ),
                _buildMenuItem(
                  icon: Icons.delete,
                  title: "Delete Account",
                  onTap: () {},
                  iconColor: Colors.red,
                ),
                _buildMenuItem(
                  icon: Icons.logout,
                  title: "Log Out",
                  onTap: () {
                    Sharedprefencepatient.StoredPData(
                        ptype: "", Email: "", isLogin: false);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const typeLoginui()));
                  },
                  iconColor: Colors.orange,
                ),
                SizedBox(height: 30),
                Center(
                  child: Image.asset(
                    "assets/patient/logo.png",
                    height: 80,
                    width: 130,
                  ),
                ),
                Center(
                  child: Text("App Version 1.16",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black45,
                      )),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  // A widget for displaying profile details
  Widget _buildDetailItem({
    required String title,
    required dynamic icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
      child: Card(
        elevation: 5, // Increased elevation for more shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), // Rounded corners
        ),
        color: Colors.teal.shade50, // Light teal background color
        child: ListTile(
          leading: Icon(icon, size: 30, color: Colors.teal),
          title: Text(
            title,
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  // A widget for menu items with tap functionality
  Widget _buildMenuItem({
    required String title,
    required dynamic icon,
    required VoidCallback onTap,
    Color iconColor = const Color.fromRGBO(117, 164, 136, 1.0),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
        child: Card(
          elevation: 5, // Increased elevation for more shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          color: Colors.teal.shade50, // Light teal background color
          child: ListTile(
            leading: Icon(icon, size: 30, color: iconColor),
            title: Text(
              title,
              style: GoogleFonts.quicksand(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ),
      ),
    );
  }
}
