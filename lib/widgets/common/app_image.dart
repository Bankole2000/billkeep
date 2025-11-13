import 'package:cached_network_image/cached_network_image.dart';
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

    final image = CachedNetworkImage(
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      httpHeaders: const {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
      },
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) {
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
