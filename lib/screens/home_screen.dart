import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_theme.dart';
import '../theme/glass_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool _isFullScreenScanner = false;
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  late AnimationController _animationController;
  late Animation<double> _scannerAnimation;

  final List<Map<String, dynamic>> _actions = [
    {
      'title': 'Task Manager',
      'icon': Icons.assignment_outlined,
      'gradient': [const Color(0xFF4158D0), const Color(0xFFC850C0)],
    },
    {
      'title': 'Categories',
      'icon': Icons.category_outlined,
      'gradient': [const Color(0xFFFF8008), const Color(0xFFFFC837)],
    },
    {
      'title': 'People',
      'icon': Icons.people_outline,
      'gradient': [const Color(0xFF3633A8), const Color(0xFF6C4BB4)],
    },
    {
      'title': 'Statistics',
      'icon': Icons.bar_chart,
      'gradient': [const Color(0xFF00B4DB), const Color(0xFF0083B0)],
    },
    {
      'title': 'Settings',
      'icon': Icons.settings_outlined,
      'gradient': [const Color(0xFF434343), const Color(0xFF000000)],
    },
    {
      'title': 'Reports',
      'icon': Icons.summarize_outlined,
      'gradient': [const Color(0xFFED213A), const Color(0xFF93291E)],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scannerAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.repeat(reverse: true);
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _cameraController.initialize();
      if (mounted) {
        setState(() => _isCameraInitialized = true);
      }
    } catch (e) {
      // Handle camera initialization error
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFullScreenScanner) {
      return _buildFullScreenScanner();
    }
    return _buildHomeScreen();
  }

  Widget _buildHomeScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Stack(
        children: [
          // Scanner Area Background
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF2C3E50),
                  Color(0xFF3498DB),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Scanner Content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // QR Scanner Frame
                      Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Lottie Animation
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Lottie.asset(
                                  'assets/animations/qr-scan.json',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            // Scan Line Animation
                            AnimatedBuilder(
                              animation: _scannerAnimation,
                              builder: (context, child) {
                                return Positioned(
                                  top: 20 + (160 * _scannerAnimation.value),
                                  left: 20,
                                  right: 20,
                                  child: Container(
                                    height: 2,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.withOpacity(0.5),
                                          blurRadius: 5,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blue.withOpacity(0),
                                          Colors.blue,
                                          Colors.blue.withOpacity(0),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Pull down to scan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Sheet with actual content
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: MediaQuery.of(context).size.height * 0.4,
            // 40% of screen height
            child: NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                if (notification.extent <= 0.15) {
                  HapticFeedback.mediumImpact();
                  setState(() => _isFullScreenScanner = true);
                }
                return true;
              },
              child: DraggableScrollableSheet(
                initialChildSize: 1.0, // Takes full height of its container
                minChildSize: 0.25, // Can be pulled down to 25% of sheet height
                maxChildSize: 1.0,
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          // Pull Indicator
                          Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),

                          // Title with Icon
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.grid_view_rounded,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Quick Actions',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Grid Menu
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(20),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 1,
                            ),
                            itemCount: _actions.length,
                            itemBuilder: (context, index) {
                              final action = _actions[index];
                              return _buildActionButton(
                                icon: action['icon'],
                                label: action['title'],
                                gradient: action['gradient'],
                                onTap: () {
                                  // Handle action
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullScreenScanner() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full Screen Camera Preview
          if (_isCameraInitialized)
            Positioned.fill(
              child: CameraPreview(_cameraController),
            ),

          // Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
          ),

          // Scanner Area
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  // Scan Animation
                  Positioned.fill(
                    child: Lottie.asset(
                      'assets/animations/qr-scan-line.json',
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Corners
                  ...List.generate(4, (index) {
                    final isTop = index < 2;
                    final isLeft = index.isEven;
                    return Positioned(
                      top: isTop ? 0 : null,
                      bottom: !isTop ? 0 : null,
                      left: isLeft ? 0 : null,
                      right: !isLeft ? 0 : null,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border(
                            top: isTop
                                ? const BorderSide(
                                    color: Colors.white, width: 3)
                                : BorderSide.none,
                            bottom: !isTop
                                ? const BorderSide(
                                    color: Colors.white, width: 3)
                                : BorderSide.none,
                            left: isLeft
                                ? const BorderSide(
                                    color: Colors.white, width: 3)
                                : BorderSide.none,
                            right: !isLeft
                                ? const BorderSide(
                                    color: Colors.white, width: 3)
                                : BorderSide.none,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Header Controls
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                bottom: 16,
                left: 16,
                right: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close Button
                  GlassContainer(
                    padding: const EdgeInsets.all(12),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        setState(() => _isFullScreenScanner = false);
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  // Flash Button
                  GlassContainer(
                    padding: const EdgeInsets.all(12),
                    child: GestureDetector(
                      onTap: () async {
                        HapticFeedback.mediumImpact();
                        try {
                          final current = _cameraController.value.flashMode;
                          await _cameraController.setFlashMode(
                            current == FlashMode.torch
                                ? FlashMode.off
                                : FlashMode.torch,
                          );
                          setState(() {});
                        } catch (e) {
                          // Handle flash error
                        }
                      },
                      child: Icon(
                        _cameraController.value.flashMode == FlashMode.torch
                            ? Icons.flash_on
                            : Icons.flash_off,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Text
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 32,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  'Place QR code inside the frame',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Scanning will start automatically',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
