import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/utils/app_enums.dart';
import 'package:billkeep/widgets/common/sliding_segment_control_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';

class AddTaskSubscreen extends ConsumerStatefulWidget {
  const AddTaskSubscreen({super.key});

  @override
  ConsumerState<AddTaskSubscreen> createState() => _AddTaskSubscreenState();
}

class _AddTaskSubscreenState extends ConsumerState<AddTaskSubscreen> {
  TaskType _selectedSegment = TaskType.todo;

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final activeColor = ref.watch(activeThemeColorProvider);
    return Scaffold(
      backgroundColor: colors.surface,
      // appBar: AppBar(title: Text('Custom Sliding Segmented Control')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Basic segmented control
            CustomSlidingSegmentedControl<TaskType>(
              isStretch: true,
              children: {
                TaskType.todo: SlidingSegmentControlLabel(
                  isActive: _selectedSegment == TaskType.todo,
                  label: 'Todo',
                  icon: taskIcons[TaskType.todo]!,
                  activeColor: colors.wave,
                ),
                TaskType.shopping: SlidingSegmentControlLabel(
                  isActive: _selectedSegment == TaskType.shopping,
                  label: 'Shopping',
                  icon: taskIcons[TaskType.shopping]!,
                  activeColor: colors.earth,
                ),
                TaskType.meeting: SlidingSegmentControlLabel(
                  isActive: _selectedSegment == TaskType.meeting,
                  label: 'Event',
                  icon: taskIcons[TaskType.meeting]!,
                  activeColor: colors.navy,
                ),
              },
              onValueChanged: (value) {
                setState(() {
                  _selectedSegment = value;
                });
              },
              innerPadding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              thumbDecoration: BoxDecoration(
                color: colors.surface,
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
