import 'package:billkeep/widgets/examples/list_animation.dart';
import 'package:billkeep/widgets/examples/transaction_screenshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';

class AddTaskSubscreen extends ConsumerStatefulWidget {
  const AddTaskSubscreen({super.key});

  @override
  ConsumerState<AddTaskSubscreen> createState() => _AddTaskSubscreenState();
}

class _AddTaskSubscreenState extends ConsumerState<AddTaskSubscreen> {
  int _selectedSegment = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Custom Sliding Segmented Control')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Basic segmented control
            CustomSlidingSegmentedControl<int>(
              isStretch: true,
              children: {
                0: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.output_outlined,
                      size: 20,
                      color: Colors.redAccent,
                    ),
                    SizedBox(width: 6),
                    Text('Todo', style: TextStyle(fontSize: 16)),
                  ],
                ),
                1: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.input, size: 20, color: Colors.greenAccent),
                    SizedBox(width: 6),
                    Text('Shopping', style: TextStyle(fontSize: 16)),
                  ],
                ),
                2: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.swap_horiz, size: 20, color: Colors.blueAccent),
                    SizedBox(width: 6),
                    Text('Meeting', style: TextStyle(fontSize: 16)),
                  ],
                ),
              },
              onValueChanged: (value) {
                setState(() {
                  _selectedSegment = value;
                });
              },
              innerPadding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              thumbDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Display content based on selection
            Text('Selected Tab: $_selectedSegment'),
            // NewTransactionSheet(),
            // SlidingListTiles(),
          ],
        ),
      ),
    );
  }
}
