import 'package:flutter/material.dart';
import 'dart:ui';

class WalletDropdownWithAddButton extends StatefulWidget {
  const WalletDropdownWithAddButton({super.key});

  @override
  State<WalletDropdownWithAddButton> createState() =>
      _WalletDropdownWithAddButtonState();
}

class _WalletDropdownWithAddButtonState
    extends State<WalletDropdownWithAddButton> {
  List<String> wallets = ['Main Wallet', 'Project A', 'Savings'];

  String selectedWallet = 'Main Wallet';
  bool isDropdownOpen = false;

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _toggleDropdown() {
    if (isDropdownOpen) {
      _overlayEntry?.remove();
      isDropdownOpen = false;
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      isDropdownOpen = true;
    }
    setState(() {});
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        left: offset.dx,
        top: offset.dy + size.height + 4,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 8),
          child: Material(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 256 / 10 * 9),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...wallets.map(
                        (wallet) => ListTile(
                          title: Text(wallet),
                          onTap: () {
                            setState(() {
                              selectedWallet = wallet;
                            });
                            _toggleDropdown();
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      TextButton.icon(
                        onPressed: () async {
                          _toggleDropdown();
                          final newWallet = await _showAddDialog();
                          if (newWallet != null && newWallet.isNotEmpty) {
                            setState(() => wallets.add(newWallet));
                          }
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text('Add new wallet'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> _showAddDialog() async {
    String newName = '';
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Wallet'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Wallet name'),
          onChanged: (val) => newName = val,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, newName),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 256 / 4),
            borderRadius: BorderRadius.circular(0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selectedWallet,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(width: 8),
              Icon(
                isDropdownOpen
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
