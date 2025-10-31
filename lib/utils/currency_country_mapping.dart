/// Mapping of currency codes to their primary country ISO2 codes
/// Use this reference to add countryISO2 fields to default_currencies.dart
const Map<String, String> currencyToCountryMapping = {
  // Already added
  'USD': 'US',
  'CAD': 'CA',
  'EUR': 'EU', // European Union (special case)
  'AED': 'AE',
  'AFN': 'AF',
  'ALL': 'AL',
  'AMD': 'AM',
  'ARS': 'AR',
  'AUD': 'AU',
  'AZN': 'AZ',
  'BAM': 'BA',

  // Need to add
  'BDT': 'BD', // Bangladesh
  'BGN': 'BG', // Bulgaria
  'BHD': 'BH', // Bahrain
  'BIF': 'BI', // Burundi
  'BND': 'BN', // Brunei
  'BOB': 'BO', // Bolivia
  'BRL': 'BR', // Brazil
  'BWP': 'BW', // Botswana
  'BYN': 'BY', // Belarus
  'BZD': 'BZ', // Belize
  'CDF': 'CD', // Congo (Democratic Republic)
  'CHF': 'CH', // Switzerland
  'CLP': 'CL', // Chile
  'CNY': 'CN', // China
  'COP': 'CO', // Colombia
  'CRC': 'CR', // Costa Rica
  'CUP': 'CU', // Cuba
  'CVE': 'CV', // Cape Verde
  'CZK': 'CZ', // Czech Republic
  'DJF': 'DJ', // Djibouti
  'DKK': 'DK', // Denmark
  'DOP': 'DO', // Dominican Republic
  'DZD': 'DZ', // Algeria
  'EEK': 'EE', // Estonia (discontinued)
  'EGP': 'EG', // Egypt
  'ERN': 'ER', // Eritrea
  'ETB': 'ET', // Ethiopia
  'GBP': 'GB', // United Kingdom
  'GEL': 'GE', // Georgia
  'GHS': 'GH', // Ghana
  'GNF': 'GN', // Guinea
  'GTQ': 'GT', // Guatemala
  'HKD': 'HK', // Hong Kong
  'HNL': 'HN', // Honduras
  'HRK': 'HR', // Croatia
  'HUF': 'HU', // Hungary
  'IDR': 'ID', // Indonesia
  'ILS': 'IL', // Israel
  'INR': 'IN', // India
  'IQD': 'IQ', // Iraq
  'IRR': 'IR', // Iran
  'ISK': 'IS', // Iceland
  'JMD': 'JM', // Jamaica
  'JOD': 'JO', // Jordan
  'JPY': 'JP', // Japan
  'KES': 'KE', // Kenya
  'KHR': 'KH', // Cambodia
  'KMF': 'KM', // Comoros
  'KRW': 'KR', // South Korea
  'KWD': 'KW', // Kuwait
  'KZT': 'KZ', // Kazakhstan
  'LBP': 'LB', // Lebanon
  'LKR': 'LK', // Sri Lanka
  'LTL': 'LT', // Lithuania (discontinued)
  'LVL': 'LV', // Latvia (discontinued)
  'LYD': 'LY', // Libya
  'MAD': 'MA', // Morocco
  'MDL': 'MD', // Moldova
  'MGA': 'MG', // Madagascar
  'MKD': 'MK', // North Macedonia
  'MMK': 'MM', // Myanmar
  'MOP': 'MO', // Macau
  'MUR': 'MU', // Mauritius
  'MXN': 'MX', // Mexico
  'MYR': 'MY', // Malaysia
  'MZN': 'MZ', // Mozambique
  'NAD': 'NA', // Namibia
  'NGN': 'NG', // Nigeria
  'NIO': 'NI', // Nicaragua
  'NOK': 'NO', // Norway
  'NPR': 'NP', // Nepal
  'NZD': 'NZ', // New Zealand
  'OMR': 'OM', // Oman
  'PAB': 'PA', // Panama
  'PEN': 'PE', // Peru
  'PHP': 'PH', // Philippines
  'PKR': 'PK', // Pakistan
  'PLN': 'PL', // Poland
  'PYG': 'PY', // Paraguay
  'QAR': 'QA', // Qatar
  'RON': 'RO', // Romania
  'RSD': 'RS', // Serbia
  'RUB': 'RU', // Russia
  'RWF': 'RW', // Rwanda
  'SAR': 'SA', // Saudi Arabia
  'SDG': 'SD', // Sudan
  'SEK': 'SE', // Sweden
  'SGD': 'SG', // Singapore
  'SOS': 'SO', // Somalia
  'SYP': 'SY', // Syria
  'THB': 'TH', // Thailand
  'TND': 'TN', // Tunisia
  'TOP': 'TO', // Tonga
  'TRY': 'TR', // Turkey
  'TTD': 'TT', // Trinidad and Tobago
  'TWD': 'TW', // Taiwan
  'TZS': 'TZ', // Tanzania
  'UAH': 'UA', // Ukraine
  'UGX': 'UG', // Uganda
  'UYU': 'UY', // Uruguay
  'UZS': 'UZ', // Uzbekistan
  'VEF': 'VE', // Venezuela
  'VND': 'VN', // Vietnam
  'XAF': 'CM', // Central African CFA Franc (Cameroon as primary)
  'XCD': 'AG', // East Caribbean Dollar (Antigua and Barbuda as primary)
  'XOF': 'SN', // West African CFA Franc (Senegal as primary)
  'YER': 'YE', // Yemen
  'ZAR': 'ZA', // South Africa
  'ZMK': 'ZM', // Zambia
  'ZWL': 'ZW', // Zimbabwe
};

/// Instructions for adding countryISO2 to default_currencies.dart:
///
/// For each currency in fiatCurrencies map, add this line after 'name_plural':
/// 'countryISO2': '<ISO2_CODE>',
///
/// Example:
/// 'USD': {
///   'symbol': '\$',
///   'name': 'US Dollar',
///   'symbol_native': '\$',
///   'decimal_digits': 2,
///   'rounding': 0,
///   'code': 'USD',
///   'name_plural': 'US dollars',
///   'countryISO2': 'US',  // <-- Add this line
/// },
