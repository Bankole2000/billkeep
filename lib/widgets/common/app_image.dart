import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final String? semanticLabel;
  final bool circular;

  const AppImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.semanticLabel,
    this.circular = false,
  });

  @override
  Widget build(BuildContext context) {
    // Handle null URLs
    if (imageUrl == null || imageUrl!.isEmpty) {
      return circular
          ? ClipOval(
              child: ImagePlaceholder(width: width, height: height),
            )
          : ImagePlaceholder(width: width, height: height);
    }

    final image = Image.network(
      imageUrl!,
      width: width,
      height: height,
      fit: fit,
      semanticLabel: semanticLabel,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Image load error: $error');
        return ImagePlaceholder(width: width, height: height);
      },
    );

    return circular ? ClipOval(child: image) : image;
  }
}

class ImagePlaceholder extends StatelessWidget {
  final double? width;
  final double? height;

  const ImagePlaceholder({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Center(
        child: Icon(Icons.image, color: Colors.grey[400], size: 40),
      ),
    );
  }
}
