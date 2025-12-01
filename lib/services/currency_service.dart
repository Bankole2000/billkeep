import 'package:billkeep/database/database.dart';
import 'package:billkeep/models/currency_model.dart';
import 'package:billkeep/repositories/currency_repository.dart';
import 'package:billkeep/providers/currency_provider.dart';
import 'package:billkeep/utils/connectivity_helper.dart';
import 'base_api_service.dart';

/// Service for managing currency operations
///
/// Follows local-first architecture:
/// 1. Create/update in local DB first (optimistic update)
/// 2. Check connectivity and sync with backend if online
/// 3. Fallback to local data if offline or API fails
class CurrencyService extends BaseApiService {
  final CurrencyRepository _repository;

  CurrencyService(this._repository);

  /// Create a new currency
  ///
  /// Local-first approach:
  /// 1. Create in local DB first with generated ID and tempID
  /// 2. Check connectivity and send to backend if online
  /// 3. Realtime sync will update with canonical ID when backend confirms
  Future<Currency> createCurrency(CurrencyModel newCurrency) async {
    // 1. Create in local database first (optimistic)
    final tempId = await _repository.createCurrency(newCurrency);

    // 2. Check connectivity and send to backend if online
    final isOnline = await ConnectivityHelper.hasInternetConnection();

    if (isOnline && newCurrency.user != null) {
      try {
        // Send to backend API
        await executeRequest<Map<String, dynamic>>(
          request: () => dio.post(
            '/currencies/records',
            data: newCurrency.toJson()..['tempId'] = tempId,
          ),
          parser: (data) => data as Map<String, dynamic>,
        );

        // Note: Realtime sync service will handle updating local DB with canonical ID
        // For now, return the local currency
      } catch (e) {
        // If API fails, we still have local copy
        print('API call failed, currency saved locally: $e');
      }
    }

    // Return the local currency
    final currency = await _repository.getCurrencyByTempId(tempId);
    if (currency != null) {
      return currency;
    }
    throw Exception('Failed to create currency');
  }

  /// Update an existing currency
  ///
  /// Local-first approach:
  /// 1. Update in local DB first
  /// 2. Check connectivity and sync to backend if online
  Future<void> updateCurrency(CurrencyModel updatedCurrency) async {
    // 1. Update in local database first
    await _repository.updateCurrency(updatedCurrency);

    // 2. Check connectivity and send to backend if online
    final isOnline = await ConnectivityHelper.hasInternetConnection();

    if (isOnline && updatedCurrency.user != null) {
      try {
        // final updateData = <String, dynamic>{};
        // if (name != null) updateData['name'] = name;
        // if (symbol != null) updateData['symbol'] = symbol;
        // if (decimals != null) updateData['decimals'] = decimals;
        // if (countryISO2 != null) updateData['countryISO2'] = countryISO2;
        // if (isCrypto != null) updateData['isCrypto'] = isCrypto;
        // if (isActive != null) updateData['isActive'] = isActive;

        await executeRequest<Map<String, dynamic>>(
          request: () => dio.patch(
            '/currencies/records/${updatedCurrency.id}',
            data: updatedCurrency.toJson(),
          ),
          parser: (data) => data as Map<String, dynamic>,
        );
      } catch (e) {
        // If API fails, local update is already done
        print('API call failed, currency updated locally: $e');
      }
    }
  }

  /// Delete a currency
  ///
  /// Only deletes if not used in any transactions/wallets
  /// Local-first approach with backend sync
  Future<void> deleteCurrency(String currencyCode, {String? userId}) async {
    // 1. Delete from local database first (will throw if currency is in use)
    await _repository.deleteCurrency(currencyCode);

    // 2. Check connectivity and send to backend if online
    final isOnline = await ConnectivityHelper.hasInternetConnection();

    if (isOnline && userId != null) {
      try {
        await executeVoidRequest(
          request: () =>
              dio.delete('/currencies/records/${currencyCode.toUpperCase()}'),
        );
      } catch (e) {
        // If API fails, local deletion is already done
        print('API call failed, currency deleted locally: $e');
      }
    }
  }

  /// Get a single currency by code
  Future<Currency?> getCurrency(String currencyCode) async {
    return await _repository.getCurrency(currencyCode);
  }

  /// Get all currencies
  Future<List<Currency>> getAllCurrencies() async {
    return await _repository.getAllCurrencies();
  }

  /// Get active currencies only
  Future<List<Currency>> getActiveCurrencies() async {
    return await _repository.getActiveCurrencies();
  }

  /// Get inactive currencies only
  Future<List<Currency>> getInactiveCurrencies() async {
    return await _repository.getInactiveCurrencies();
  }

  /// Get fiat currencies (non-crypto)
  Future<List<Currency>> getFiatCurrencies() async {
    return await _repository.getFiatCurrencies();
  }

  /// Get crypto currencies
  Future<List<Currency>> getCryptoCurrencies() async {
    return await _repository.getCryptoCurrencies();
  }

  /// Search currencies by name, code, or symbol
  Future<List<Currency>> searchCurrencies(String query) async {
    return await _repository.searchCurrencies(query);
  }

  /// Get currencies by country ISO2 code
  Future<List<Currency>> getCurrenciesByCountry(String countryISO2) async {
    return await _repository.getCurrenciesByCountry(countryISO2);
  }

  /// Check if a currency code exists
  Future<bool> currencyExists(String currencyCode) async {
    return await _repository.currencyExists(currencyCode);
  }

  /// Toggle currency active status
  Future<void> toggleCurrencyStatus(
    String currencyCode, {
    String? userId,
  }) async {
    final currency = await _repository.getCurrency(currencyCode);
    if (currency == null) {
      throw Exception('Currency not found');
    }

    // await updateCurrency(
    //   currencyCode: currencyCode,
    //   isActive: !currency.isActive,
    //   userId: userId,
    // );
  }

  /// Sync currencies from backend
  ///
  /// Fetches all currencies from the backend and updates local database
  Future<void> syncFromBackend({String? userId}) async {
    final isOnline = await ConnectivityHelper.hasInternetConnection();

    if (!isOnline) {
      throw Exception('No internet connection');
    }

    try {
      final currencies = await executeListRequest<Currency>(
        request: () => dio.get('/currencies/records'),
        itemParser: (json) => Currency(
          id: json['id'] as String,
          code: json['code'] as String,
          name: json['name'] as String,
          symbol: json['symbol'] as String,
          decimals: json['decimals'] as int,
          countryISO2: json['countryISO2'] as String?,
          isCrypto: json['isCrypto'] as bool,
          isActive: json['isActive'] as bool,
          tempId: json['tempId'] as String? ?? json['code'] as String,
          userId: json['user'] as String?,
        ),
      );

      // Update local database with synced currencies
      // Note: This is a simplified approach. In production, you'd want
      // more sophisticated sync logic to handle conflicts
      for (final currency in currencies) {
        final exists = await _repository.currencyExists(currency.code);
        if (exists) {
          // await _repository.updateCurrency(
          //   currencyCode: currency.code,
          //   name: currency.name,
          //   symbol: currency.symbol,
          //   decimals: currency.decimals,
          //   countryISO2: currency.countryISO2,
          //   isCrypto: currency.isCrypto,
          //   isActive: currency.isActive,
          // );
        } else {
          // Currency doesn't exist locally, would need to insert
          // This would require extending the repository
          print('Currency ${currency.code} from backend not in local DB');
        }
      }
    } catch (e) {
      throw Exception('Failed to sync currencies from backend: $e');
    }
  }
}
