import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Amoxicillin extends StatefulWidget {
  const Amoxicillin({super.key});

  @override
  State<Amoxicillin> createState() => _AmoxicillinState();
}

class _AmoxicillinState extends State<Amoxicillin>
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
        backgroundColor: Colors.purple.shade800,
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
                        colors: [
                          Colors.purple.shade100,
                          Colors.purple.shade400,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Image.asset(
                      "assets/patient/acimol.webp", // Ensure this image is in the assets folder
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Medicine name
                Center(
                  child: Text(
                    "Acimol 100 mg/325 mg Tablet",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple.shade800,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Salt Composition section
                buildSection(
                  "SALT COMPOSITION",
                  "Aceclofenac (100mg) + Paracetamol (325mg)",
                  Icons.science_outlined,
                ),
                const SizedBox(height: 20),

                // Salt Synonyms section
                buildSection(
                  "SALT SYNONYMS",
                  "Amoxil, Trimox",
                  Icons.label_important_outlined,
                ),
                const SizedBox(height: 20),

                // Uses section
                buildSection(
                  "USES",
                  "Amoxicillin is used to treat a wide variety of bacterial infections. This medication is a penicillin-type antibiotic. It works by stopping the growth of bacteria.",
                  Icons.healing_outlined,
                ),
                const SizedBox(height: 20),

                // Storage section
                buildSection(
                  "STORAGE",
                  "Store at room temperature, protect from moisture",
                  Icons.storage_outlined,
                ),
                const SizedBox(height: 20),

                // Product Introduction section
                buildSection(
                  "PRODUCT INTRODUCTION",
                  "Acimol 100 mg/325 mg Tablet is a pain-relieving medicine. It is used to reduce pain and inflammation in conditions like rheumatoid arthritis, ankylosing spondylitis, and osteoarthritis. It may also be used to relieve muscle pain, back pain, toothache, or pain in the ear and throat.",
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
            Icon(icon, color: Colors.purple.shade800, size: 26),
            const SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.purple.shade800,
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
