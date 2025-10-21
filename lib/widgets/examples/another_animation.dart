import 'package:flutter/material.dart';

class SmoothSlideTile extends StatefulWidget {
  const SmoothSlideTile({super.key});

  @override
  State<SmoothSlideTile> createState() => _SmoothSlideTileState();
}

class _SmoothSlideTileState extends State<SmoothSlideTile>
    with SingleTickerProviderStateMixin {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smooth Animated Tile')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSlide(
            offset: _visible ? Offset.zero : const Offset(0, -0.3),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: ListTile(
                title: const Text(
                  '₦25,000 Payment Received',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                subtitle: const Text('Tap for details'),
                tileColor: Colors.blue.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => setState(() => _visible = !_visible),
            child: Text(_visible ? 'Hide Tile' : 'Show Tile'),
          ),
        ],
      ),
    );
  }
}
