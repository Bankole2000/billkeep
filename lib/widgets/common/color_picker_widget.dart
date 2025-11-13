import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

/// A widget for picking colors
/// Designed for use in modals/bottom sheets (not full screen)
class ColorPickerWidget extends StatelessWidget {
  final Color currentColor;
  final Function(Color) onColorChanged;
  final bool enableAlpha;
  final bool showHexInput;
  final bool displayThumbColor;
  final PaletteType paletteType;
  final List<ColorLabelType> labelTypes;
  final double pickerWidth;

  const ColorPickerWidget({
    super.key,
    required this.currentColor,
    required this.onColorChanged,
    this.enableAlpha = true,
    this.showHexInput = false,
    this.displayThumbColor = true,
    this.paletteType = PaletteType.hsvWithHue,
    this.labelTypes = const [ColorLabelType.rgb, ColorLabelType.hsv],
    this.pickerWidth = 300.0,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ColorPicker(
        pickerColor: currentColor,
        onColorChanged: onColorChanged,
        enableAlpha: enableAlpha,
        displayThumbColor: displayThumbColor,
        paletteType: paletteType,
        labelTypes: labelTypes,
        hexInputBar: showHexInput,
        colorPickerWidth: pickerWidth,
        pickerAreaHeightPercent: 0.7,
        pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
    );
  }
}

/// Simple block-based color picker for common colors
class SimpleColorPickerWidget extends StatelessWidget {
  final Color currentColor;
  final Function(Color) onColorChanged;
  final List<Color>? availableColors;
  final double itemSize;

  const SimpleColorPickerWidget({
    super.key,
    required this.currentColor,
    required this.onColorChanged,
    this.availableColors,
    this.itemSize = 45.0,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlockPicker(
        pickerColor: currentColor,
        onColorChanged: onColorChanged,
        availableColors:
            availableColors ??
            [
              Colors.pink,
              Colors.red,
              Colors.deepOrange,
              Colors.orange,
              Colors.amber,
              Colors.yellow,
              Colors.lime,
              Colors.lightGreen,
              Colors.green,
              Colors.teal,
              Colors.cyan,
              Colors.lightBlue,
              Colors.blue,
              Colors.indigo,
              Colors.deepPurple,
              Colors.purple,
              Colors.brown,
              Colors.grey,
              Colors.blueGrey,
              Colors.black,
            ],
        itemBuilder:
            (Color color, bool isCurrentColor, void Function() changeColor) {
              return Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: color,
                  border: Border.all(
                    color: isCurrentColor ? Colors.white : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: isCurrentColor
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: changeColor,
                    borderRadius: BorderRadius.circular(8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: itemSize,
                      height: itemSize,
                      child: isCurrentColor
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  ),
                ),
              );
            },
      ),
    );
  }
}

/// Material Design color picker
class MaterialColorPickerWidget extends StatelessWidget {
  final Color currentColor;
  final Function(Color) onColorChanged;

  const MaterialColorPickerWidget({
    super.key,
    required this.currentColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: MaterialPicker(
        pickerColor: currentColor,
        onColorChanged: onColorChanged,
        enableLabel: false,
      ),
    );
  }
}

/// Color selector button that shows a bottom sheet with color picker
class ColorSelectorButton extends StatefulWidget {
  final Color? selectedColor;
  final Function(Color) onColorChanged;
  final String title;
  final ColorPickerType pickerType;
  final double buttonSize;
  final double pickerHeight;

  const ColorSelectorButton({
    super.key,
    this.selectedColor,
    required this.onColorChanged,
    this.title = 'Pick a color',
    this.pickerType = ColorPickerType.block,
    this.buttonSize = 48,
    this.pickerHeight = 400,
  });

  @override
  State<ColorSelectorButton> createState() => _ColorSelectorButtonState();
}

