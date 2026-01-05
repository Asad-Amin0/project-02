import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Scanner")),
      body: MobileScanner(
        onDetect: (BarcodeCapture capture) {
          final List<Barcode> barcodes = capture.barcodes;

          if (barcodes.isNotEmpty) {
            final String? data = barcodes.first.rawValue;

            if (data != null) {
              Fluttertoast.showToast(
                msg: "Scanned Data: $data",
                toastLength: Toast.LENGTH_LONG,
              );
              Navigator.pop(context);
            }
          }
        },
      ),
    );
  }
}
