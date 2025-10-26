import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/utils/app_enums.dart';
import 'package:billkeep/widgets/common/sliding_segment_control_label.dart';
import 'package:billkeep/widgets/transactions/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';

class AddTransactionSubscreen extends ConsumerStatefulWidget {
  const AddTransactionSubscreen({super.key});

  @override
  ConsumerState<AddTransactionSubscreen> createState() =>
      _AddTransactionSubscreenState();
}

class _AddTransactionSubscreenState
    extends ConsumerState<AddTransactionSubscreen> {
  TransactionType _selectedSegment = TransactionType.expense;
  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Basic segmented control
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomSlidingSegmentedControl<TransactionType>(
            isStretch: true,
            children: {
              TransactionType.expense: SlidingSegmentControlLabel(
                isActive: _selectedSegment == TransactionType.expense,
                label: 'Expense',
                icon: Icons.output_outlined,
                activeColor: colors.fire,
              ),
              TransactionType.income: SlidingSegmentControlLabel(
                icon: Icons.input,
                label: 'Income',
                isActive: _selectedSegment == TransactionType.income,
                activeColor: colors.wave,
              ),
              TransactionType.transfer: SlidingSegmentControlLabel(
                icon: Icons.swap_horiz,
                label: 'Transfer',
                isActive: _selectedSegment == TransactionType.transfer,
                activeColor: colors.water,
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
        ),
        // Display content based on selection
        TransactionForm(transactionType: _selectedSegment),
      ],
    );
  }
}
