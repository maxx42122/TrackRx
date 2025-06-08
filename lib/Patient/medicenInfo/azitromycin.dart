import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Azithromycin extends StatefulWidget {
  const Azithromycin({super.key});

  @override
  State<Azithromycin> createState() => _AzithromycinState();
}

class _AzithromycinState extends State<Azithromycin>
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
        elevation: 4,
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
                      "assets/patient/azi.jpg", // Make sure the path is correct
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Medicine name
                Center(
                  child: Text(
                    "Azithromycin 500mg Tablet",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade800,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Salt Composition section
                buildSection("SALT COMPOSITION", "Azithromycin (500mg)",
                    Icons.science_outlined),
                const SizedBox(height: 20),

                // Salt Synonyms section
                buildSection("SALT SYNONYMS", "Zithromax",
                    Icons.label_important_outlined),
                const SizedBox(height: 20),

                // Uses section
                buildSection(
                  "USES",
                  "Azithromycin is used to treat a wide variety of bacterial infections. It is effective against infections of the respiratory tract, ear, throat, lungs, skin, and eye. It is also used to treat sexually transmitted infections.",
                  Icons.healing_outlined,
                ),
                const SizedBox(height: 20),

                // Storage section
                buildSection(
                    "STORAGE", "Store below 30°C", Icons.storage_outlined),
                const SizedBox(height: 20),

                // Product Introduction section
                buildSection(
                  "PRODUCT INTRODUCTION",
                  "Azithromycin 500mg Tablet is an antibiotic used to treat various bacterial infections. It is effective against infections of the respiratory tract, ear, throat, lungs, skin, and eye. It works by inhibiting the growth of bacteria and helps relieve symptoms.",
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
