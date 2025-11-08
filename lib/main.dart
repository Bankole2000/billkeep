import 'package:billkeep/models/user_model.dart';
import 'package:billkeep/utils/default_merchants.dart';
import 'package:billkeep/utils/default_wallet_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/screens/home/main_navigation_screen.dart';
import 'package:billkeep/screens/onboarding/index.dart';
import 'package:billkeep/screens/splash/splash_screen.dart';
import 'package:billkeep/providers/database_provider.dart';
import 'package:billkeep/utils/default_categories.dart';
import 'package:billkeep/utils/default_currencies.dart';
import 'package:camera/camera.dart';

// Global list of available cameras
List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize cameras
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error initializing cameras: $e');
  }

  runApp(const ProviderScope(child: BillKeepApp()));
}

class BillKeepApp extends ConsumerStatefulWidget {
  const BillKeepApp({super.key});

  @override
  ConsumerState<BillKeepApp> createState() => _BillKeepAppState();
}

class _BillKeepAppState extends ConsumerState<BillKeepApp> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Seed default categories if needed
    final database = ref.read(databaseProvider);
    await DefaultCategories.seedDefaultCategories(database);
    await DefaultMerchants.seedDefaultMerchants(database);
    await DefaultCurrencies.seedDefaultCurrencies(database);
    await DefaultWalletProviders.seedDefaultProviders(database);

    // Wait for minimum splash duration
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) =>
            _isInitialized ? const OnboardingCoordinator() : SplashScreen(),
        '/onboarding/welcome': (context) => const WelcomeCarouselScreen(),
        '/auth': (context) => const AuthScreen(),
        '/onboarding/config': (context) {
          final user = ModalRoute.of(context)!.settings.arguments as User;
          return InitialConfigScreen(user: user);
        },
        '/main': (context) => const MainNavigationScreen(),
      },
      title: 'BillKeep',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // home: _isInitialized
      //     ? const MainNavigationScreen()
      //     : const SplashScreen(),
    );
  }
}
