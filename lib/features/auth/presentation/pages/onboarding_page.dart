import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tashaapp/core/routes/app_routes.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Relax at the Dead Sea',
      'description': 'A unique experience at the lowest point on Earth.',
      'image': 'assets/deadsea.png',
    },
    {
      'title': 'Explore Petra',
      'description':
          'Discover the Rose City, a world wonder carved into red rock.',
      'image': 'assets/albatraa.png',
    },
    {
      'title': 'Nature of Irbid',
      'description':
          'Enjoy the breathtaking green landscapes and serenity of the north.',
      'image': 'assets/irbid.png',
    },
  ];

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.Typeuser);
    }
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, AppRoutes.Typeuser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101622), // background-dark
      body: Stack(
        children: [
          // Background Image with Fade Transition
          PageView.builder(
            controller: _pageController,
            itemCount: _onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    _onboardingData[index]['image']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.error, color: Colors.white),
                      );
                    },
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Skip Button (Top Right)
          Positioned(
            top: 56, // pt-14 approx
            right: 24, // p-6
            child: GestureDetector(
              onTap: _skip,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999), // rounded-full
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // ios-blur
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    color: Colors.black.withOpacity(0.2), // bg-black/20
                    child: Text(
                      'Skip',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom Card content
          Positioned(
            left: 24,
            right: 24,
            bottom: 48, // pb-12
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40), // rounded-[2.5rem]
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // ios-blur
                child: Container(
                  padding: const EdgeInsets.all(32), // p-8
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1), // bg-white/10
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          0.25,
                        ), // shadow-2xl approx
                        blurRadius: 50, // 2xl
                        spreadRadius: -12,
                        offset: const Offset(0, 25),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Text Content
                      Column(
                        children: [
                          Text(
                            _onboardingData[_currentPage]['title']!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 30, // text-3xl
                              fontWeight: FontWeight.bold,
                              height: 1.25, // leading-tight
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _onboardingData[_currentPage]['description']!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 17, // text-[17px]
                              fontWeight: FontWeight.w400,
                              height: 1.625, // leading-relaxed
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32), // gap-8 (32px)
                      // Dots Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_onboardingData.length, (
                          index,
                        ) {
                          final bool isActive = index == _currentPage;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: isActive ? 24 : 6, // w-6 or w-1.5
                            height: 6, // h-1.5
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 32),

                      // Next Button
                      SizedBox(
                        width: double.infinity,
                        height: 60, // h-15 (15 * 4 = 60px)
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD600), // primary
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shadowColor: Colors.black.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                16,
                              ), // rounded-2xl
                            ),
                          ),
                          child: Text(
                            _currentPage == _onboardingData.length - 1
                                ? 'Get Started'
                                : 'Next',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18, // text-lg
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
