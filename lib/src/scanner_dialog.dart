







import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_barcode_dialog_scanner/qr_barcode_dialog_scanner.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final Color primaryColor;
  final Color backgroundColor;
  final bool allowFlashToggle;
  final bool allowCameraToggle;
  final Duration? timeout;

  const ScannerDialog({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.primaryColor,
    required this.backgroundColor,
    this.allowFlashToggle = true,
    this.allowCameraToggle = true,
    this.timeout,
  }) : super(key: key);

  @override
  State<ScannerDialog> createState() => _ScannerDialogState();
}

class _ScannerDialogState extends State<ScannerDialog>
    with TickerProviderStateMixin {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isFlashOn = false;
  bool isFrontCamera = false;
  bool isScanning = true;
  
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _scanAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startTimeout();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scanAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.elasticOut,
    ));

    _animationController.repeat();
    _pulseController.repeat(reverse: true);
  }

  void _startTimeout() {
    if (widget.timeout != null) {
      Future.delayed(widget.timeout!, () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.backgroundColor,
              widget.backgroundColor.withOpacity(0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: widget.primaryColor.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildScannerArea(),
            _buildControls(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              _buildCloseButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScannerArea() {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.primaryColor.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: widget.primaryColor,
                borderRadius: 16,
                borderLength: 30,
                borderWidth: 4,
                cutOutSize: 250,
              ),
            ),
            _buildScanningAnimation(),
            _buildCornerDecorations(),
          ],
        ),
      ),
    );
  }

  Widget _buildScanningAnimation() {
    return AnimatedBuilder(
      animation: _scanAnimation,
      builder: (context, child) {
        return Positioned(
          top: 50 + (200 * _scanAnimation.value),
          left: 50,
          right: 50,
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  widget.primaryColor,
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: widget.primaryColor.withOpacity(0.6),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCornerDecorations() {
    return Stack(
      children: [
        // Top-left corner
        Positioned(
          top: 40,
          left: 40,
          child: _buildCorner(
            topLeft: true,
          ),
        ),
        // Top-right corner
        Positioned(
          top: 40,
          right: 40,
          child: _buildCorner(
            topRight: true,
          ),
        ),
        // Bottom-left corner
        Positioned(
          bottom: 40,
          left: 40,
          child: _buildCorner(
            bottomLeft: true,
          ),
        ),
        // Bottom-right corner
        Positioned(
          bottom: 40,
          right: 40,
          child: _buildCorner(
            bottomRight: true,
          ),
        ),
      ],
    );
  }

  Widget _buildCorner({
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border(
                top: topLeft || topRight
                    ? BorderSide(color: widget.primaryColor, width: 3)
                    : BorderSide.none,
                left: topLeft || bottomLeft
                    ? BorderSide(color: widget.primaryColor, width: 3)
                    : BorderSide.none,
                right: topRight || bottomRight
                    ? BorderSide(color: widget.primaryColor, width: 3)
                    : BorderSide.none,
                bottom: bottomLeft || bottomRight
                    ? BorderSide(color: widget.primaryColor, width: 3)
                    : BorderSide.none,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (widget.allowFlashToggle) _buildFlashButton(),
          _buildScanStatusIndicator(),
          if (widget.allowCameraToggle) _buildCameraToggleButton(),
        ],
      ),
    );
  }

  Widget _buildFlashButton() {
    return _buildControlButton(
      icon: isFlashOn ? Icons.flash_on : Icons.flash_off,
      label: isFlashOn ? 'إيقاف الفلاش' : 'تشغيل الفلاش',
      onPressed: _toggleFlash,
      isActive: isFlashOn,
    );
  }

  Widget _buildCameraToggleButton() {
    return _buildControlButton(
      icon: isFrontCamera ? Icons.camera_front : Icons.camera_rear,
      label: 'تبديل الكاميرا',
      onPressed: _toggleCamera,
      isActive: false,
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isActive,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isActive
                ? widget.primaryColor
                : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? widget.primaryColor
                  : Colors.white.withOpacity(0.2),
              width: 2,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: widget.primaryColor.withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
            padding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildScanStatusIndicator() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isScanning
                      ? widget.primaryColor.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: isScanning
                        ? widget.primaryColor
                        : Colors.grey,
                    width: 3,
                  ),
                ),
                child: Icon(
                  isScanning ? Icons.qr_code_scanner : Icons.pause,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          isScanning ? 'جاري المسح...' : 'متوقف',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.white.withOpacity(0.6),
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'يدعم QR Code, EAN-13, Code 128, و أكثر',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      if (mounted && isScanning) {
        _onCodeScanned(scanData);
      }
    });
  }

  void _onCodeScanned(Barcode scanData) {
    setState(() {
      isScanning = false;
    });

    // Haptic feedback
    HapticFeedback.mediumImpact();

    final result = ScannerResult(
      code: scanData.code ?? '',
      format: scanData.format,
      timestamp: DateTime.now(),
    );

    Navigator.of(context).pop(result);
  }

  void _toggleFlash() async {
    if (controller != null) {
      await controller!.toggleFlash();
      setState(() {
        isFlashOn = !isFlashOn;
      });
    }
  }

  void _toggleCamera() async {
    if (controller != null) {
      await controller!.flipCamera();
      setState(() {
        isFrontCamera = !isFrontCamera;
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}

