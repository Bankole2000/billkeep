// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum PreferenceKey { DEFAULT_CURRENCY, LOGGED_IN_USER }

class PreferenceKeyInfo {
  final PreferenceKey key;
  final String displayName;
  final IconData icon;
  final String description;

  const PreferenceKeyInfo({
    required this.key,
    required this.displayName,
    required this.icon,
    required this.description,
  });
}

extension PreferenceKeyExtension on PreferenceKey {
  String toStringValue() {
    return info.key.toString();
  }

  String get description {
    return info.description;
  }

  IconData get icon {
    return info.icon;
  }

  String get displayName {
    return info.displayName;
  }

  PreferenceKeyInfo get info {
    return PreferenceKeys.getInfo(this);
  }
}

class PreferenceKeys {
  static const List<PreferenceKeyInfo> all = [
    PreferenceKeyInfo(
      key: PreferenceKey.DEFAULT_CURRENCY,
      displayName: 'Default Currency',
      icon: Icons.attach_money,
      description: 'Set your default currency for wallets and transactions',
    ),
  ];

  static PreferenceKeyInfo getInfo(PreferenceKey preferenceKey) {
    return all.firstWhere((info) => info.key == preferenceKey);
  }

  static PreferenceKey stringToEnum(String keyString) {
    switch (keyString) {
      case 'DEFAULT_CURRENCY':
        return PreferenceKey.DEFAULT_CURRENCY;
      default:
        throw ArgumentError('Invalid PreferenceKey string: $keyString');
    }
  }
}