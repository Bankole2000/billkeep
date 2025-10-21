import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddReportsScreen extends ConsumerWidget {
  const AddReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text(
          'Add Reports (Projections, What Ifs, Planners, Wishlists, & WIGs)',
        ),
      ),
    );
  }
}
