import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool _isFullScreenScanner = false;
  late CameraController _cameraController;
  bool _isCameraInitialized = false;

  final List<Map<String, dynamic>> _actions = [
    {
      'title': 'Task Manager',
      'icon': Icons.assignment_outlined,
      'color': Colors.blue,
    },
    {
      'title': 'Categories',
      'icon': Icons.category_outlined,
      'color': Colors.orange,
    },
    {
      'title': 'People',
      'icon': Icons.people_outline,
      'color': Colors.purple,
    },
    {
      'title': 'Statistics',
      'icon': Icons.bar_chart,
      'color': Colors.green,
    },
    {
      'title': 'Settings',
      'icon': Icons.settings_outlined,
      'color': Colors.blueGrey,
    },
    {
      'title': 'Reports',
      'icon': Icons.summarize_outlined,
      'color': Colors.red,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
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

  void _openFullScreenScanner() {
    setState(() => _isFullScreenScanner = true);
    _cameraController.resumePreview();
  }

  void _closeFullScreenScanner() {
    setState(() => _isFullScreenScanner = false);
    _cameraController.pausePreview();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFullScreenScanner) {
      return _buildFullScreenScanner();
    }
    return _buildHomeScreen();
  }

  Widget _buildFullScreenScanner() {
    return Scaffold(
      body: Stack(
        children: [
          // Camera Preview
          if (_isCameraInitialized)
            CameraPreview(_cameraController),

          // Scanner Overlay
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
            child: Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    // Scanner Animation
                    Positioned.fill(
                      child: Lottie.asset(
                        'assets/animations/loading.json',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Corner Decorations
                    ...List.generate(4, (index) => _buildCorner(index)),
                  ],
                ),
              ),
            ),
          ),

          // Close Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: IconButton(
                onPressed: _closeFullScreenScanner,
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeScreen() {
    return Scaffold(
      body: Stack(
        children: [
          // Static Scanner Animation Area
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            color: AppTheme.darkColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // QR Scanner Animation
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Lottie.asset(
                      'assets/animations/qr-code.json',
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pull down to scan',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Sheet
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              if (notification.extent <= notification.minExtent) {
                _openFullScreenScanner();
              }
              return true;
            },
            child: DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.15,
              maxChildSize: 0.85,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppTheme.darkColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Drag Handle
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // Title
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Text(
                          'Choose Action',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Grid Menu
                      Expanded(
                        child: GridView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                              color: action['color'],
                              onTap: () {
                                // Handle action tap
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(int index) {
    final isTop = index < 2;
    final isLeft = index.isEven;
    return Positioned(
      top: isTop ? -2 : null,
      bottom: !isTop ? -2 : null,
      left: isLeft ? -2 : null,
      right: !isLeft ? -2 : null,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isTop && isLeft ? 8 : 0),
            topRight: Radius.circular(isTop && !isLeft ? 8 : 0),
            bottomLeft: Radius.circular(!isTop && isLeft ? 8 : 0),
            bottomRight: Radius.circular(!isTop && !isLeft ? 8 : 0),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
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