import 'package:flutter/material.dart';

class NewTransactionSheet extends StatelessWidget {
  const NewTransactionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final darkColor = const Color(0xFF2B2E2E);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: darkColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Close button
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            const SizedBox(height: 8),
            const Text(
              "New transaction",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 12),

            // Amount display
            const Text(
              "₦0",
              style: TextStyle(
                fontSize: 48,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Transaction type selector
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: (0.2)),
                borderRadius: BorderRadius.circular(32),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SegmentButton(label: "EXPENSE", selected: true),
                  _SegmentButton(label: "INCOME"),
                  _SegmentButton(label: "TRANSFER"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Divider(color: Colors.white24),

            const _InfoRow(
              icon: Icons.category_outlined,
              title: "Category",
              value: "Miscellaneous",
              leadingColor: Colors.grey,
            ),

            const _InfoRow(
              icon: Icons.account_balance_wallet_outlined,
              title: "From",
              value: "Spending",
              leadingColor: Colors.blueAccent,
              trailingIcon: Icons.swap_horiz_rounded,
            ),

            const _InfoRow(
              icon: Icons.note_outlined,
              title: "Note",
              value: " ",
            ),

            const _InfoRow(
              icon: Icons.calendar_today_outlined,
              title: "Today",
              value: "",
              trailingIcon: Icons.chevron_right,
            ),

            const _InfoRow(
              icon: Icons.sync_outlined,
              title: "Never repeat",
              value: "",
            ),

            const _ToggleRow(
              icon: Icons.pie_chart_outline,
              title: "Exclude from budget",
            ),

            const SizedBox(height: 24),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {},
                child: const Text(
                  "SAVE",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final bool selected;

  const _SegmentButton({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? leadingColor;
  final IconData? trailingIcon;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
    this.leadingColor,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor:
                leadingColor?.withValues(alpha: 0.15) ?? Colors.transparent,
            child: Icon(icon, color: leadingColor ?? Colors.white70),
          ),
          title: Text(
            "$title: ",
            style: const TextStyle(color: Colors.white70),
          ),
          subtitle: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: trailingIcon != null
              ? CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: Icon(trailingIcon, color: Colors.white70),
                )
              : null,
        ),
        const Divider(color: Colors.white24),
      ],
    );
  }
}

class _ToggleRow extends StatefulWidget {
  final IconData icon;
  final String title;

  const _ToggleRow({required this.icon, required this.title});

  @override
  State<_ToggleRow> createState() => _ToggleRowState();
}

class _ToggleRowState extends State<_ToggleRow> {
  bool toggled = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(widget.icon, color: Colors.white70),
          title: Text(
            widget.title,
            style: const TextStyle(color: Colors.white),
          ),
          trailing: Switch(
            value: toggled,
            onChanged: (val) => setState(() => toggled = val),
            activeThumbColor: Colors.white,
            inactiveThumbColor: Colors.grey,
          ),
        ),
        const Divider(color: Colors.white24),
      ],
    );
  }
}
