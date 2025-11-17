import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/database.dart';
import '../../../providers/ui_providers.dart';
import '../../../utils/app_enums.dart';

/// Amount input field for transaction forms
class AmountInputField extends ConsumerWidget {
  final TextEditingController amountController;
  final Currency? fromCurrency;
  final Currency? toCurrency;
  final TransactionType transactionType;

  const AmountInputField({
    super.key,
    required this.amountController,
    required this.fromCurrency,
    required this.toCurrency,
    required this.transactionType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final currencySymbol = transactionType == TransactionType.income
        ? toCurrency?.symbol ?? '?'
        : fromCurrency?.symbol ?? '?';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currencySymbol,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: colors.text,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: amountController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                CurrencyInputFormatter(
                  thousandSeparator: ThousandSeparator.Comma,
                ),
              ],
              textAlign: TextAlign.end,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w600,
                color: colors.text,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: '0.00',
                hintStyle: TextStyle(
                  fontSize: 50,
                  color: colors.text,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
