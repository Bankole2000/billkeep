// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum CurrencyType { FIAT, CRYPTO, OTHER }

class CurrencyTypeInfo {
  final CurrencyType type;
  final String name;
  final IconData icon;
  final String description;
  final List<String> examples;
  final List<String> exampleNames;

  const CurrencyTypeInfo({
    required this.type,
    required this.name,
    required this.icon,
    required this.description,
    required this.examples,
    required this.exampleNames,
  });
}

class CurrencyTypes {
  static const List<CurrencyTypeInfo> all = [
    CurrencyTypeInfo(
      type: CurrencyType.FIAT,
      name: 'Fiat Currency',
      icon: Icons.money,
      description: 'Government-issued currency',
      examples: ['USD', 'EUR', 'CNY', 'NGN', 'GBP', 'JPY'],
      exampleNames: [
        'US Dollars',
        'Euros',
        'Chinese Yuan',
        'Naira',
        'GBP',
        'JPY',
      ],
    ),
    CurrencyTypeInfo(
      type: CurrencyType.CRYPTO,
      name: 'Cryptocurrency',
      icon: Icons.currency_bitcoin,
      description: 'Digital or virtual currency',
      examples: ['BTC', 'ETH', 'USDT'],
      exampleNames: ['BitCoin', 'Etherium', 'USDT'],
    ),
    CurrencyTypeInfo(
      type: CurrencyType.OTHER,
      name: 'Other',
      icon: Icons.more_horiz,
      description: 'Custom or miscellaneous currency',
      examples: ['VBK', 'G', 'M'],
      exampleNames: ['VBucks', 'Gil', 'Mora'],
    ),
  ];

  static CurrencyTypeInfo getInfo(CurrencyType currencyType) {
    return all.firstWhere((info) => info.type == currencyType);
  }

  static CurrencyType stringToEnum(String currencyType) {
    switch (currencyType) {
      case 'FIAT':
        return CurrencyType.FIAT;
      case 'CRYPTO':
        return CurrencyType.CRYPTO;
      case 'OTHER':
        return CurrencyType.OTHER;
      default:
        throw ArgumentError('Invalid currency type string: $currencyType');
    }
  }
}

enum WalletType {
  CASH,
  BANK_ACCOUNT,
  MOBILE_MONEY,
  CREDIT_CARD,
  DIGITAL_WALLET,
  CRYPTO_WALLET,
  OTHER,
}

class WalletTypeInfo {
  final WalletType type;
  final String name;
  final IconData icon;
  final String description;
  final List<String> examples;

  const WalletTypeInfo({
    required this.type,
    required this.name,
    required this.icon,
    required this.description,
    required this.examples,
  });
}

// Wallet type configurations
class WalletTypes {
  static const List<WalletTypeInfo> all = [
    WalletTypeInfo(
      type: WalletType.CASH,
      name: 'Cash',
      icon: Icons.payments,
      description: 'Physical money in hand',
      examples: ['Naira notes', 'Dollar bills', 'Petty cash', 'Wallet cash'],
    ),
    WalletTypeInfo(
      type: WalletType.BANK_ACCOUNT,
      name: 'Bank Account',
      icon: Icons.account_balance,
      description: 'Traditional checking or savings account',
      examples: ['GTBank', 'Access Bank', 'First Bank', 'UBA', 'Zenith Bank'],
    ),
    WalletTypeInfo(
      type: WalletType.MOBILE_MONEY,
      name: 'Mobile Money',
      icon: Icons.phone_android,
      description: 'Telecom-based mobile wallet account',
      examples: ['OPay', 'PalmPay', 'Kuda', 'MTN MoMo', 'Airtel Money'],
    ),
    WalletTypeInfo(
      type: WalletType.CREDIT_CARD,
      name: 'Credit Card',
      icon: Icons.credit_card,
      description: 'Credit line for purchases',
      examples: ['Visa', 'Mastercard', 'Verve', 'American Express'],
    ),
    WalletTypeInfo(
      type: WalletType.DIGITAL_WALLET,
      name: 'Digital Wallet',
      icon: Icons.account_balance_wallet,
      description: 'Online payment service account',
      examples: ['PayPal', 'Payoneer', 'Skrill', 'Google Pay', 'Apple Pay'],
    ),
    WalletTypeInfo(
      type: WalletType.CRYPTO_WALLET,
      name: 'Crypto Wallet',
      icon: Icons.currency_bitcoin,
      description: 'Cryptocurrency and digital assets',
      examples: ['Bitcoin', 'Ethereum', 'USDT', 'Binance', 'Trust Wallet'],
    ),
    WalletTypeInfo(
      type: WalletType.OTHER,
      name: 'Other',
      icon: Icons.more_horiz,
      description: 'Custom or miscellaneous wallet',
      examples: ['Gift cards', 'Store credit', 'Vouchers', 'Custom wallet'],
    ),
  ];

  // Helper method to get info by type
  static WalletTypeInfo getInfo(WalletType walletType) {
    return all.firstWhere((info) => info.type == walletType);
  }

  static WalletType stringToEnum(String walletType) {
    switch (walletType) {
      case 'CASH':
        return WalletType.CASH;
      case 'BANK_ACCOUNT':
        return WalletType.BANK_ACCOUNT;
      case 'MOBILE_MONEY':
        return WalletType.MOBILE_MONEY;
      case 'CREDIT_CARD':
        return WalletType.CREDIT_CARD;
      case 'DIGITAL_WALLET':
        return WalletType.DIGITAL_WALLET;
      case 'CRYPTO_WALLET':
        return WalletType.CRYPTO_WALLET;
      case 'OTHER':
        return WalletType.OTHER;
      default:
        throw ArgumentError('Invalid wallet type string: $walletType');
    }
  }
}
