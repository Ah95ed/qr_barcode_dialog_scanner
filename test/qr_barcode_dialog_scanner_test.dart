import 'package:flutter_test/flutter_test.dart';
import 'package:qr_barcode_dialog_scanner/qr_barcode_dialog_scanner.dart';
import 'package:qr_barcode_dialog_scanner/src/scanner_widget.dart';

void main() {
  test('package exports are accessible', () {
    // Just ensure the library can be imported and types exist
    expect(ScannerDialog, isNotNull);
    expect(QRBarcodeScanner, isNotNull);
  });
}
