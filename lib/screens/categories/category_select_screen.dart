import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/category_provider.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/utils/app_colors.dart';
import 'package:billkeep/utils/app_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionCategorySelectScreen extends ConsumerStatefulWidget {
  const TransactionCategorySelectScreen({super.key});

  @override
  ConsumerState<TransactionCategorySelectScreen> createState() =>
      _TransactionCategorySelectScreenState();
}

class _TransactionCategorySelectScreenState
    extends ConsumerState<TransactionCategorySelectScreen> {
  late TextEditingController searchTextController;

  @override
  void initState() {
    super.initState();
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

    final groupedAsync = ref.watch(groupedCategoriesProvider);
    final viewMode = ref.watch(categoryViewModeProvider);
    final expandedGroups = ref.watch(expandedGroupsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: activeColor,
        iconTheme: IconThemeData(color: colors.textInverse),
        actionsIconTheme: IconThemeData(color: colors.textInverse),
        title: Text(
          'Select Category',
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
                ref.read(categorySearchQueryProvider.notifier).state = value;
                // handle search
              },
            ),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Toggle view',
            icon: Icon(
              viewMode == ViewModeOptions.grid
                  ? Icons.view_list
                  : Icons.grid_view,
            ),
            onPressed: () {
              final notifier = ref.read(categoryViewModeProvider.notifier);
              notifier.state = viewMode == ViewModeOptions.grid
                  ? ViewModeOptions.list
                  : ViewModeOptions.grid;
            },
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
        ],
      ),
      body: groupedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (groups) {
          if (groups.isEmpty) {
            return const Center(child: Text('No categories found.'));
          }

          if (expandedGroups.isEmpty && groups.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final ids = groups.map((g) => g.group.id);
              ref.read(expandedGroupsProvider.notifier).expandAll(ids);
            });
          }

          return SingleChildScrollView(
            child: ExpansionPanelList(
              expandedHeaderPadding: EdgeInsets.zero,
              animationDuration: const Duration(milliseconds: 200),
              expansionCallback: (index, isExpanded) {
                final id = groups[index].group.id;
                ref.read(expandedGroupsProvider.notifier).toggle(id);
              },
              children: groups.map((groupData) {
                final group = groupData.group;
                final cats = groupData.categories;

                final isExpanded = expandedGroups.contains(group.id);

                return ExpansionPanel(
                  canTapOnHeader: true,
                  isExpanded: isExpanded,
                  headerBuilder: (context, isExpanded) => ListTile(
                    title: Text(
                      group.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: viewMode == ViewModeOptions.grid
                        ? _buildGridView(cats)
                        : _buildListView(cats),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridView(List<Category> cats) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
      ),
      itemBuilder: (context, index) {
        final cat = cats[index];
        return GestureDetector(
          onTap: () {
            ref.read(categorySearchQueryProvider.notifier).state = '';
            Navigator.pop(context, cat);
          },
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (cat.iconEmoji != null)
                  CircleAvatar(
                    backgroundColor: HexColor.fromHex(cat.color!),
                    child: Text(
                      cat.iconEmoji!,
                      style: const TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                // Text(cat.iconEmoji!, style: const TextStyle(fontSize: 24)),
                SizedBox(height: 4),
                Text(
                  cat.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView(List<Category> cats) {
    return Column(
      children: cats.map((cat) {
        return ListTile(
          leading: cat.iconEmoji != null
              ? Text(cat.iconEmoji!, style: const TextStyle(fontSize: 20))
              : const Icon(Icons.category),
          title: Text(cat.name),
          onTap: () {
            ref.read(categorySearchQueryProvider.notifier).state = '';
            Navigator.pop(context, cat);
          },
        );
      }).toList(),
    );
  }
}
