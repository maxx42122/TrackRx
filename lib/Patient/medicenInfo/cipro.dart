import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Ciprofloxacin extends StatefulWidget {
  const Ciprofloxacin({super.key});

  @override
  State<Ciprofloxacin> createState() => _CiprofloxacinState();
}

class _CiprofloxacinState extends State<Ciprofloxacin>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Medicine Info",
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade800,
        // elevation: 4,
        // leading: const Icon(
        //   Icons.medical_services,
        //   color: Colors.white,
        // ),
      ),
      body: FadeTransition(
        opacity: _fadeInAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Image section with elevation and shadow
                Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: 220,
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [Colors.green.shade100, Colors.green.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Image.asset(
                      "assets/patient/cipro.jpg", // Make sure the path is correct
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Medicine name
                Center(
                  child: Text(
                    "Ciprofloxacin 500mg Tablet",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade800,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Salt Composition section
                buildSection("SALT COMPOSITION", "Ciprofloxacin (500mg)",
                    Icons.science_outlined),
                const SizedBox(height: 20),

                // Salt Synonyms section
                buildSection("SALT SYNONYMS", "Cipro, Ciproxin",
                    Icons.label_important_outlined),
                const SizedBox(height: 20),

                // Uses section
                buildSection(
                  "USES",
                  "Ciprofloxacin is used to treat various types of bacterial infections. It is effective against infections of the respiratory tract, urinary tract, gastrointestinal tract, and skin.",
                  Icons.healing_outlined,
                ),
                const SizedBox(height: 20),

                // Storage section
                buildSection("STORAGE", "Store at room temperature",
                    Icons.storage_outlined),
                const SizedBox(height: 20),

                // Product Introduction section
                buildSection(
                  "PRODUCT INTRODUCTION",
                  "Ciprofloxacin 500mg Tablet is used to treat bacterial infections. It works by stopping the growth of bacteria, and is commonly prescribed for urinary tract infections, respiratory infections, and skin infections.",
                  Icons.info_outline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build sections with icons and enhanced UI
  Widget buildSection(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.green.shade800, size: 26),
            const SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.green.shade800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
