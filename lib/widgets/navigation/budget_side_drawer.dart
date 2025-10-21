import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/providers/ui_providers.dart';

class BudgetSideDrawer extends ConsumerWidget {
  const BudgetSideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeColor = ref.watch(activeThemeColorProvider);
    return Drawer(child: Placeholder());
  }
}
