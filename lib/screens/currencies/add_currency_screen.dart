import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/utils/app_enums.dart';
import 'package:billkeep/utils/wallet_types.dart';
import 'package:billkeep/widgets/currencies/select_currency_type_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddCurrencyScreen extends ConsumerStatefulWidget {
  const AddCurrencyScreen({super.key, this.currency});

  final Currency? currency;

  @override
  ConsumerState<AddCurrencyScreen> createState() => _AddCurrencyScreenState();
}

class _AddCurrencyScreenState extends ConsumerState<AddCurrencyScreen> {
  CurrencyType? _selectedCurrencyType;
  final IconSelectionType _selectedSegment = IconSelectionType.emoji;
  String? currencyId;
  final _formKey = GlobalKey<FormState>();
  double _decimals = 2.0;
  final bool _isFocused = false;
  var enteredName = '';
  var enteredDescription = '';
  var enteredWebsite = '';
  var imageUrl = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final activeColor = ref.watch(activeThemeColorProvider);
    return Scaffold(
      // backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: activeColor,
        iconTheme: IconThemeData(color: colors.textInverse),
        actionsIconTheme: IconThemeData(color: colors.textInverse),
        title: Text(
          '${currencyId == null ? 'New' : 'Edit'} Currency',
          style: TextStyle(color: colors.textInverse),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
            child: SizedBox(
              width: double.infinity,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: CurrencyTypeDropdown(
                  selectedType: _selectedCurrencyType,
                  onChanged: (CurrencyType? value) {
                    setState(() {
                      _selectedCurrencyType = value;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SizedBox(
          height: MediaQuery.of(context).size.height - ((100 as num)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  child: Material(
                    // elevation: 5,
                    elevation: _isFocused ? 4.0 : 0.0,
                    child: ListTile(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      contentPadding: EdgeInsets.only(
                        top: 0,
                        left: 10,
                        right: 20,
                      ),
                      visualDensity: VisualDensity(vertical: 0.1),
                      trailing: Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Icon(
                          Icons.edit_sharp,
                          size: 30,
                          color: colors.textMute,
                        ),
                      ),
                      title: Padding(
                        padding: EdgeInsetsGeometry.only(top: 0, left: 10),
                        child: Text(
                          'Currency Code',
                          textAlign: TextAlign.start,
                        ),
                      ),
                      subtitle: CupertinoTextFormFieldRow(
                        // focusNode: _focusNode,
                        initialValue: enteredName,
                        style: TextStyle(fontSize: 36),
                        padding: EdgeInsets.all(0),
                        placeholder: _selectedCurrencyType != null
                            ? 'e.g. ${CurrencyTypes.getInfo(_selectedCurrencyType!).examples.join(', ')}'
                            : 'Required',
                      ),
                      onTap: () {},
                      minTileHeight: 10,
                    ),
                  ),
                ),
                Divider(height: 1),
                SizedBox(height: 20),

                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  child: Material(
                    // elevation: 5,
                    elevation: _isFocused ? 4.0 : 0.0,
                    child: ListTile(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      contentPadding: EdgeInsets.only(
                        top: 0,
                        left: 10,
                        right: 20,
                      ),
                      visualDensity: VisualDensity(vertical: 0.1),
                      trailing: Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Icon(
                          Icons.edit_note,
                          size: 24,
                          color: colors.textMute,
                        ),
                      ),
                      title: Padding(
                        padding: EdgeInsetsGeometry.only(top: 0, left: 8),
                        child: Text(
                          'Currency Name',
                          textAlign: TextAlign.start,
                        ),
                      ),
                      subtitle: CupertinoTextFormFieldRow(
                        // focusNode: _focusNode,
                        initialValue: enteredDescription,
                        style: TextStyle(fontSize: 20),
                        padding: EdgeInsets.all(0),
                        placeholder: _selectedCurrencyType != null
                            ? 'e.g. ${CurrencyTypes.getInfo(_selectedCurrencyType!).exampleNames.join(', ')}'
                            : 'Required',
                      ),
                      onTap: () {},
                      minTileHeight: 10,
                    ),
                  ),
                ),
                Divider(height: 1),
                SizedBox(height: 20),

                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  child: Material(
                    // elevation: 5,
                    elevation: _isFocused ? 4.0 : 0.0,
                    child: ListTile(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      contentPadding: EdgeInsets.only(
                        top: 0,
                        left: 10,
                        right: 20,
                      ),
                      visualDensity: VisualDensity(vertical: 0.1),
                      trailing: Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Icon(
                          Icons.link,
                          size: 24,
                          color: colors.textMute,
                        ),
                      ),
                      title: Padding(
                        padding: EdgeInsetsGeometry.only(top: 0, left: 8),
                        child: Text('Symbol', textAlign: TextAlign.start),
                      ),
                      subtitle: CupertinoTextFormFieldRow(
                        // focusNode: _focusNode,
                        initialValue: enteredWebsite,
                        style: TextStyle(fontSize: 20),
                        padding: EdgeInsets.all(0),
                        placeholder: 'Optional',
                      ),
                      onTap: () {},
                      minTileHeight: 10,
                    ),
                  ),
                ),
                Divider(height: 1),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('2', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        'Decimals',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                      Text('8', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Slider(
                  value: _decimals,
                  min: 2,
                  max: 8,
                  divisions: 6, // Creates 7 positions (2,3,4,5,6,7,8)
                  label: _decimals.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _decimals = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: activeColor,
              foregroundColor: colors.textInverse,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              'SAVE',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
