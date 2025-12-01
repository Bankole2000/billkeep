import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/database.dart';
import '../../providers/income_provider.dart';
import '../../utils/currency_helper.dart';

class IncomeListItem extends ConsumerStatefulWidget {
  final IncomeData income;

  const IncomeListItem({super.key, required this.income});

  @override
  ConsumerState<IncomeListItem> createState() => _IncomeListItemState();
}

class _IncomeListItemState extends ConsumerState<IncomeListItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final paymentsAsync = ref.watch(incomePaymentsProvider(widget.income.id));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(
              right: 6,
              left: 16,
              top: 4,
              bottom: 4,
            ),
            title: Text(widget.income.description),
            subtitle: Text(
              '${widget.income.type}${widget.income.frequency != null ? ' - ${widget.income.frequency}' : ''}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      CurrencyHelper.formatAmount(widget.income.expectedAmount),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    paymentsAsync.when(
                      data: (payments) {
                        if (payments.isEmpty) {
                          return const Text(
                            'No payments',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          );
                        }
                        final total = payments.fold<int>(
                          0,
                          (sum, p) => sum + p.actualAmount,
                        );
                        return Text(
                          'Received: ${CurrencyHelper.formatAmount(total)}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.green,
                          ),
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
                // More options button
                SizedBox(width: 8),

                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  onPressed: () {
                    setState(() => _isExpanded = !_isExpanded);
                  },
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditDialog(context);
                    } else if (value == 'toggle_active') {
                      // ref
                      //     .read(incomeRepositoryProvider)
                      //     .toggleIncomeActive(
                      //       widget.income.id,
                      //       !widget.income.isActive,
                      //     );
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(context);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'toggle_active',
                      child: Row(
                        children: [
                          Icon(
                            widget.income.isActive
                                ? Icons.pause
                                : Icons.play_arrow,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(widget.income.isActive ? 'Pause' : 'Activate'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Expandable payments section (keep existing code)
          if (_isExpanded)
            paymentsAsync.when(
              data: (payments) {
                if (payments.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text('No payments recorded yet'),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            _showRecordPaymentDialog(context);
                          },
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Record Payment'),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    const Divider(height: 1),
                    // In the payment ListTile inside the expandable section, update to:
                    ...payments.map(
                      (payment) => ListTile(
                        dense: true,
                        leading: Icon(
                          payment.source == 'MANUAL' ? Icons.edit : Icons.sms,
                          size: 16,
                        ),
                        title: Text(
                          CurrencyHelper.formatAmount(payment.actualAmount),
                          style: const TextStyle(fontSize: 14),
                        ),
                        subtitle: Text(
                          '${payment.paymentDate.toString().split(' ')[0]} - ${payment.source}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (payment.verified)
                              const Icon(
                                Icons.check_circle,
                                size: 16,
                                color: Colors.green,
                              )
                            else
                              const Icon(
                                Icons.help_outline,
                                size: 16,
                                color: Colors.orange,
                              ),
                            PopupMenuButton<String>(
                              padding: EdgeInsets.zero,
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _showEditPaymentDialog(context, payment);
                                } else if (value == 'delete') {
                                  _showDeletePaymentConfirmation(
                                    context,
                                    payment.id,
                                  );
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, size: 16),
                                      SizedBox(width: 8),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showRecordPaymentDialog(context);
                        },
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Record Payment'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
              error: (_, __) => const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Error loading payments'),
              ),
            ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final descriptionController = TextEditingController(
      text: widget.income.description,
    );
    final amountController = TextEditingController(
      text: (widget.income.expectedAmount / 100).toStringAsFixed(2),
    );
    final invoiceController = TextEditingController(
      text: widget.income.invoiceNumber,
    );
    final notesController = TextEditingController(text: widget.income.notes);
    String type = widget.income.type;
    String? frequency = widget.income.frequency;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Income'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                    prefixText: '\$ ',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: type,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'ONE_TIME',
                      child: Text('One-time'),
                    ),
                    DropdownMenuItem(
                      value: 'RECURRING',
                      child: Text('Recurring'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      type = value!;
                      if (type == 'ONE_TIME') {
                        frequency = null;
                      } else {
                        frequency ??= 'MONTHLY';
                      }
                    });
                  },
                ),
                if (type == 'RECURRING') ...[
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: frequency,
                    decoration: const InputDecoration(
                      labelText: 'Frequency',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'MONTHLY',
                        child: Text('Monthly'),
                      ),
                      DropdownMenuItem(value: 'YEARLY', child: Text('Yearly')),
                    ],
                    onChanged: (value) {
                      setState(() => frequency = value);
                    },
                  ),
                ],
                const SizedBox(height: 16),
                TextField(
                  controller: invoiceController,
                  decoration: const InputDecoration(
                    labelText: 'Invoice Number (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // await ref
                //     .read(incomeRepositoryProvider)
                //     .updateIncome(
                //       incomeId: widget.income.id,
                //       description: descriptionController.text.trim(),
                //       amount: amountController.text.trim(),
                //       type: type,
                //       frequency: frequency,
                //       invoiceNumber: invoiceController.text.trim().isEmpty
                //           ? null
                //           : invoiceController.text.trim(),
                //       notes: notesController.text.trim().isEmpty
                //           ? null
                //           : notesController.text.trim(),
                //     );
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Income updated')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Income?'),
        content: const Text(
          'This will permanently delete the income and all its payments.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // await ref
              //     .read(incomeRepositoryProvider)
              //     .deleteIncome(widget.income.id);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Income deleted')));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showRecordPaymentDialog(BuildContext context) {
    final amountController = TextEditingController(
      text: (widget.income.expectedAmount / 100).toStringAsFixed(2),
    );
    DateTime paymentDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Record Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount Received',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Payment Date'),
                subtitle: Text(paymentDate.toString().split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: paymentDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => paymentDate = date);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // await ref
                //     .read(incomeRepositoryProvider)
                //     .recordPayment(
                //       incomeId: widget.income.id,
                //       actualAmount: amountController.text.trim(),
                //       paymentDate: paymentDate,
                //     );
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Record'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditPaymentDialog(BuildContext context, Payment payment) {
    final amountController = TextEditingController(
      text: (payment.actualAmount / 100).toStringAsFixed(2),
    );
    final notesController = TextEditingController(text: payment.notes);
    DateTime paymentDate = payment.paymentDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Payment Date'),
                subtitle: Text(paymentDate.toString().split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: paymentDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => paymentDate = date);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // await ref
                //     .read(incomeRepositoryProvider)
                //     .updatePayment(
                //       paymentId: payment.id,
                //       actualAmount: amountController.text.trim(),
                //       paymentDate: paymentDate,
                //       notes: notesController.text.trim().isEmpty
                //           ? null
                //           : notesController.text.trim(),
                //     );
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment updated')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeletePaymentConfirmation(BuildContext context, String paymentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payment?'),
        content: const Text(
          'This will permanently delete this payment record.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // await ref.read(incomeRepositoryProvider).deletePayment(paymentId);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment deleted')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
