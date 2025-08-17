
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerResult {

  final String code;
  final BarcodeFormat format;
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

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'format': format.toString(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

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
