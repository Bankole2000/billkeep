import 'package:flutter/material.dart';

class DynamicAvatar extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? color;
  final IconData? icon;
  final Offset? emojiOffset;
  final ImageProvider? image;
  final String? emoji;
  final double size;
  final bool circular;
  final double borderRadius;
  // ... other parameters

  const DynamicAvatar({
    super.key,
    this.color,
    this.icon,
    this.image,
    this.emoji,
    this.emojiOffset,
    this.size = 40,
    this.circular = true,
    this.borderRadius = 8,
    this.onTap,
  }) : assert(icon != null || image != null || color != null || emoji != null);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: circular
          ? BorderRadius.circular(size)
          : BorderRadius.circular(borderRadius),
      child: Container(
        // ... your existing container code
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color ?? Colors.grey[300],
          image: image != null
              ? DecorationImage(image: image!, fit: BoxFit.cover)
              : null,
          shape: circular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: circular ? null : BorderRadius.circular(borderRadius),
        ),
        child: emoji != null
            ? Transform.translate(
                offset: emojiOffset ?? Offset(7, 5),
                child: Text(emoji!, style: TextStyle(fontSize: 26)),
              )
            : icon != null
            ? Icon(icon, color: Colors.white, size: size * 0.5)
            : null,
      ),
    );
  }
}
