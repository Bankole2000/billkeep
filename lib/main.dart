import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/screens/home/main_navigation_screen.dart';
import 'package:billkeep/providers/database_provider.dart';
import 'package:billkeep/utils/default_categories.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: BillKeepApp()));
}

class BillKeepApp extends ConsumerStatefulWidget {
  const BillKeepApp({super.key});

  @override
  ConsumerState<BillKeepApp> createState() => _BillKeepAppState();
}

class _BillKeepAppState extends ConsumerState<BillKeepApp> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Seed default categories if needed
    final database = ref.read(databaseProvider);
    await DefaultCategories.seedDefaultCategories(database);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BillKeep',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}
