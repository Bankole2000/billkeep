import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:country_flags/country_flags.dart';
import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/auth_provider.dart';
import 'package:billkeep/providers/currency_provider.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/screens/currencies/add_currency_screen.dart';
import 'package:billkeep/widgets/currencies/currency_select_list.dart';

/// Currency selection step in onboarding
class CurrencyStep extends ConsumerWidget {
  final Currency? selectedCurrency;
  final ValueChanged<Currency> onCurrencySelected;

  const CurrencyStep({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencySelected,
  });

  Future<void> _selectCustomCurrency(BuildContext context, WidgetRef ref) async {
    final user = ref.watch(currentUserProvider);
    print(user);
    final userId = ref.read(currentUserIdProvider);

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add currencies')),
      );
      return;
    }

    final result = await Navigator.of(context).push(
      CupertinoModalPopupRoute(
        builder: (context) => AddCurrencyScreen(userId: userId),
      ),
    );
    if (result != null && result is Currency) {
      onCurrencySelected(result);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final filteredCurrencies = ref.watch(filteredCurrenciesProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        iconTheme: IconThemeData(color: colors.text),
        actionsIconTheme: IconThemeData(color: colors.text),
        title: Text('Select Currency', style: TextStyle(color: colors.text)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
            child: CupertinoSearchTextField(
              backgroundColor: const Color(0xFFE0E0E0),
              placeholder: 'Search by name, code, or symbol',
              placeholderStyle: const TextStyle(
                color: Color(0xFF9E9E9E),
                fontSize: 20,
              ),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: const Icon(
                CupertinoIcons.search,
                color: Colors.blueAccent,
              ),
              suffixIcon: const Icon(
                CupertinoIcons.xmark_circle_fill,
                color: Colors.redAccent,
              ),
              onChanged: (value) {
                ref.read(currencySearchQueryProvider.notifier).state = value;
              },
            ),
          ),
        ),
        actions: [
          if (selectedCurrency != null)
            Text(selectedCurrency!.code, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          if (selectedCurrency != null) _buildCurrencyFlag(selectedCurrency!),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () => _selectCustomCurrency(context, ref),
            icon: const Icon(Icons.add),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: CurrencyList(
        selectedCurrency: selectedCurrency,
        currencies: filteredCurrencies,
        onCurrencySelected: (currency) {
          ref.read(currencySearchQueryProvider.notifier).state = '';
          onCurrencySelected(currency);
        },
      ),
    );
  }

  Widget _buildCurrencyFlag(Currency currency) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: ClipOval(
        child: currency.isCrypto
            ? Transform.translate(
                offset: Platform.isIOS
                    ? const Offset(4, -1)
                    : const Offset(-1, -3),
                child: Text(
                  currency.countryISO2!,
                  style: const TextStyle(fontSize: 25),
                ),
              )
            : CountryFlag.fromCountryCode(currency.countryISO2!),
      ),
    );
  }
}
