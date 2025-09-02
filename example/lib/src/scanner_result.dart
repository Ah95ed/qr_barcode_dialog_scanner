import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerResult {
  /// النص الخام للكود المقروء (QR/Barcode)
  /// The raw text value for the scanned code
  final String code;

  /// نوع الباركود/QR المقروء
  /// The detected barcode format
  final BarcodeFormat format;

  /// وقت إجراء عملية المسح
  /// The timestamp when the scan happened
  final DateTime timestamp;

  const ScannerResult({
    required this.code,
    required this.format,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'ScannerResult(code: $code, format: $format, timestamp: $timestamp)';
  }

  /// يحول النتيجة إلى JSON
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'format': format.toString(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// ينشئ النتيجة من JSON
  /// Create from JSON
  factory ScannerResult.fromJson(Map<String, dynamic> json) {
    return ScannerResult(
      code: json['code'],
      format: BarcodeFormat.values.firstWhere(
        (e) => e.toString() == json['format'],
        orElse: () => BarcodeFormat.unknown,
      ),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
