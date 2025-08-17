import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_barcode_dialog_scanner/qr_barcode_dialog_scanner.dart';

class QRBarcodeScanner {
  
  /// Show scanner dialog with custom design
  static Future<ScannerResult?> showScannerDialog(
    BuildContext context, {
    String? title,
    String? subtitle,
    Color? primaryColor,
    Color? backgroundColor,
    bool allowFlashToggle = true,
    bool allowCameraToggle = true,
    Duration? timeout,
  }) async {
    return await showDialog<ScannerResult>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ScannerDialog(
        title: title ?? 'QR Code Scanner',

        subtitle: subtitle ?? 'Please scan the QR code or barcode',
        primaryColor: primaryColor ?? const Color(0xFF6C63FF),
        backgroundColor: backgroundColor ?? Colors.black87,
        allowFlashToggle: allowFlashToggle,
        allowCameraToggle: allowCameraToggle,
        timeout: timeout,
      ),
    );
  }

  /// Request camera permission
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status == PermissionStatus.granted;
  }

  /// Check if camera permission is granted
  static Future<bool> isCameraPermissionGranted() async {
    final status = await Permission.camera.status;
    return status == PermissionStatus.granted;
  }
}