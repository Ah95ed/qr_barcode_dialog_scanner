/// مكتبة فلاتر لمسح QR والباركود عبر دايلوك أنيق وسهل الاستخدام.
///
/// Arabic (Iraqi): تعرض دايلوك مدمج بكاميرا، ويتيح تفعيل الفلاش، تبديل الكاميرا،
/// ويعيد [ScannerResult] يحتوي النص المقروء ونوع الباركود ووقت المسح.
///
/// English: A Flutter package providing a polished dialog-based QR/Barcode
/// scanner. It uses mobile_scanner under the hood and returns a [ScannerResult]
/// with the raw value, barcode format, and timestamp.
// lib/qr_barcode_scanner.dart
library;

export 'src/scanner_dialog.dart';
export 'src/scanner_widget.dart';
export 'src/scanner_result.dart';

/// Main exports for the QR & Barcode Scanner dialog package.
