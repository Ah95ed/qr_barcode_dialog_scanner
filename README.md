# qr_barcode_dialog_scanner


A modern and elegant Flutter package for QR Code and Barcode scanning with stunning dialog interface and premium user experience.
version 1.0.0


## ✨ Features

- 🎨 **Modern UI Design** - Beautiful dialog with glass morphism effects and smooth animations
- 📱 **Complete Barcode Support** - QR Code, EAN-13, Code 128, and 15+ barcode formats
- 💡 **Flash Control** - Elegant toggle for flashlight with visual feedback
- 📷 **Camera Switch** - Seamless front/rear camera switching
- 🎭 **Custom Dialog** - Fully customizable dialog with premium animations
- 🔒 **Auto Permissions** - Automatic camera permission handling
- ⏱️ **Timeout Support** - Configurable scanning timeout
- 🎵 **Haptic Feedback** - Native vibration on successful scan
- 🌙 **Dark Mode Ready** - Beautiful dark theme with custom colors
- 🚀 **High Performance** - Optimized for smooth 60fps scanning
- 📊 **Multiple Formats** - Support for all major barcode standards
- 🔄 **Real-time Scanning** - Live scanning with animated scan line

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  qr_barcode_dialog_scanner: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

### Basic Usage

```dart
import 'package:qr_barcode_dialog_scanner/qr_barcode_dialog_scanner.dart';

// Simple scan
final result = await QRBarcodeScanner.showScannerDialog(context);
if (result != null) {
  print('Scanned: ${result.code}');
  print('Format: ${result.format}');
  print('Time: ${result.timestamp}');
}
```

### Advanced Usage with Customization

```dart
final result = await QRBarcodeScanner.showScannerDialog(
  context,
  title: 'Scan Product',
  subtitle: 'Place the barcode inside the frame',
  primaryColor: Colors.deepPurple,
  backgroundColor: Colors.black87,
  allowFlashToggle: true,
  allowCameraToggle: true,
  timeout: Duration(minutes: 2),
);

if (result != null) {
  // Handle different barcode types
  switch (result.format) {
    case BarcodeFormat.qrcode:
      _handleQRCode(result.code);
      break;
    case BarcodeFormat.ean13:
      _handleProductBarcode(result.code);
      break;
    case BarcodeFormat.code128:
      _handleShippingCode(result.code);
      break;
    default:
      _handleGenericCode(result.code);
  }
}
```

## 🔐 Platform Setup

### Android Configuration

Add these permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature 
    android:name="android.hardware.camera" 
    android:required="true" />
<uses-feature 
    android:name="android.hardware.camera.autofocus" 
    android:required="false" />
```

### iOS Configuration

Add camera usage description to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to scan QR codes and barcodes</string>
```

For iOS 10.0+, also add:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to scan codes from images</string>
```

## 🎨 Customization Guide

### Colors and Theme

```dart
await QRBarcodeScanner.showScannerDialog(
  context,
  // Primary color for UI elements
  primaryColor: Color(0xFF6C63FF),
  
  // Dialog background color
  backgroundColor: Colors.black87,
  
  // Custom gradient background
  backgroundGradient: LinearGradient(
    colors: [Colors.purple.shade900, Colors.blue.shade900],
  ),
);
```

### Custom Titles and Messages

```dart
await CrystalQRBarcodeDialog.showScannerDialog(
  context,
  title: 'Custom Scanner',
  subtitle: 'Scan your code here',
  
  // Success message
  successMessage: 'Code scanned successfully!',
  
  // Error message for invalid codes
  errorMessage: 'Invalid code format',
);
```

### Feature Control

```dart
await CrystalQRBarcodeDialog.showScannerDialog(
  context,
  // Enable/disable flash toggle
  allowFlashToggle: true,
  
  // Enable/disable camera switching
  allowCameraToggle: false,
  
  // Auto-close dialog after timeout
  timeout: Duration(seconds: 30),
  
  // Require specific barcode format
  allowedFormats: [BarcodeFormat.qrcode, BarcodeFormat.ean13],
);
```

## 📱 Practical Examples

### 1. QR Code URL Scanner

```dart
void scanQRForURL() async {
  final result = await QRBarcodeScanner.showScannerDialog(
    context,
    title: 'Scan QR Code',
    subtitle: 'Point camera at QR code to open link',
    primaryColor: Colors.blue,
    allowedFormats: [BarcodeFormat.qrcode],
  );
  
  if (result != null && _isValidURL(result.code)) {
    await launch(result.code);
  } else {
    _showErrorDialog('Invalid URL in QR code');
  }
}

