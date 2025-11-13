import 'package:billkeep/providers/currency_provider.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/widgets/currencies/currency_select_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencySelectScreen extends ConsumerWidget {
  const CurrencySelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final activeColor = ref.watch(activeThemeColorProvider);
    final filteredCurrencies = ref.watch(filteredCurrenciesProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        iconTheme: IconThemeData(color: colors.text),
        actionsIconTheme: IconThemeData(color: colors.text),
        title: Text('Select Currency', style: TextStyle(color: colors.text)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
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
          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
        ],
      ),
      body: CurrencyList(
        currencies: filteredCurrencies,
        onCurrencySelected: (currency) {
          ref.read(currencySearchQueryProvider.notifier).state = '';
          Navigator.pop(context, currency);
        },
      ),
    );
  }
}
