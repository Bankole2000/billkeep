import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/utils/app_enums.dart';
import 'package:billkeep/widgets/common/dynamic_avatar.dart';
import 'package:billkeep/widgets/common/sliding_segment_control_label.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
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
  late TextEditingController searchTextController;
  IconSelectionType _selectedSegment = IconSelectionType.emoji;
  String? merchantId;
  final _formKey = GlobalKey<FormState>();
  bool _isFocused = false;
  var enteredName = '';
  var enteredDescription = '';
  var enteredWebsite = '';
  var imageUrl = '';

  @override
  void initState() {
    super.initState();
    // if (widget.merchant != null) {
    //   merchantId = widget.merchant?.id;
    //   setState(() {
    //     enteredName = widget.merchant!.name;
    //     enteredDescription = widget.merchant!.description ?? '';
    //     enteredWebsite = widget.merchant!.website ?? '';
    //     imageUrl = widget.merchant!.imageUrl ?? '';
    //     if (imageUrl.isNotEmpty) _selectedSegment = IconSelectionType.image;
    //   });
    // }
    searchTextController = TextEditingController();
  }

  @override
  void dispose() {
    searchTextController.dispose();
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
          '${merchantId == null ? 'New' : 'Edit'} Merchant',
          style: TextStyle(color: colors.textInverse),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
            child: CupertinoSearchTextField(
              backgroundColor: const Color(0xFFE0E0E0),
              controller: searchTextController,
              placeholder: 'Search',
              placeholderStyle: const TextStyle(
                color: Color(0xFF9E9E9E), // 🔹 Placeholder color
                fontSize: 20,
              ),
              style: const TextStyle(
                color: Colors.black, // 🔹 Input text color
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: const Icon(
                CupertinoIcons.search,
                color: Colors.blueAccent, // 🔹 Icon color
              ),
              suffixIcon: const Icon(
                CupertinoIcons.xmark_circle_fill,
                color: Colors.redAccent, // 🔹 Clear button color
              ),
              onChanged: (value) {
                // handle search
              },
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
                          'Merchant Name',
                          textAlign: TextAlign.start,
                        ),
                      ),
                      subtitle: CupertinoTextFormFieldRow(
                        // focusNode: _focusNode,
                        initialValue: enteredName,
                        style: TextStyle(fontSize: 36),
                        padding: EdgeInsets.all(0),
                        placeholder: 'Required',
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
                        child: Text('Description', textAlign: TextAlign.start),
                      ),
                      subtitle: CupertinoTextFormFieldRow(
                        // focusNode: _focusNode,
                        initialValue: enteredDescription,
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
                        child: Text('Website Url', textAlign: TextAlign.start),
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
                        bottom: 0,
                      ),
                      visualDensity: VisualDensity(vertical: 0.1),
                      title: Padding(
                        padding: EdgeInsetsGeometry.only(
                          top: 0,
                          left: 8,
                          bottom: 10,
                        ),
                        child: Text('Appearance', textAlign: TextAlign.start),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        // children: [],
                        children: [
                          DynamicAvatar(
                            icon: imageUrl.isEmpty ? Icons.shop : null,
                            size: 50,
                            image: imageUrl.isEmpty
                                ? null
                                : NetworkImage(imageUrl),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CustomSlidingSegmentedControl<IconSelectionType>(
                              // isStretch: true,
                              initialValue: _selectedSegment,
                              children: {
                                IconSelectionType
                                    .icon: SlidingSegmentControlLabel(
                                  isActive:
                                      _selectedSegment ==
                                      IconSelectionType.icon,
                                  label: 'Icon',
                                  icon:
                                      iconSelectionTypeIcons[IconSelectionType
                                          .icon]!,
                                  activeColor: colors.fire,
                                ),
                                IconSelectionType
                                    .emoji: SlidingSegmentControlLabel(
                                  icon:
                                      iconSelectionTypeIcons[IconSelectionType
                                          .emoji]!,
                                  label: 'Emoji',
                                  isActive:
                                      _selectedSegment ==
                                      IconSelectionType.emoji,
                                  activeColor: colors.wave,
                                ),
                                IconSelectionType
                                    .image: SlidingSegmentControlLabel(
                                  icon:
                                      iconSelectionTypeIcons[IconSelectionType
                                          .image]!,
                                  label: 'Image',
                                  isActive:
                                      _selectedSegment ==
                                      IconSelectionType.image,
                                  activeColor: colors.water,
                                ),
                              },
                              onValueChanged: (value) {
                                setState(() {
                                  _selectedSegment = value;
                                });
                              },
                              innerPadding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              thumbDecoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.invert_colors,
                              size: 36,
                              color: colors.textMute,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {},
                      // minTileHeight: 10,
                    ),
                  ),
                ),

                ClipRect(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: SizedBox(
                      height: _selectedSegment == IconSelectionType.image
                          ? null
                          : 0,
                      child: ListTile(
                        contentPadding: EdgeInsets.only(top: 0, left: 20),

                        title: CupertinoTextFormFieldRow(
                          initialValue: imageUrl,
                          padding: EdgeInsets.all(0),
                          prefix: Text(
                            'ImageUrl: ',
                            style: TextStyle(color: colors.textMute),
                          ),

                          // placeholder: 'Title',
                        ),
                        subtitle: Padding(
                          padding: EdgeInsetsGeometry.only(top: 8, bottom: 16),
                          child: Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {},
                                label: Text('Select Image'),
                                icon: Icon(Icons.image),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: activeColor,
                                  foregroundColor: colors.textInverse,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: () {},
                                label: Text('Take Photo'),
                                icon: Icon(Icons.camera_alt),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: activeColor,
                                  foregroundColor: colors.textInverse,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(height: 1),
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
