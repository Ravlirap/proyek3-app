import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/scan_provider.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanLineController;
  late Animation<double> _scanLineAnim;

  @override
  void initState() {
    super.initState();
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _scanLineAnim = CurvedAnimation(
      parent: _scanLineController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    super.dispose();
  }

  Future<void> _startScan() async {
    final scanProvider = context.read<ScanProvider>();
    await scanProvider.startScan();
    if (mounted && scanProvider.hasResult) {
      final result = await Navigator.pushNamed(
        context,
        AppConstants.analysisResultRoute,
      );
      if (result == true) {
        scanProvider.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scan = context.watch<ScanProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            context.read<ScanProvider>().reset();
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Scan Makanan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on_rounded, color: Colors.white54),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera placeholder
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    const Color(0xFF0A1810),
                    Colors.black,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Viewfinder
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 32),
                Stack(
                  children: [
                    // Camera frame
                    Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: scan.isScanning
                              ? AppTheme.primaryGreen
                              : Colors.white24,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Container(
                          color: Colors.black38,
                          child: scan.isScanning
                              ? null
                              : const Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.restaurant_rounded,
                                          color: Colors.white24, size: 60),
                                      SizedBox(height: 12),
                                      Text(
                                        'Arahkan kamera\nke makanan Anda',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white38,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ),

                    // Corner markers
                    ..._buildCorners(),

                    // Scan line animation
                    if (scan.isScanning)
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: AnimatedBuilder(
                            animation: _scanLineAnim,
                            builder: (_, __) => Stack(
                              children: [
                                Positioned(
                                  top: _scanLineAnim.value * 290,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 2.5,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          AppTheme.primaryGreen
                                              .withOpacity(0.8),
                                          AppTheme.primaryGreen,
                                          AppTheme.primaryGreen
                                              .withOpacity(0.8),
                                          Colors.transparent,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.primaryGreen
                                              .withOpacity(0.4),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 24),
                if (scan.isScanning)
                  FadeIn(
                    child: Column(
                      children: [
                        Pulse(
                          infinite: true,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  color: AppTheme.primaryGreen.withOpacity(0.4)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppTheme.primaryGreen,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'AI sedang menganalisis...',
                                  style: TextStyle(
                                    color: AppTheme.primaryGreen,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const Text(
                    'Pastikan makanan berada\ndi dalam bingkai',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
              ],
            ),
          ),

          // Tip chips
          if (!scan.isScanning)
            Positioned(
              bottom: 160,
              left: 20,
              right: 20,
              child: FadeInUp(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  children: const [
                    _TipChip(label: '📸 Ambil foto dari atas'),
                    _TipChip(label: '💡 Pastikan pencahayaan cukup'),
                    _TipChip(label: '🍽️ Satu piring per foto'),
                  ],
                ),
              ),
            ),

          // Bottom button
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Center(
              child: scan.isScanning
                  ? const SizedBox.shrink()
                  : GestureDetector(
                      onTap: _startScan,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryGreen.withOpacity(0.5),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCorners() {
    const size = 24.0;
    const thickness = 3.0;
    final color = AppTheme.primaryGreen;

    Widget corner({required bool top, required bool left}) {
      return Positioned(
        top: top ? 0 : null,
        bottom: top ? null : 0,
        left: left ? 0 : null,
        right: left ? null : 0,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border(
              top: top
                  ? BorderSide(color: color, width: thickness)
                  : BorderSide.none,
              bottom: top
                  ? BorderSide.none
                  : BorderSide(color: color, width: thickness),
              left: left
                  ? BorderSide(color: color, width: thickness)
                  : BorderSide.none,
              right: left
                  ? BorderSide.none
                  : BorderSide(color: color, width: thickness),
            ),
          ),
        ),
      );
    }

    return [
      corner(top: true, left: true),
      corner(top: true, left: false),
      corner(top: false, left: true),
      corner(top: false, left: false),
    ];
  }
}

class _TipChip extends StatelessWidget {
  final String label;
  const _TipChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }
}