bool _isValidURL(String url) {
  return Uri.tryParse(url)?.hasAbsolutePath ?? false;
}
```

### 2. Product Barcode Scanner

```dart
void scanProductBarcode() async {
  final result = await QRBarcodeScanner.showScannerDialog(
    context,
    title: 'Scan Product',
    subtitle: 'Scan barcode to view product details',
    primaryColor: Colors.green,
    allowCameraToggle: false,
    allowedFormats: [
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.upca,
    ],
  );
  
  if (result != null) {
    final product = await _fetchProductDetails(result.code);
    if (product != null) {
      _showProductDialog(product);
    } else {
      _showErrorDialog('Product not found');
    }
  }
}
```

### 3. WiFi QR Code Scanner

```dart
void scanWiFiQR() async {
      final result = await QRBarcodeScanner.showScannerDialog(
    context,
    title: 'Connect to WiFi',
    subtitle: 'Scan WiFi QR code to connect',
    primaryColor: Colors.teal,
    timeout: Duration(minutes: 1),
  );
  
  if (result != null && result.code.startsWith('WIFI:')) {
    final wifiConfig = _parseWiFiQR(result.code);
    await _connectToWiFi(wifiConfig);
  }
}

Map<String, String> _parseWiFiQR(String qrData) {
  // Parse WIFI:T:WPA;S:MyNetwork;P:MyPassword;H:false;;
  final params = <String, String>{};
  final parts = qrData.substring(5).split(';');
  
  for (final part in parts) {
    if (part.contains(':')) {
      final keyValue = part.split(':');
      params[keyValue[0]] = keyValue[1];
    }
  }
  return params;
}
```

### 4. Document Scanner with Validation

```dart
void scanDocumentQR() async {
  final result = await QRBarcodeScanner.showScannerDialog(
    context,
    title: 'Scan Document',
    subtitle: 'Scan document QR for verification',
    primaryColor: Colors.orange,
    timeout: Duration(seconds: 45),
  );
  
  if (result != null) {
    final isValid = await _validateDocument(result.code);
    
    if (isValid) {
      _showSuccessDialog('Document verified successfully');
    } else {
      _showErrorDialog('Invalid or expired document');
    }
  }
}
```

## 🔧 Complete API Reference

### QRBarcodeScanner

#### showScannerDialog()

```dart
static Future<ScannerResult?> showScannerDialog(
  BuildContext context, {
  
  // UI Customization
  String? title,                           // Dialog title
  String? subtitle,                        // Dialog subtitle
  Color? primaryColor,                     // Primary theme color
  Color? backgroundColor,                  // Background color
  Gradient? backgroundGradient,            // Custom gradient
  
  // Feature Control
  bool allowFlashToggle = true,            // Enable flash control
  bool allowCameraToggle = true,           // Enable camera switching
  List<BarcodeFormat>? allowedFormats,     // Restrict barcode types
  
  // Timing
  Duration? timeout,                       // Auto-close timeout
  
  // Messages
  String? successMessage,                  // Success feedback
  String? errorMessage,                    // Error feedback
  
  // Callbacks
  void Function(String)? onCodeScanned,    // Real-time scan callback
  void Function()? onTimeout,              // Timeout callback
  
  // Animation Control
  bool enableAnimations = true,            // Enable/disable animations
  Duration animationDuration = const Duration(milliseconds: 300),
})
```

#### Permission Methods

```dart
// Request camera permission
static Future<bool> requestCameraPermission()

// Check if permission is granted
static Future<bool> isCameraPermissionGranted()
```

### ScannerResult Class

```dart
class ScannerResult {
  final String code;              // Scanned code content
  final BarcodeFormat format;     // Barcode format type
  final DateTime timestamp;       // Scan timestamp
  final List<Offset>? corners;    // Code corner positions (if available)
  
  // Utility Methods
  Map<String, dynamic> toJson();              // Convert to JSON
  factory ScannerResult.fromJson(Map json);   // Create from JSON
  ScannerResult copyWith({...});              // Create copy with changes
  
