import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Default HTTP headers to use for image requests
/// Includes User-Agent to prevent 403 errors from some servers
const Map<String, String> defaultImageHeaders = {
  'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
};

/// Helper function to create a CachedNetworkImageProvider with default headers
CachedNetworkImageProvider cachedImageProvider(String url) {
  return CachedNetworkImageProvider(
    url,
    headers: defaultImageHeaders,
  );
}
