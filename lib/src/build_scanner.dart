
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BuildScannerArea extends StatefulWidget {
  /// عنوان الدايلوك
  /// Dialog title
  final String title;

  /// نص توضيحي تحت العنوان
  /// Subtitle text under the title
  final String subtitle;

  /// اللون الأساسي لعناصر التحكم والمؤثرات
  /// Primary color for accents and controls
  final Color primaryColor;

  /// لون الخلفية
  /// Background color
  final Color backgroundColor;

  /// هل تسمح بزر تشغيل/إيقاف الفلاش
  /// Whether to show torch toggle button
  final bool allowFlashToggle;

  /// هل تسمح بتبديل الكاميرا (أمامية/خلفية)
  /// Whether to show camera switch button
  final bool allowCameraToggle;

  /// وقت أقصى تلقائي لإغلاق الدايلوك
  /// Optional timeout to auto-close the dialog
  final Duration? timeout;

  final ValueChanged<String>? onResult;
  const BuildScannerArea({
    super.key,
    required this.title,
    required this.subtitle,
    required this.primaryColor,
    required this.backgroundColor,
    this.onResult,
    this.allowFlashToggle = true,
    this.allowCameraToggle = true,
    this.timeout,
  });

  @override
  State<BuildScannerArea> createState() => _BuildScannerAreaState();
}

class _BuildScannerAreaState extends State<BuildScannerArea>
    with TickerProviderStateMixin {
  MobileScannerController? controller;
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
    controller = MobileScannerController(autoStart: true);
    _setupAnimations();
    _startTimeout();
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

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.elasticOut),
    );

    _animationController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller?.dispose();
    _animationController.dispose();
    _pulseController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Container(
            height: height * 0.33,
            width: width,
            // margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.transparent, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                children: [
                  MobileScanner(
                    controller: controller!,
                    fit: BoxFit.cover,
                    onDetect: (BarcodeCapture capture) {
                      widget.onResult?.call(capture.barcodes.first.rawValue!);
                    },
                  ),
                  _buildScanningAnimation(),
                  _buildCornerDecorations(),
                  Positioned(
                    right: 150,
                    // top: 0,
                    bottom: -40,
                    left: 0,
                    child: _buildFlashButton(),
                  ),
                  Positioned(
                    right: 0,
                    // top: 0,
                    bottom: -40,
                    left: 150,
                    child: _buildCameraToggleButton(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCornerDecorations() {
    return Stack(
      children: [
        // Top-left corner
        Positioned(top: 40, left: 40, child: _buildCorner(topLeft: true)),
        // Top-right corner
        Positioned(top: 40, right: 40, child: _buildCorner(topRight: true)),
        // Bottom-left corner
        Positioned(bottom: 40, left: 40, child: _buildCorner(bottomLeft: true)),
        // Bottom-right corner
        Positioned(
          bottom: 40,
          right: 40,
          child: _buildCorner(bottomRight: true),
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

  // Widget _buildControls() {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         if (widget.allowFlashToggle) _buildFlashButton(),
  //         _buildScanStatusIndicator(),
  //         if (widget.allowCameraToggle) _buildCameraToggleButton(),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildFlashButton() {
    return _buildControlButton(
      icon: isFlashOn
          ? Icon(Icons.flash_on, size: 12)
          : Icon(Icons.flash_off, size: 12),
      label: isFlashOn ? 'إيقاف الفلاش' : 'تشغيل الفلاش',
      onPressed: _toggleFlash,
      isActive: isFlashOn,
    );
  }

  void _toggleFlash() async {
    final c = controller;
    if (c == null) return;
    await c.toggleTorch();
    setState(() {
      isFlashOn = c.value.torchState == TorchState.on;
    });
  }

  void _toggleCamera() async {
    final c = controller;
    if (c == null) return;
    await c.switchCamera();
    setState(() {
      // mobile_scanner's state may not expose cameraFacing directly; track locally
      isFrontCamera = !isFrontCamera;
    });
  }

  Widget _buildCameraToggleButton() {
    return _buildControlButton(
      icon: isFrontCamera ? Icon(Icons.camera_front) : Icon(Icons.camera_rear),
      label: 'تبديل الكاميرا',
      onPressed: _toggleCamera,
      isActive: false,
    );
  }

  Widget _buildControlButton({
    required Icon icon,
    required String label,
    required VoidCallback onPressed,
    required bool isActive,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.transparent, width: 2),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.transparent,
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon.icon, color: Colors.redAccent, size: 40),
            padding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Widget _buildScanStatusIndicator() {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       AnimatedBuilder(
  //         animation: _pulseAnimation,
  //         builder: (context, child) {
  //           return Transform.scale(
  //             scale: _pulseAnimation.value,
  //             child: Container(
  //               padding: const EdgeInsets.all(16),
  //               decoration: BoxDecoration(
  //                 color: isScanning ? widget.primaryColor : Colors.grey,
  //                 borderRadius: BorderRadius.circular(50),
  //                 border: Border.all(
  //                   color: isScanning ? widget.primaryColor : Colors.grey,
  //                   width: 3,
  //                 ),
  //               ),
  //               child: Icon(
  //                 isScanning ? Icons.qr_code_scanner : Icons.pause,
  //                 color: Colors.white,
  //                 size: 32,
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //       const SizedBox(height: 8),
  //       Text(
  //         isScanning ? 'جاري المسح...' : 'متوقف',
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: 12,
  //           fontWeight: FontWeight.w500,
  //         ),
  //       ),
  //     ],
  //   );
  // }

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
                  color: widget.primaryColor,
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
}
