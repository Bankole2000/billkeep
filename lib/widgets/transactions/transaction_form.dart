import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/utils/app_enums.dart';
import 'package:billkeep/widgets/common/dynamic_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class TransactionForm extends ConsumerStatefulWidget {
  const TransactionForm({super.key, required this.transactionType});

  final TransactionType transactionType;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransactionFormState();
}

class _TransactionFormState extends ConsumerState<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();

  static const Duration duration = Duration(milliseconds: 400);
  static const Curve curve = Curves.easeIn;

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = ref.watch(activeThemeColorProvider);
    final colors = ref.watch(appColorsProvider);
    return Form(
      key: _formKey,
      child: Stack(
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
                      horizontal: 30,
                      vertical: 0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '₦',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            color: colors.textMute,
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
                              CurrencyInputFormatter(
                                thousandSeparator: ThousandSeparator.Comma,
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
                  Divider(height: 1),

                  ClipRect(
                    child: AnimatedSize(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: SizedBox(
                        height:
                            widget.transactionType == TransactionType.expense
                            ? null
                            : 0,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          visualDensity: VisualDensity(vertical: 0.1),
                          leading: DynamicAvatar(icon: Icons.store),
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Merchant: ',
                                style: TextStyle(color: colors.textMute),
                              ),
                            ],
                          ),
                          onTap: () {
                            print('Select Merchant');
                          },
                          trailing: IconButton(
                            onPressed: () {
                              print('Configure Merchants');
                            },
                            icon: Icon(Icons.settings),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(height: 1),

                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    visualDensity: VisualDensity(vertical: 0.1),
                    leading: DynamicAvatar(icon: Icons.folder),

                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Project: ',
                          style: TextStyle(color: colors.textMute),
                        ),
                      ],
                    ),
                    onTap: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) => SizedBox(
                          height: 250, // Adjust height as needed
                          child: CupertinoPicker(
                            backgroundColor:
                                CupertinoColors.white, // Or any other color
                            itemExtent: 40.0, // Height of each item
                            onSelectedItemChanged: (int index) {
                              // Handle the selected item change
                              setState(() {
                                // Update state with the new selection
                              });
                            },
                            children: const <Widget>[
                              Text('Option 1'),
                              Text('Option 2'),
                              Text('Option 3'),
                              // Add more children as needed
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    visualDensity: VisualDensity(vertical: 0.1),
                    leading: DynamicAvatar(icon: Icons.folder),

                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Category: ',
                          style: TextStyle(color: colors.textMute),
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                  Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    visualDensity: VisualDensity(vertical: 0.1),
                    leading: DynamicAvatar(icon: Icons.folder),

                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'From: ',
                          style: TextStyle(color: colors.textMute),
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                  Divider(height: 1),
                  ClipRect(
                    child: AnimatedSize(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: SizedBox(
                        height:
                            widget.transactionType == TransactionType.transfer
                            ? null
                            : 0,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          visualDensity: VisualDensity(vertical: 0.1),
                          leading: DynamicAvatar(icon: Icons.folder),

                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'To: ',
                                style: TextStyle(color: colors.textMute),
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                    ),
                  ),
                  Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 30),
                    visualDensity: VisualDensity(vertical: 0.1),
                    leading: Icon(Icons.edit_sharp),
                    title: Text('Title'),
                    onTap: () {},
                  ),
                  Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 30),
                    visualDensity: VisualDensity(vertical: 0.1),
                    leading: Icon(Icons.calendar_today_outlined),
                    title: Text('Date:'),
                    onTap: () {},
                  ),
                  Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 30),
                    visualDensity: VisualDensity(vertical: 0.1),
                    leading: Icon(Icons.repeat),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Repeat: ',
                          style: TextStyle(color: colors.textMute),
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                  Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 30),
                    visualDensity: VisualDensity(vertical: 0.1),
                    leading: Icon(Icons.tag),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Tags: ',
                          style: TextStyle(color: colors.textMute),
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                  Divider(height: 1),

                  SizedBox(height: 60),
                ],
              ),
            ),
          ),

          // Floating button
          Positioned(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).padding.bottom, // Safe area
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
      ),
    );
  }
}