class _ColorSelectorButtonState extends State<ColorSelectorButton> {
  late Color _currentColor;
  late ColorPickerType _pickerType;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.selectedColor ?? Colors.blue;
    _pickerType = widget.pickerType ?? ColorPickerType.block;
  }

  void _showColorPicker() {
    Color tempColor = _currentColor;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: widget.pickerHeight,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: CupertinoColors.systemGrey5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // SizedBox(width: 24),
                        Padding(
                          padding: EdgeInsetsGeometry.only(left: 10),
                          child: CupertinoButton(
                            borderRadius: BorderRadius.circular(25),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.symmetric(horizontal: 16),
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
                          'Select Color',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.only(right: 10),
                          child: IconButton(
                            tooltip: 'Toggle view',
                            icon: Icon(
                              _pickerType == ColorPickerType.block
                                  ? Icons.grid_view
                                  : Icons.view_list,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_pickerType == ColorPickerType.block) {
                                  _pickerType = ColorPickerType.material;
                                } else {
                                  _pickerType = ColorPickerType.block;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Expanded(
                    child: _pickerType == ColorPickerType.block
                        ? _buildColorPicker(tempColor, (color) {
                            setState(() {
                              _currentColor = color;
                              tempColor = color;
                              // widget.onColorChanged(tempColor);
                            });
                          })
                        // SimpleColorPickerWidget(
                        //     currentColor: tempColor,
                        //     onColorChanged: (color) {
                        //       setState(() {
                        //         // _currentColor = color;
                        //         tempColor = color;
                        //         // widget.onColorChanged(tempColor);
                        //       });
                        //     },
                        //   )
                        : _pickerType == ColorPickerType.material
                        ? _buildColorPicker(tempColor, (color) {
                            setState(() {
                              _currentColor = color;
                              tempColor = color;
                              // widget.onColorChanged(tempColor);
                            });
                          })
                        // MaterialColorPickerWidget(
                        //     currentColor: tempColor,
                        //     onColorChanged: (color) {
                        //       setState(() {
                        //         // _currentColor = color;
                        //         tempColor = color;
                        //         // widget.onColorChanged(tempColor);
                        //       });
                        //     },
                        //   )
                        : _buildColorPicker(tempColor, (color) {
                            setState(() {
                              _currentColor = color;
                              tempColor = color;
                              // widget.onColorChanged(tempColor);
                            });
                          }),

                    // ColorPickerWidget(
                    //     currentColor: tempColor,
                    //     onColorChanged: (color) {
                    //       setState(() {
                    //         // _currentColor = color;
                    //         tempColor = color;
                    //         // widget.onColorChanged(tempColor);
                    //       });
                    //     },
                    //   ),

                    // _buildColorPicker(tempColor, ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentColor = tempColor;
                          });
                          widget.onColorChanged(tempColor);
                          Navigator.of(context).pop(tempColor);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tempColor,
                          foregroundColor: _getContrastColor(tempColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Select Color',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildColorPicker(Color color, Function(Color) onChanged) {
    switch (_pickerType) {
      case ColorPickerType.full:
        return ColorPickerWidget(
          currentColor: color,
          onColorChanged: onChanged,
        );
      case ColorPickerType.block:
        return SimpleColorPickerWidget(
          currentColor: color,
          onColorChanged: onChanged,
        );
      case ColorPickerType.material:
        return MaterialColorPickerWidget(
          currentColor: color,
          onColorChanged: onChanged,
        );
    }
  }

  Color _getContrastColor(Color color) {
    // Calculate luminance to determine if text should be black or white
    final red = (color.r * 255.0).round() & 0xff;
    final green = (color.g * 255.0).round() & 0xff;
    final blue = (color.b * 255.0).round() & 0xff;
    final luminance = (0.299 * red + 0.587 * green + 0.114 * blue) / 255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _showColorPicker,
      icon: Icon(Icons.invert_colors, size: 36, color: _currentColor),
    );

    // InkWell(
    //   onTap: _showColorPicker,
    //   borderRadius: BorderRadius.circular(12),
    //   child: Container(
    //     padding: const EdgeInsets.all(16),
    //     decoration: BoxDecoration(
    //       border: Border.all(color: Colors.grey.shade300),
    //       borderRadius: BorderRadius.circular(12),
    //     ),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Row(
    //           children: [
    //             Container(
    //               width: widget.buttonSize,
    //               height: widget.buttonSize,
    //               decoration: BoxDecoration(
    //                 color: _currentColor,
    //                 borderRadius: BorderRadius.circular(8),
    //                 border: Border.all(color: Colors.grey.shade300, width: 2),
    //               ),
    //             ),
    //             const SizedBox(width: 12),
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 const Text(
    //                   'Color Selected',
    //                   style: TextStyle(
    //                     fontSize: 16,
    //                     fontWeight: FontWeight.w500,
    //                   ),
    //                 ),
    //                 const SizedBox(height: 2),
    //                 Text(
    //                   '#${_currentColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
    //                   style: TextStyle(
    //                     fontSize: 12,
    //                     color: Colors.grey.shade600,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //         Icon(Icons.chevron_right, color: Colors.grey.shade600),
    //       ],
    //     ),
    //   ),
    // );
  }
}

/// Enum for different color picker types
enum ColorPickerType {
  full, // Full HSV/RGB picker with sliders
  block, // Simple block-based picker
  material, // Material Design colors
}
