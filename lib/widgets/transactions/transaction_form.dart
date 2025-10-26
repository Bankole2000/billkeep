import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/project_provider.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/screens/categories/category_select_screen.dart';
import 'package:billkeep/screens/merchants/add_merchant_screen.dart';
import 'package:billkeep/screens/merchants/merchant_select_screen.dart';
import 'package:billkeep/screens/projects/add_project_screen.dart';
import 'package:billkeep/utils/app_enums.dart';
import 'package:billkeep/utils/page_transitions.dart';
import 'package:billkeep/widgets/common/dynamic_avatar.dart';
import 'package:billkeep/widgets/projects/project_form.dart';
import 'package:billkeep/widgets/projects/project_list_select.dart';
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

enum SingingCharacter { lafayette, jefferson }

class _TransactionFormState extends ConsumerState<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final _titleController = TextEditingController();
  Project? _selectedProject;

  // bool _createInitialPayment = true;

  // static const Duration duration = Duration(milliseconds: 400);
  // static const Curve curve = Curves.easeIn;

  @override
  void initState() {
    // TODO: implement initState
    // _selectedProject = ref.watch(activeProjectProvider).project?.id;
    super.initState();

    // Delay access to ref until after widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final activeProject = ref.read(activeProjectProvider);

      setState(() {
        _selectedProject = activeProject.project;
      });
    });
  }

  void selectProject(Project project) {
    print('selected project');
    print(project.name);
    setState(() {
      _selectedProject = project;
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  SingingCharacter? _character = SingingCharacter.lafayette;

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider);
    final activeProject = ref.watch(activeProjectProvider);
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
                  // Amount Input
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

                  // Merchant Select
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
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                fullscreenDialog: true,
                                builder: (context) =>
                                    TransactionMerchantSelectScreen(),
                              ),
                            );
                          },
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => AddMerchantScreen(),
                                ),
                              );
                            },
                            icon: Icon(Icons.add),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Divider(height: 1),

                  // Project Select
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
                        Text(
                          _selectedProject == null
                              ? 'No Project Selected'
                              : _selectedProject!.name,
                        ),
                      ],
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) => Container(
                          height: 400, // Adjust height as needed
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemBackground.resolveFrom(
                              context,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: CupertinoColors.systemGrey5,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // SizedBox(width: 24),
                                    Padding(
                                      padding: EdgeInsetsGeometry.only(
                                        left: 10,
                                      ),
                                      child: CupertinoButton(
                                        borderRadius: BorderRadius.circular(25),
                                        onPressed: () => Navigator.pop(context),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        minimumSize: Size(20, 20),
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: CupertinoColors.systemGrey5,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            CupertinoIcons.clear,
                                            color: CupertinoColors.label,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Select Project',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsGeometry.only(
                                        right: 10,
                                      ),
                                      child: CupertinoButton(
                                        borderRadius: BorderRadius.circular(25),
                                        onPressed: () => {
                                          Navigator.push(
                                            context,
                                            AppPageRoute.slideRight(
                                              AddProjectScreen(),
                                            ),
                                          ),
                                        },
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        minimumSize: Size(20, 20),
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: CupertinoColors.systemGrey5,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            CupertinoIcons.add,
                                            color: CupertinoColors.label,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Positioned(
                                left: 20,
                                right: 20,
                                bottom:
                                    20 + MediaQuery.of(context).padding.bottom,
                                // top: 50,
                                child: ClipRRect(
                                  child: SizedBox(
                                    height: 320,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // SizedBox(height: 40),
                                          ...projects.when(
                                            data: (ps) {
                                              if (ps.isEmpty) {
                                                return const [
                                                  Center(
                                                    child: Text(
                                                      'No projects yet. Tap + to create one.',
                                                    ),
                                                  ),
                                                ];
                                              }
                                              return ps
                                                  .expand(
                                                    (p) => [
                                                      ProjectListSelectItem(
                                                        isSelected:
                                                            _selectedProject
                                                                ?.id ==
                                                            p.id,
                                                        project: p,
                                                        onSelectProject: () {
                                                          selectProject(p);
                                                          Navigator.of(
                                                            context,
                                                          ).pop();
                                                        },
                                                      ),
                                                      Divider(),
                                                    ],
                                                  )
                                                  .toList();
                                            },
                                            error: (error, stack) => [
                                              Text('Error loading Projects'),
                                            ],
                                            loading: () => [
                                              Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  Divider(height: 1),

                  // Category Select
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
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) =>
                              TransactionCategorySelectScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1),

                  // Wallet Select (From)
                  ClipRect(
                    child: AnimatedSize(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: SizedBox(
                        height:
                            widget.transactionType == TransactionType.expense ||
                                widget.transactionType ==
                                    TransactionType.transfer
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
                                'From: ',
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

                  // Wallet Select (To)
                  ClipRect(
                    child: AnimatedSize(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: SizedBox(
                        height:
                            widget.transactionType == TransactionType.income ||
                                widget.transactionType ==
                                    TransactionType.transfer
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

                  // Title Input Field
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 30),
                    visualDensity: VisualDensity(vertical: 0.1),
                    leading: Icon(Icons.edit_sharp),
                    title: CupertinoTextFormFieldRow(
                      padding: EdgeInsets.all(0),
                      prefix: Text(
                        'Title',
                        style: TextStyle(color: colors.textMute),
                      ),
                      // placeholder: 'Title',
                    ),
                    onTap: () {},
                  ),
                  Divider(height: 1),

                  // Date Select Input
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 30),
                    visualDensity: VisualDensity(vertical: 0.1),
                    leading: Icon(Icons.calendar_today_outlined),
                    title: Text('Date:'),
                    onTap: () {},
                  ),
                  Divider(height: 1),

                  // Repeat select
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

                  // Tags Input Select
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
