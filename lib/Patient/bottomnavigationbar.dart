import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackrx/Patient/notificationpage.dart';

import 'PatientProfile.dart'; // Replace with your actual Profile page file
import 'cartpage.dart'; // Replace with your actual Cart page file
import 'patient.dart'; // Replace with your actual Patient_UI file

class BottomNavigationBarUI extends StatefulWidget {
  const BottomNavigationBarUI({super.key});

  @override
  State<BottomNavigationBarUI> createState() => _BottomNavigationBarUIState();
}

class _BottomNavigationBarUIState extends State<BottomNavigationBarUI> {
  int _currentIndex = 0;

  // Define pages for navigation
  final List<Widget> _pages = [
    const Patient_UI(), // Your custom Patient UI widget
    const SearchMedicine(), // Notifications page
    const cart(), // Cart page
    const Profile(), // Profile page
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(255, 20, 95, 166),
      unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      selectedItemColor: const Color.fromARGB(255, 37, 61, 179),
      currentIndex: _currentIndex,
      onTap: (index) {
        _navigateToPage(index, context);

        setState(() {
          _currentIndex = index; // Update index on tap
        });
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: 'Account',
        ),
      ],
    );
  }

  void _navigateToPage(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const Patient_UI(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const SearchMedicine(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const cart(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const Profile(),
        ));
        break;
      default:
        break;
    }
  }
}
