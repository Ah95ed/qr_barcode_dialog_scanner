import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'scanner_dialog.dart';
import 'scanner_result.dart';

class QRBarcodeScanner {
  /// يفتح دايلوك مسح QR/Barcode جاهز من المكتبة ويعيد النتيجة عند النجاح.
  ///
  /// Opens the built-in QR/Barcode scanning dialog and returns the result
  /// when a code is detected.
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

  /// يطلب سماحية الكاميرا من المستخدم ويعيد true إذا تمت الموافقة.
  /// Requests camera permission from the user and returns true if granted.
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status == PermissionStatus.granted;
  }

  /// يتحقق إذا سماحية الكاميرا ممنوحة مسبقاً.
  /// Checks whether the camera permission is already granted.
  static Future<bool> isCameraPermissionGranted() async {
    final status = await Permission.camera.status;
    return status == PermissionStatus.granted;
  }
}
