import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_preferences_provider.dart';
import '../providers/currency_provider.dart';

/// Example widget demonstrating how to use UserPreferences
class UserPreferencesExample extends ConsumerWidget {
  const UserPreferencesExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the default currency code from preferences
    final defaultCurrency = ref.watch(defaultCurrencyProvider);

    // Watch the actual currency object from the database
    final defaultCurrencyObject = ref.watch(defaultCurrencyObjectProvider);

    // Watch other preferences
    final themeMode = ref.watch(themeModeProvider);
    final language = ref.watch(languageProvider);
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Preferences Example'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Display current default currency
          Card(
            child: ListTile(
              title: const Text('Default Currency'),
              subtitle: defaultCurrencyObject.when(
                data: (currency) => Text(
                  currency != null
                    ? '${currency.code} - ${currency.name} (${currency.symbol})'
                    : 'Loading...'
                ),
                loading: () => const Text('Loading...'),
                error: (_, __) => const Text('Error loading currency'),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Change default currency
                  ref.read(defaultCurrencyProvider.notifier).state = 'EUR';

                  // Also save to SharedPreferences
                  ref.read(userPreferencesServiceProvider)
                    .setDefaultCurrency('EUR');
                },
              ),
            ),
          ),

          // Display theme mode
          Card(
            child: ListTile(
              title: const Text('Theme Mode'),
              subtitle: Text(themeMode),
              trailing: DropdownButton<String>(
                value: themeMode,
                items: const [
                  DropdownMenuItem(value: 'light', child: Text('Light')),
                  DropdownMenuItem(value: 'dark', child: Text('Dark')),
                  DropdownMenuItem(value: 'system', child: Text('System')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    // Update provider
                    ref.read(themeModeProvider.notifier).state = value;

                    // Save to SharedPreferences
                    ref.read(userPreferencesServiceProvider)
                      .setThemeMode(value);
                  }
                },
              ),
            ),
          ),

          // Display language
          Card(
            child: ListTile(
              title: const Text('Language'),
              subtitle: Text(language),
              trailing: DropdownButton<String>(
                value: language,
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'es', child: Text('Spanish')),
                  DropdownMenuItem(value: 'fr', child: Text('French')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref.read(languageProvider.notifier).state = value;
                    ref.read(userPreferencesServiceProvider)
                      .setLanguage(value);
                  }
                },
              ),
            ),
          ),

          // Display notifications toggle
          Card(
            child: SwitchListTile(
              title: const Text('Notifications'),
              subtitle: const Text('Enable push notifications'),
              value: notificationsEnabled,
              onChanged: (value) {
                ref.read(notificationsEnabledProvider.notifier).state = value;
                ref.read(userPreferencesServiceProvider)
                  .setNotificationsEnabled(value);
              },
            ),
          ),

          const SizedBox(height: 24),

          // Sync buttons
          ElevatedButton.icon(
            onPressed: () async {
              try {
                // Sync to backend (replace 'userId' with actual user ID)
                final prefsNotifier = ref.read(userPreferencesNotifierProvider.notifier);
                await prefsNotifier.syncToBackend('user-id-here');

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Synced to backend successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sync failed: $e')),
                  );
                }
              }
            },
            icon: const Icon(Icons.cloud_upload),
            label: const Text('Sync to Backend'),
          ),

          const SizedBox(height: 8),

          ElevatedButton.icon(
            onPressed: () async {
              try {
                // Sync from backend (replace 'userId' with actual user ID)
                final prefsNotifier = ref.read(userPreferencesNotifierProvider.notifier);
                await prefsNotifier.syncFromBackend('user-id-here');

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Synced from backend successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sync failed: $e')),
                  );
                }
              }
            },
            icon: const Icon(Icons.cloud_download),
            label: const Text('Sync from Backend'),
          ),

          const SizedBox(height: 8),

          ElevatedButton.icon(
            onPressed: () async {
              try {
                // Full bidirectional sync (replace 'userId' with actual user ID)
                final prefsNotifier = ref.read(userPreferencesNotifierProvider.notifier);
                await prefsNotifier.performFullSync('user-id-here');

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Full sync completed successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sync failed: $e')),
                  );
                }
              }
            },
            icon: const Icon(Icons.sync),
            label: const Text('Full Sync'),
          ),
        ],
      ),
    );
  }
}
