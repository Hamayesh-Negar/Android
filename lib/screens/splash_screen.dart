import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../services/network_service.dart';
import '../theme/app_theme.dart';
import '../theme/glass_container.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _loadingController;
  bool _isLoading = true;
  String _statusMessage = 'Initializing...';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _logoController.forward();
    _checkConnectionAndProceed();
  }

  Future<void> _checkConnectionAndProceed() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      setState(() => _statusMessage = 'Checking network connection...');
      await Future.delayed(const Duration(seconds: 1));

      final networkService =
          Provider.of<NetworkService>(context, listen: false);
      final hasConnection = await networkService.checkConnectivity();

      if (!hasConnection) {
        setState(() {
          _errorMessage = 'You are offline!';
          _isLoading = false;
        });
        return;
      }

      setState(() => _statusMessage = 'Checking server status...');
      await Future.delayed(const Duration(milliseconds: 500));

      final isServerHealthy = await networkService.checkServer();
      if (!isServerHealthy) {
        setState(() {
          _errorMessage = 'Server is tired :(';
          _isLoading = false;
        });
        return;
      }

      setState(() => _statusMessage = 'Ready to go!');
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = "I'm sorry, something went wrong :(";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.backgroundGradient,
            ),
          ),

          // Decorative Elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.5),
                    AppTheme.accentColor.withOpacity(0.2),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: CurvedAnimation(
                        parent: _logoController,
                        curve: Curves.elasticOut,
                      ),
                      child: GlassContainer(
                        child: Container(
                          height: 150,
                          width: 150,
                          padding: const EdgeInsets.all(5),
                          child: _errorMessage != null
                              ? Lottie.asset(
                                  'assets/animations/error.json',
                                  repeat: true,
                                )
                              : Lottie.asset(
                                  'assets/animations/qr-code.json',
                                  repeat: true,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Hamayesh Negar',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _statusMessage,
                        key: ValueKey(_statusMessage),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (_isLoading)
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: Lottie.asset(
                          'assets/animations/loading.json',
                          controller: _loadingController,
                          onLoaded: (composition) {
                            _loadingController
                              ..duration = composition.duration
                              ..repeat();
                          },
                        ),
                      )
                    else if (_errorMessage != null)
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.red.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red.shade300,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _errorMessage!,
                                  style: TextStyle(
                                    color: Colors.red.shade300,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _checkConnectionAndProceed,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.refresh),
                                SizedBox(width: 8),
                                Text('Try Again'),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _loadingController.dispose();
    super.dispose();
  }
}
