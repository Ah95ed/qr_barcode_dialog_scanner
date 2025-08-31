// مثال مبسّط يوضح استخدام مكتبة qr_barcode_dialog_scanner
// Simple example showing how to use qr_barcode_dialog_scanner
//
// 1) نطلب صلاحية الكاميرا
// 1) Request camera permission
// 2) نفتح دايلوك المسح باستخدام دالة الحزمة الجاهزة
// 2) Show scanning dialog using the package API
// 3) نعرض النتيجة للمستخدم
// 3) Display the scan result to the user

import 'package:example/src/scanner_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Scanner Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Scanner Example")),
      body: Center(
        child: ElevatedButton(
          child: const Text("Open Scanner"),
          onPressed: () async {
            // نطلب سماحية الكاميرا قبل البدء
            // Ask for camera permission first
            final granted = await QRBarcodeScanner.requestCameraPermission();
            if (!granted) {
              // إذا الاذن مرفوض نعرض رسالة
              // If permission is denied, show a message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Camera permission denied')),
              );
              return;
            }

            // نعرض الدايلوك الجاهز من المكتبة وننتظر النتيجة
            // Show the built-in scanning dialog and wait for the result
            final result = await QRBarcodeScanner.showScannerDialog(
              context,
              title: "ماسح الباركود", // عنوان الدايلوك
              subtitle: 'Scan a code',     // نص توضيحي (اختياري)
              primaryColor: const Color.fromARGB(255, 231, 143, 143),
              backgroundColor: Colors.black87,
              allowFlashToggle: true,
              allowCameraToggle: true,
              // timeout: const Duration(seconds: 30), // (اختياري)
            );

            // إذا أكو نتيجة، نعرضها للمستخدم
            // If we have a result, show it to the user
            if (result != null) {
              final msg = 'Code: ${result.code}\nFormat: ${result.format}';
              // نعرض SnackBar بالنتيجة
              // Show a SnackBar with the result
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(msg)));
            }
          },
        ),
      ),
    );
  }
}
