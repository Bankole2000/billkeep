import 'package:flutter/material.dart';

/// A widget for picking Material icons
/// Designed for use in modals/bottom sheets (not full screen)
class IconPickerWidget extends StatefulWidget {
  final IconData? preSelectedIcon;
  final Function(IconData?) onIconSelected;
  final bool showSearchBar;
  final double iconSize;
  final Color? iconColor;
  final Color? backgroundColor;
  final List<IconData>? availableIcons;

  const IconPickerWidget({
    super.key,
    this.preSelectedIcon,
    required this.onIconSelected,
    this.showSearchBar = true,
    this.iconSize = 30.0,
    this.iconColor,
    this.backgroundColor,
    this.availableIcons,
  });

  @override
  State<IconPickerWidget> createState() => _IconPickerWidgetState();
}

class _IconPickerWidgetState extends State<IconPickerWidget> {
  IconData? _selectedIcon;
  String _searchQuery = '';
  late Map<String, IconData> _iconMap;

  // Commonly used Material icons with names
  static const Map<String, IconData> _defaultIconMap = {
    'home': Icons.home,
    'person': Icons.person,
    'settings': Icons.settings,
    'favorite': Icons.favorite,
    'star': Icons.star,
    'shopping cart': Icons.shopping_cart,
    'search': Icons.search,
    'notifications': Icons.notifications,
    'email': Icons.email,
    'phone': Icons.phone,
    'camera': Icons.camera,
    'photo': Icons.photo,
    'music note': Icons.music_note,
    'movie': Icons.movie,
    'calendar': Icons.calendar_today,
    'alarm': Icons.alarm,
    'work': Icons.work,
    'school': Icons.school,
    'restaurant': Icons.restaurant,
    'cafe': Icons.local_cafe,
    'bar': Icons.local_bar,
    'fastfood': Icons.fastfood,
    'grocery': Icons.local_grocery_store,
    'hospital': Icons.local_hospital,
    'pharmacy': Icons.local_pharmacy,
    'gas station': Icons.local_gas_station,
    'car': Icons.directions_car,
    'bike': Icons.directions_bike,
    'bus': Icons.directions_bus,
    'flight': Icons.flight,
    'hotel': Icons.hotel,
    'beach': Icons.beach_access,
    'fitness': Icons.fitness_center,
    'soccer': Icons.sports_soccer,
    'basketball': Icons.sports_basketball,
    'gamepad': Icons.gamepad,
    'pets': Icons.pets,
    'child care': Icons.child_care,
    'payment': Icons.payment,
    'bank': Icons.account_balance,
    'credit card': Icons.credit_card,
    'money': Icons.attach_money,
    'trending up': Icons.trending_up,
    'trending down': Icons.trending_down,
    'pie chart': Icons.pie_chart,
    'bar chart': Icons.bar_chart,
    'business': Icons.business,
    'store': Icons.store,
    'apartment': Icons.apartment,
    'mall': Icons.local_mall,
    'shopping bag': Icons.shopping_bag,
    'gift': Icons.card_giftcard,
    'celebration': Icons.celebration,
    'cake': Icons.cake,
    'light': Icons.light_mode,
    'dark': Icons.dark_mode,
    'sunny': Icons.wb_sunny,
    'nightlight': Icons.nightlight,
    'umbrella': Icons.umbrella,
    'palette': Icons.palette,
    'brush': Icons.brush,
    'edit': Icons.edit,
    'delete': Icons.delete,
    'add': Icons.add,
    'remove': Icons.remove,
    'check': Icons.check,
    'close': Icons.close,
    'refresh': Icons.refresh,
    'download': Icons.download,
    'upload': Icons.upload,
    'share': Icons.share,
    'folder': Icons.folder,
    'description': Icons.description,
    'dashboard': Icons.dashboard,
    'analytics': Icons.analytics,
    'receipt': Icons.receipt,
    'wallet': Icons.account_balance_wallet,
    'savings': Icons.savings,
    'quote': Icons.request_quote,
    'sale': Icons.point_of_sale,
    'euro': Icons.euro,
    'pound': Icons.currency_pound,
    'yen': Icons.currency_yen,
    'atm': Icons.local_atm,
    'volunteer': Icons.volunteer_activism,
    'handshake': Icons.handshake,
    'percent': Icons.percent,
    'discount': Icons.discount,
    'sell': Icons.sell,
    'category': Icons.category,
    'label': Icons.label,
    'bookmark': Icons.bookmark,
    'flag': Icons.flag,
    'pin': Icons.push_pin,
  };

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.preSelectedIcon;

    // Convert availableIcons to a map if provided, otherwise use default
    if (widget.availableIcons != null) {
      _iconMap = {
        for (var i = 0; i < widget.availableIcons!.length; i++)
          'icon_$i': widget.availableIcons![i]
      };
    } else {
      _iconMap = _defaultIconMap;
    }
  }

  List<IconData> get _filteredIcons {
    if (_searchQuery.isEmpty) {
      return _iconMap.values.toList();
    }

    // Filter icons by name containing the search query
    return _iconMap.entries
        .where((entry) => entry.key.toLowerCase().contains(_searchQuery))
        .map((entry) => entry.value)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          if (widget.showSearchBar)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search icons...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: _filteredIcons.length,
              itemBuilder: (context, index) {
                final icon = _filteredIcons[index];
                final isSelected = _selectedIcon == icon;

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIcon = icon;
                      });
                      widget.onIconSelected(icon);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected
                            ? (widget.backgroundColor ?? Colors.blue.shade50)
                            : Colors.grey.shade100,
                        border: Border.all(
                          color: isSelected
                              ? (widget.iconColor ?? Colors.blue)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        icon,
                        size: widget.iconSize,
                        color: isSelected
                            ? (widget.iconColor ?? Colors.blue)
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
