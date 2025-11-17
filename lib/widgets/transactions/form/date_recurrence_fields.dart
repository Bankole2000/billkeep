import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/ui_providers.dart';
import '../../../utils/app_enums.dart';
import '../../../utils/date_helpers.dart';

/// Date selector tile for transaction forms
class DateSelectorTile extends ConsumerWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const DateSelectorTile({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);

    return ListTile(
      tileColor: colors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 30),
      visualDensity: const VisualDensity(vertical: 0.1),
      leading: Icon(
        Icons.calendar_today_outlined,
        color: colors.text,
      ),
      title: Row(
        children: [
          Text(
            'Date: ',
            style: TextStyle(color: colors.textMute),
          ),
          Text(
            selectedDate == null
                ? 'Select Date'
                : dateFormatter.format(selectedDate!),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

/// Recurrence selector tile with optional reminder switch
class RecurrenceSelectorTile extends ConsumerWidget {
  final TransactionRecurrence recurrence;
  final bool setReminder;
  final VoidCallback onTap;
  final ValueChanged<bool> onReminderChanged;

  const RecurrenceSelectorTile({
    super.key,
    required this.recurrence,
    required this.setReminder,
    required this.onTap,
    required this.onReminderChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);

    return Column(
      children: [
        ListTile(
          tileColor: colors.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 30),
          visualDensity: const VisualDensity(vertical: 0.1),
          leading: Icon(Icons.repeat, color: colors.text),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Repeat: ',
                style: TextStyle(color: colors.textMute),
              ),
              Text(
                recurrenceOptions[recurrence]!,
                style: TextStyle(color: colors.text),
              ),
            ],
          ),
          trailing: recurrence != TransactionRecurrence.never && setReminder
              ? IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings),
                )
              : null,
          onTap: onTap,
        ),

        // Reminder switch (animated)
        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: SizedBox(
              height: recurrence == TransactionRecurrence.never ? 0 : null,
              child: SwitchListTile(
                value: setReminder,
                onChanged: onReminderChanged,
                title: const Text('Send me Reminders'),
                subtitle: const Text(
                  'You\'ll be notified of upcoming transactions',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Simple selector tile (for tags, contacts, etc.)
class SimpleSelectorTile extends ConsumerWidget {
  final String label;
  final IconData icon;
  final String? selectedText;
  final VoidCallback onTap;

  const SimpleSelectorTile({
    super.key,
    required this.label,
    required this.icon,
    this.selectedText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);

    return ListTile(
      tileColor: colors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 30),
      visualDensity: const VisualDensity(vertical: 0.1),
      leading: Icon(icon, color: colors.text),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(color: colors.textMute),
          ),
          if (selectedText != null)
            Flexible(
              child: Text(
                selectedText!,
                style: TextStyle(color: colors.text),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}
