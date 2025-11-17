import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Reusable form field tile with consistent styling
class FormFieldTile extends StatelessWidget {
  final String title;
  final String? initialValue;
  final String placeholder;
  final IconData icon;
  final double fontSize;
  final bool isFocused;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const FormFieldTile({
    super.key,
    required this.title,
    this.initialValue,
    required this.placeholder,
    required this.icon,
    this.fontSize = 20,
    this.isFocused = false,
    this.controller,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Material(
            elevation: isFocused ? 4.0 : 0.0,
            child: ListTile(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              contentPadding: const EdgeInsets.only(
                top: 0,
                left: 10,
                right: 20,
              ),
              visualDensity: const VisualDensity(vertical: 0.1),
              trailing: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Icon(
                  icon,
                  size: 24,
                  color: Colors.grey[600],
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.only(top: 0, left: 8),
                child: Text(title, textAlign: TextAlign.start),
              ),
              subtitle: CupertinoTextFormFieldRow(
                controller: controller,
                initialValue: initialValue,
                style: TextStyle(fontSize: fontSize),
                padding: const EdgeInsets.all(0),
                placeholder: placeholder,
                onChanged: onChanged,
                validator: validator,
              ),
              onTap: () {},
              minTileHeight: 10,
            ),
          ),
        ),
        const Divider(height: 1),
        const SizedBox(height: 20),
      ],
    );
  }
}
