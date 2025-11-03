import 'package:billkeep/widgets/projects/project_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OldUIHomeScreen extends ConsumerWidget {
  const OldUIHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Old User Interface')),
      body: ProjectList(),
    );
  }
}
