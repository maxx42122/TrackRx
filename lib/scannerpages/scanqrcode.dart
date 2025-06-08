import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:trackrx/hospital/historymanufacture.dart';

class ScanCodePage extends StatefulWidget {
  const ScanCodePage({super.key});
  @override
  State<ScanCodePage> createState() => _ScanCodePageState();
}

class _ScanCodePageState extends State<ScanCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Scan QR code"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/generate");
                },
                icon: const Icon(Icons.qr_code)),
          ],
        ),
        body: MobileScanner(
          controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.noDuplicates),
          onDetect: (capture) {
            print("capture");
            final List<Barcode> barcodes = capture.barcodes;
            final Uint8List? image = capture.image;
            for (final barcode in barcodes) {
              log("hii barcode");
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(color: Colors.deepOrange),
                child: Text(
                  'Barcode found!! ${barcode.rawValue}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              );
              log('Barcode found!! ${barcode.rawValue}');
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(barcodes.first.rawValue ?? ""),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return StockList1();
                            }));
                          },
                          child: const Text("Ok"),
                        ),
                      ],
                    );
                  });
            }

            if (image != null) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(barcodes.first.rawValue ?? ""),
                      content: Image(image: MemoryImage(image)),
                    );
                  });
            }
          },
        ));
  }
}
