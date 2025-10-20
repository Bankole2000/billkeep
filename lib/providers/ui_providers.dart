import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/utils/app_colors.dart';

class BottomAppBarNavigationIndexNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void selectIndex(int index) {
    state = index;
  }
}

final bottomAppBarNavigationIndexProvider =
    NotifierProvider<BottomAppBarNavigationIndexNotifier, int>(
      BottomAppBarNavigationIndexNotifier.new,
    );

class ActiveThemeColor extends Notifier<Color> {
  @override
  Color build() {
    return Colors.purpleAccent;
  }

  void setActiveColor(Color color) {
    state = color;
  }
}

final activeThemeColorProvider = NotifierProvider<ActiveThemeColor, Color>(
  ActiveThemeColor.new,
);

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// Provides the active color scheme (light or dark)
final appColorsProvider = Provider<AppColorScheme>((ref) {
  // You can listen to ThemeMode or MediaQuery brightness here.
  // For now, we’ll detect the system brightness via WidgetsBinding.
  final themeMode = ref.watch(themeModeProvider);

  final brightness = switch (themeMode) {
    ThemeMode.dark => Brightness.dark,
    ThemeMode.light => Brightness.light,
    ThemeMode.system =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness,
  };
  return brightness == Brightness.dark ? AppColors.dark : AppColors.light;
});
