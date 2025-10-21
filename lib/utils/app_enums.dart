import 'package:flutter/material.dart';

enum TransactionType { expense, income, transfer }

const transactionIcons = {
  TransactionType.expense: Icons.output_outlined,
  TransactionType.income: Icons.input,
  TransactionType.transfer: Icons.swap_horiz,
};
