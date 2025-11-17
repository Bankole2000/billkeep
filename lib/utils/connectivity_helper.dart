import 'dart:async';
import 'dart:io';

/// Helper class for checking network connectivity
class ConnectivityHelper {
  /// Check if device has internet connectivity
  ///
  /// Attempts to lookup a reliable host to verify internet access
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));

      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Check connectivity with a custom timeout
  static Future<bool> hasInternetConnectionWithTimeout(Duration timeout) async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(timeout);

      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
