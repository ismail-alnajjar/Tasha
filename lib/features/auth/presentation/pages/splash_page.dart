import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tashaapp/core/routes/app_routes.dart';
import 'package:tashaapp/features/auth/presentation/widgets/splash_background_shape.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  // Design Specific Colors
  static const Color _primaryColor = Color(0xFFF2CC0D);
  static const Color _secondaryOrange = Color(0xFFF97316);
  static const Color _bgLight = Color(0xFFF8F8F5);
  // static const Color _bgDark = Color(0xFF221F10); // Keeping for reference if dark mode needed

  @override
  void initState() {
    super.initState();

    // Animation for loading bar (approx 3 seconds)
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _progressController.forward();

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // 1. Start Minimum Timer
    final minTimer = Future.delayed(const Duration(seconds: 3));

    // 2. Start Image Pre-caching (Local Assets)
    final imageLoading = _precacheImages();

    // 3. Wait for BOTH
    await Future.wait([minTimer, imageLoading]);

    // 4. Navigate
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
  }

  Future<void> _precacheImages() async {
    const List<String> imageAssets = [
      'assets/deadsea.png',
      'assets/albatraa.png',
      'assets/irbid.png',
    ];

    try {
      await Future.wait(
        imageAssets.map((path) => precacheImage(AssetImage(path), context)),
      );
    } catch (e) {
      debugPrint('Failed to precache images: $e');
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Assuming light mode for now as per the "class=light" in HTML,
    // but using Theme.of(context).brightness to check would be better if app supports complete dark mode.
    // For exact design matching, we'll start with the light theme base.
    final Color backgroundColor =
        _bgLight; // Force light for now to match exact preview or use isDark ? _bgDark : _bgLight;
    final Color textColor = const Color(0xFF181711);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // --- Abstract Background Shapes ---

            // Large Top Left Yellow Blob
            const SplashBackgroundShape(
              top: -80,
              left: -80,
              width: 320,
              height: 320,
              color: _primaryColor,
              opacity: 0.2,
              blurAmount: 60, // blur-3xl
            ),

            // Orange Shape Mid Right
            const SplashBackgroundShape(
              top: 200, // approx 1/4 down
              right: -40,
              width: 256,
              height: 256,
              color: _secondaryOrange,
              opacity: 0.1,
              blurAmount: 40, // blur-2xl
            ),

            // Floating Organic Shape 1 (Top Center-ish)
            SplashBackgroundShape(
              top: MediaQuery.sizeOf(context).height * 0.1,
              left: MediaQuery.sizeOf(context).width * 0.2,
              width: 128,
              height: 128,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_primaryColor, _secondaryOrange],
              ),
              opacity: 0.4,
              blurAmount: 20,
            ),

            // Floating Organic Shape 2 (Mid Left)
            SplashBackgroundShape(
              top: MediaQuery.sizeOf(context).height * 0.45,
              left: -32,
              width: 160,
              height: 160,
              color: _primaryColor.withOpacity(0.3),
              opacity: 0.6,
              // blurAmount: 0, // Sharp? HTML says just rounded-full bg-primary/30 opacity-60
            ),

            // Floating Organic Shape 3 (Bottom Right)
            SplashBackgroundShape(
              bottom: MediaQuery.sizeOf(context).height * 0.15,
              right: MediaQuery.sizeOf(context).width * 0.05,
              width: 192,
              height: 192,
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  _secondaryOrange.withOpacity(0.4),
                  _primaryColor.withOpacity(0.4),
                ],
              ),
              // shadow-inner logic hard to replicate exactly with basic boxshadow, but gradient is fine
            ),

            // Small Accent Dots
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.3,
              right: MediaQuery.sizeOf(context).width * 0.15,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: _primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.sizeOf(context).height * 0.4,
              left: MediaQuery.sizeOf(context).width * 0.1,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: _secondaryOrange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Decorative Floating Shapes (Foreground per HTML)
            const SplashBackgroundShape(
              bottom: 80,
              left: -40,
              width: 96,
              height: 96,
              color: _secondaryOrange,
              opacity: 0.2,
              blurAmount: 24,
            ),
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.5,
              right: 16,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _primaryColor.withOpacity(0.4),
                    width: 2,
                  ),
                ),
              ),
            ),

            // --- Content ---
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Spacing / Icon
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.auto_awesome, // "colors_spark" equivalent
                        color: textColor.withOpacity(0.4),
                        size: 24,
                      ),
                    ),

                    // Central Branding
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo Box
                        Container(
                          width: 96,
                          height: 96,
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: _primaryColor,
                            borderRadius: BorderRadius.circular(
                              24,
                            ), // "rounded-xl" approx 1rem or more
                            boxShadow: [
                              BoxShadow(
                                color: _primaryColor.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.bubble_chart,
                            color: Colors.white,
                            size:
                                48, // text-6xl is huge, approx 60px contextually, 48 is standard large icon
                          ),
                        ),
                        // App Name
                        Text(
                          'TASHA',
                          style: GoogleFonts.plusJakartaSans(
                            color: textColor,
                            fontSize: 48,
                            fontWeight: FontWeight.w800, // ExtraBold
                            letterSpacing: -1.0, // tracking-tight
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Creativity in every interaction',
                          style: TextStyle(
                            color: textColor.withOpacity(0.6),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    // Bottom Loading & Version Info
                    SizedBox(
                      width: 320, // max-w-xs
                      child: Column(
                        children: [
                          // Loading Indicator
                          Padding(
                            padding: const EdgeInsets.only(bottom: 48),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Loading experience...',
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    AnimatedBuilder(
                                      animation: _progressAnimation,
                                      builder: (context, child) {
                                        return Text(
                                          '${(_progressAnimation.value * 100).toInt()}%',
                                          style: TextStyle(
                                            color: textColor.withOpacity(0.5),
                                            fontSize: 12,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  height: 8,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFE6E4DB,
                                    ), // bg-[#e6e4db]
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: AnimatedBuilder(
                                    animation: _progressAnimation,
                                    builder: (context, child) {
                                      return FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: _progressAnimation.value,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: _primaryColor,
                                            borderRadius: BorderRadius.circular(
                                              999,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Version Info
                          Text(
                            'v1.2.0 (Splash Variant 7)',
                            style: TextStyle(
                              color: textColor.withOpacity(0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildDot(_primaryColor),
                              const SizedBox(width: 8),
                              _buildDot(const Color(0xFFE6E4DB)),
                              const SizedBox(width: 8),
                              _buildDot(const Color(0xFFE6E4DB)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
