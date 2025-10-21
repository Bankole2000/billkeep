import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/utils/app_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionForm extends ConsumerStatefulWidget {
  const TransactionForm({super.key, required this.transactionType});

  final TransactionType transactionType;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransactionFormState();
}

class _TransactionFormState extends ConsumerState<TransactionForm> {
  @override
  Widget build(BuildContext context) {
    final activeColor = ref.watch(activeThemeColorProvider);
    final colors = ref.watch(appColorsProvider);
    return Stack(
      children: [
        // Scrollable content
        SizedBox(
          height:
              MediaQuery.of(context).size.height -
              ((Scaffold.of(context).appBarMaxHeight as num) + (100 as num)),
          child: SingleChildScrollView(
            // padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '₦',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      // const Spacer(),
                      Expanded(
                        child: TextFormField(
                          // textDirection: TextDirection.rtl,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                          ],
                          textAlign: TextAlign.end,
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: const TextStyle(
                            fontSize: 50, // large font size
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            // prefixText: '₦', // or '$', '€', etc.
                            // prefixStyle: const TextStyle(
                            //   fontSize: 50,
                            //   fontWeight: FontWeight.w600,
                            //   color: Colors.black,
                            // ),
                            border:
                                InputBorder.none, // removes underline/borders
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: '0.00',
                            hintStyle: const TextStyle(
                              fontSize: 50,
                              color: Colors.grey,
                            ),
                            contentPadding:
                                EdgeInsets.zero, // keeps alignment tight
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ...List.generate(
                  1,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: 80,
                    color: Colors.grey[800],
                    alignment: Alignment.center,
                    child: Text(
                      'Item $index',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Floating button
        Positioned(
          left: 20,
          right: 20,
          bottom: 16 + MediaQuery.of(context).padding.bottom, // Safe area
          child: SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6), // Adjust this valu
                ),
                backgroundColor: activeColor,
              ),
              label: Text(
                'Save',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: colors.textInverse,
                ),
              ),
              icon: Icon(Icons.add, size: 24, color: colors.textInverse),
            ),
          ),
        ),
      ],
    );
  }
}