  // Format Checking
  bool get isQRCode => format == BarcodeFormat.qrcode;
  bool get isEAN13 => format == BarcodeFormat.ean13;
  bool get isProductCode => [BarcodeFormat.ean13, BarcodeFormat.ean8, BarcodeFormat.upca].contains(format);
}
```

### BarcodeFormat Enum

```dart
enum BarcodeFormat {
  unknown,        // Unknown format
  qrcode,         // QR Code
  ean13,          // EAN-13 (product barcodes)
  ean8,           // EAN-8
  upca,           // UPC-A
  upce,           // UPC-E
  code39,         // Code 39
  code93,         // Code 93
  code128,        // Code 128
  itf,            // ITF (Interleaved 2 of 5)
  codabar,        // Codabar
  pdf417,         // PDF417
  dataMatrix,     // Data Matrix
  aztec,          // Aztec Code
}
```

## 🛠️ Advanced Features

### Custom Scanning Overlay

```dart
class CustomScannerOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Custom scanning frame
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        
        // Custom instructions
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Text(
            'Align code within the frame',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
```

### Batch Scanning

```dart
class BatchScanner {
  final List<ScannerResult> _scannedCodes = [];
  
  void startBatchScanning() async {
    while (_scannedCodes.length < 10) {
      final result = await QRBarcodeScanner.showScannerDialog(
        context,
        title: 'Batch Scan (${_scannedCodes.length + 1}/10)',
        onCodeScanned: (code) {
          // Validate before adding
          if (!_scannedCodes.any((r) => r.code == code)) {
            _scannedCodes.add(ScannerResult(
              code: code,
              format: BarcodeFormat.unknown,
              timestamp: DateTime.now(),
            ));
          }
        },
      );
      
      if (result == null) break; // User cancelled
    }
    
    _processBatchResults(_scannedCodes);
  }
}
```

## 🎯 Supported Barcode Types

| Format | Description | Common Use Cases |
|--------|-------------|------------------|
| QR Code | 2D matrix barcode | URLs, WiFi configs, contact info |
| EAN-13 | European Article Number | Product identification |
| EAN-8 | Shorter EAN format | Small products |
| UPC-A | Universal Product Code | North American products |
| UPC-E | Compressed UPC | Small package products |
| Code 39 | Alphanumeric linear | Industrial applications |
| Code 93 | Extended ASCII | Logistics, inventory |
| Code 128 | High-density linear | Shipping, packaging |
| ITF | Interleaved 2 of 5 | Cartons, packaging |
| Codabar | Numeric + special chars | Libraries, blood banks |
| PDF417 | 2D stacked linear | ID cards, transport |
| Data Matrix | 2D matrix | Small item marking |
| Aztec | 2D matrix | Transport tickets |



#### Camera Permission Denied
```dart
// Check and request permission before scanning
if (!await QRBarcodeScanner.isCameraPermissionGranted()) {
  final granted = await QRBarcodeScanner.requestCameraPermission();
  if (!granted) {
    // Show dialog to open app settings
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Camera Permission Required'),
        content: Text('Please enable camera permission in app settings'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
    return;
  }
}
```

#### Performance Issues
```dart
// Use timeout to prevent battery drain
await QRBarcodeScanner.showScannerDialog(
  context,
  timeout: Duration(minutes: 1),
  onTimeout: () {
    print('Scanning timed out');
  },
);

// Limit allowed formats for faster scanning
await QRBarcodeScanner.showScannerDialog(
  context,
  allowedFormats: [BarcodeFormat.qrcode], // Only scan QR codes
);
```

#### Multiple Dialog Issue
```dart
// Prevent multiple dialogs
bool _isScanning = false;

void startScanning() async {
  if (_isScanning) return;
  
  _isScanning = true;
  try {
    final result = await QRBarcodeScanner.showScannerDialog(context);
    // Handle result
  } finally {
    _isScanning = false;
  }
}
```

#### Invalid Barcode Handling
```dart
void scanWithValidation() async {
  final result = await QRBarcodeScanner.showScannerDialog(
    context,
    onCodeScanned: (code) {
      // Real-time validation
      if (!_isValidCode(code)) {
        // Show error feedback
        HapticFeedback.heavyImpact();
        return;
      }
    },
  );
  
  if (result != null && _isValidCode(result.code)) {
    _processValidCode(result);
  } else {
    _showInvalidCodeError();
  }
}
```

## 📋 System Requirements

- **Flutter SDK**: ≥ 3.0.0
- **Dart SDK**: ≥ 2.19.0
- **Android**: API level 21+ (Android 5.0+)
- **iOS**: 11.0+
- **Camera**: Required for scanning functionality




## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [qr_code_scanner](https://pub.dev/packages/qr_code_scanner) - Core scanning functionality
- [permission_handler](https://pub.dev/packages/permission_handler) - Permission management
- Flutter team for the amazing framework

## 📞 Support

- 📧 **Email Support**: amhmeed31@gmail.com
- 🐙 **GitHub Issues**: Open an issue if you encounter a bug or have a feature request

---
## 📄 License
MIT © 2025 Ahmed Shaker

Made with ❤️ for the Flutter community