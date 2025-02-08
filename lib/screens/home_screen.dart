import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;

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
    // Auto-scroll banner
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentBannerIndex < 2) {
        _currentBannerIndex++;
      } else {
        _currentBannerIndex = 0;
      }
      if (_bannerController.hasClients) {
        _bannerController.animateToPage(
          _currentBannerIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
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
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Camera Preview Area
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: _isCameraInitialized
                ? CameraPreview(_cameraController)
                : const Center(child: CircularProgressIndicator()),
          ),

          // QR Frame Overlay
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCorner(true, true),
                        _buildCorner(true, false),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCorner(false, true),
                        _buildCorner(false, false),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Sheet Content
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: AppTheme.darkColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
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

                    // Banner Section
                    SizedBox(
                      height: 120,
                      child: PageView.builder(
                        controller: _bannerController,
                        onPageChanged: (index) {
                          setState(() => _currentBannerIndex = index);
                        },
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.primaryColor.withOpacity(0.8),
                                  AppTheme.accentColor.withOpacity(0.6),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                'Banner ${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Banner Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 12,
                          ),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentBannerIndex == index
                                ? AppTheme.primaryColor
                                : Colors.white.withOpacity(0.3),
                          ),
                        );
                      }),
                    ),

                    // Grid Menu
                    Expanded(
                      child: GridView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
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
        ],
      ),
    );
  }

  Widget _buildCorner(bool top, bool left) {
    return Container(
      width: 20,
      height: 20,
      margin: EdgeInsets.only(
        left: left ? 8 : 0,
        right: left ? 0 : 8,
        top: top ? 8 : 0,
        bottom: top ? 0 : 8,
      ),
      decoration: BoxDecoration(
        border: Border(
          left: left
              ? BorderSide(color: AppTheme.primaryColor, width: 2)
              : BorderSide.none,
          top: top
              ? BorderSide(color: AppTheme.primaryColor, width: 2)
              : BorderSide.none,
          right: !left
              ? BorderSide(color: AppTheme.primaryColor, width: 2)
              : BorderSide.none,
          bottom: !top
              ? BorderSide(color: AppTheme.primaryColor, width: 2)
              : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: left && top ? const Radius.circular(8) : Radius.zero,
          topRight: !left && top ? const Radius.circular(8) : Radius.zero,
          bottomLeft: left && !top ? const Radius.circular(8) : Radius.zero,
          bottomRight: !left && !top ? const Radius.circular(8) : Radius.zero,
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
