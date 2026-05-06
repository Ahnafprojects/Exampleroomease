import 'package:flutter/material.dart';
import '../theme.dart';

class QrScanScreen extends StatelessWidget {
  const QrScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 240, height: 240,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.amber, width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner, size: 80, color: AppColors.amber),
                  SizedBox(height: 16),
                  Text(
                    'Arahkan kamera\nke QR Code',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.green,
                          content: const Text('QR Code berhasil discan!'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    },
                    child: Container(
                      height: 52, width: 200,
                      decoration: BoxDecoration(color: AppColors.amber, borderRadius: BorderRadius.circular(12)),
                      child: const Center(
                        child: Text(
                          'Simulasi Scan',
                          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
