class Validators {
  static bool isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }
}
