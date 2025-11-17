import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/database.dart';
import '../../../providers/ui_providers.dart';
import '../../../screens/currencies/currency_select_screen.dart';

/// Currency and balance input section for wallet form
class CurrencyBalanceSection extends ConsumerWidget {
  final TextEditingController amountController;
  final Currency? selectedCurrency;
  final ValueChanged<Currency> onCurrencySelected;

  const CurrencyBalanceSection({
    super.key,
    required this.amountController,
    required this.selectedCurrency,
    required this.onCurrencySelected,
  });

  Future<void> _selectCurrency(BuildContext context) async {
    final result = await Navigator.of(context).push<Currency>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => CurrencySelectScreen(),
      ),
    );
    if (result != null) {
      onCurrencySelected(result);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            bottom: 0,
          ),
          child: const Text('Currency & Starting Balance'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton.icon(
                onPressed: () => _selectCurrency(context),
                label: Text(
                  selectedCurrency?.symbol ?? '₦',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: colors.text,
                  ),
                ),
                icon: const Icon(Icons.chevron_right),
                iconAlignment: IconAlignment.end,
              ),
              Expanded(
                child: TextFormField(
                  controller: amountController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9.]'),
                    ),
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
        ),
      ],
    );
  }
}
