import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WelcomeCarouselScreen extends ConsumerStatefulWidget {
  const WelcomeCarouselScreen({super.key});

  @override
  ConsumerState<WelcomeCarouselScreen> createState() => _WelcomeCarouselScreenState();
}

class _WelcomeCarouselScreenState extends ConsumerState<WelcomeCarouselScreen> {
  late final AppColorScheme colors;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final List<OnboardingSlide> _slides = [
    OnboardingSlide(
      title: 'Welcome to BillKeep',
      description: 'Your all-in-one financial management companion',
      features: [
        'Track expenses and income',
        'Manage multiple projects',
        'Set budgets and goals',
        'Monitor your financial health',
      ],
      icon: Icons.account_balance_wallet,
      color: colors.navy!,
    ),
    OnboardingSlide(
      title: 'Smart Organization',
      description: 'Keep your finances organized and under control',
      features: [
        'Categorize transactions',
        'Create shopping lists',
        'Manage todos and tasks',
        'Track recurring payments',
      ],
      icon: Icons.folder_special,
      color: colors.wave!,
    ),
    OnboardingSlide(
      title: 'Insights & Reports',
      description: 'Understand your spending and earning patterns',
      features: [
        'Visual charts and graphs',
        'Expense analytics',
        'Budget tracking',
        'Financial forecasting',
      ],
      icon: Icons.bar_chart,
      color: colors.earth!,
    ),
    OnboardingSlide(
      title: 'Multi-Currency',
      description: 'Manage finances across different currencies',
      features: [
        'Support for crypto and fiat',
        'Multiple wallets',
        'Investment tracking',
        'Global financial management',
      ],
      icon: Icons.currency_exchange,
      color: colors.electric!,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    colors = ref.read(appColorsProvider);
  }

  void _navigateToAuth() {
    Navigator.pushReplacementNamed(context, '/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _navigateToAuth,
                  child: const Text('Skip', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),

            // Carousel
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return _buildSlide(_slides[index]);
                },
              ),
            ),

            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (index) => _buildPageIndicator(index),
                ),
              ),
            ),

            // Get Started button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _navigateToAuth,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.text,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentPage == _slides.length - 1 ? 'Get Started' : 'Next',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(OnboardingSlide slide) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: slide.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(slide.icon, size: 64, color: slide.color),
          ),
          const SizedBox(height: 40),

          // Title
          Text(
            slide.title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            slide.description,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // Features list
          Column(
            children: slide.features.map((feature) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: slide.color, size: 24),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Theme.of(context).primaryColor
            : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingSlide {
  final String title;
  final String description;
  final List<String> features;
  final IconData icon;
  final Color color;

  OnboardingSlide({
    required this.title,
    required this.description,
    required this.features,
    required this.icon,
    required this.color,
  });
}
