// import 'package:flutter/material.dart';
// import 'package:pretty_qr_code/pretty_qr_code.dart';

// class GenerateQR extends StatefulWidget {
//   const GenerateQR({super.key});
//   @override
//   State<GenerateQR> createState() => _GenerateQRState();
// }

// class _GenerateQRState extends State<GenerateQR> {
//   String? qrData;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Generate QR code"),
//           actions: [
//             IconButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, "/scan");
//                 },
//                 icon: Icon(Icons.qr_code_scanner)),
//           ],
//         ),
//         body: Padding(
//           padding: EdgeInsets.all(10),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               TextField(onSubmitted: (value) {
//                 setState(() {
//                   qrData = value;
//                 });
//               }),
//               if (qrData != null) PrettyQrView.data(data: qrData!),
//             ],
//           ),
//         ));
//   }
// }
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class GenerateQR extends StatefulWidget {
  const GenerateQR({super.key});
  @override
  State<GenerateQR> createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {
  String? qrData;
  final TextEditingController firstController = TextEditingController();
  final TextEditingController secondController = TextEditingController();
  final TextEditingController thirdController = TextEditingController();

  void generateQR() {
    setState(() {
      // Combine text from multiple fields
      qrData =
          "${firstController.text}, ${secondController.text}, ${thirdController.text}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate QR code"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/scan");
            },
            icon: const Icon(Icons.qr_code_scanner),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // First TextField
              TextField(
                controller: firstController,
                decoration: const InputDecoration(
                  labelText: "First Field",
                  border: OutlineInputBorder(),
                ),
              ),
              // Second TextField
              TextField(
                controller: secondController,
                decoration: const InputDecoration(
                  labelText: "Second Field",
                  border: OutlineInputBorder(),
                ),
              ),
              // Third TextField
              TextField(
                controller: thirdController,
                decoration: const InputDecoration(
                  labelText: "Third Field",
                  border: OutlineInputBorder(),
                ),
              ),
              // Generate QR Button
              ElevatedButton(
                onPressed: generateQR,
                child: const Text("Generate QR Code"),
              ),

              const SizedBox(
                height: 500,
              ),
              // QR Code Display
              if (qrData != null)
                PrettyQrView.data(
                  data: qrData!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
