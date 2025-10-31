import 'package:billkeep/providers/currency_provider.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:country_flags/country_flags.dart';
import '../../database/database.dart';

class CurrencyList extends ConsumerWidget {
  final Function(Currency)? onCurrencySelected;
  final bool showActiveCurrenciesOnly;
  final bool showCryptoOnly;
  final bool showFiatOnly;
  final List<Currency> currencies;

  const CurrencyList({
    super.key,
    required this.currencies,
    this.onCurrencySelected,
    this.showActiveCurrenciesOnly = false,
    this.showCryptoOnly = false,
    this.showFiatOnly = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (currencies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.currency_exchange,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No currencies found',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: currencies.length,
      itemBuilder: (context, index) {
        final currency = currencies[index];
        return CurrencyListItem(
          currency: currency,
          onTap: () {
            onCurrencySelected!(currency);
          },
        );
      },
    );
  }
}

class CurrencyListItem extends ConsumerWidget {
  final Currency currency;
  final VoidCallback? onTap;

  const CurrencyListItem({super.key, required this.currency, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);

    return ListTile(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colors.textMute.withAlpha(50), width: .5),
        borderRadius: BorderRadius.circular(0),
      ),
      contentPadding: EdgeInsets.only(right: 10, left: 16),
      leading: _buildCurrencyAvatar(),
      title: Row(
        children: [
          Text(
            currency.name,
            style: TextStyle(fontWeight: FontWeight.w500, color: colors.text),
          ),
          const SizedBox(width: 8),
          if (currency.isCrypto)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'CRYPTO',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
              ),
            ),
          if (!currency.isActive)
            Container(
              margin: const EdgeInsets.only(left: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'INACTIVE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
        ],
      ),
      subtitle: Text(
        '${currency.code} • ${currency.symbol}',
        style: TextStyle(fontSize: 12, color: colors.textMute),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: colors.text),
      onTap: onTap,
    );
  }

  Widget _buildCurrencyAvatar() {
    // Show country flag if available, otherwise show currency symbol
    if (currency.countryISO2 != null && currency.countryISO2!.isNotEmpty) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: ClipOval(
          child: currency.isCrypto
              ? Transform.translate(
                  offset: Offset(0, -5),
                  child: Text(
                    currency.countryISO2!,
                    style: TextStyle(fontSize: 35),
                  ),
                )
              : CountryFlag.fromCountryCode(
                  currency.countryISO2!,
                  // width: 50,
                  // height: 50,
                ),
        ),
      );
    }

    // For crypto or currencies without country, show symbol in circle
    return CircleAvatar(
      backgroundColor: currency.isCrypto
          ? Colors.orange.shade100
          : Colors.blue.shade100,
      child: Text(
        // currency.symbol,
        currency.countryISO2!,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: currency.isCrypto
              ? Colors.orange.shade800
              : Colors.blue.shade800,
        ),
      ),
    );
  }
}
